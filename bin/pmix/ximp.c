//     ** XimP ** Ximp Is My Pmix - ximP yM sI pmiX ** PmiX **
// This is a cheezy CLI /dev/mixer manipulator derived from:
//   http://www.oreilly.de/catalog/multilinux/excerpt/ch14-07.htm
// on 11GLVFL (Tue Jan 16 21:31:15:21 2001) by Pip@CPAN.Org for Pimp
//   ximp has almost identical behavior to `aumix` for -v#, -w#, && -q

#include <stdio.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <linux/soundcard.h>

const unsigned int  mjvr     =  1;
const unsigned int  mnvr     =  0;
const unsigned char ptvr[8]  = "41O06H9\0";
const char *sdevnamz[] = SOUND_DEVICE_NAMES; // avail dev namz

int fild, devm, sdvz;    // file descriptor, device mask, sound devices
char *name;                // program name

void usag() {    // display command usage && exit w/ error status
    int indx;

    fprintf(stderr, " ximp v%d.%d.%s - by Pip Stuart <Pip@CPAN.Org>\n\n"
                    "usage: %s [-]<device>\n"
                    "       %s [-]<device>[+/-]<gain%%>\n"
                    "       %s [-]<device> [+/-]<left-gain%%> [+/-]<right-gain%%>\n\n"
                    "Where [?] is optional && <device> is one of:\n  all ", 
                    mjvr, mnvr, ptvr, name, name, name);
    for(indx = 0; indx<SOUND_MIXER_NRDEVICES; indx++) {
        if((1 << indx) & devm) { fprintf(stderr, "%s ", sdevnamz[indx]); }
    }
    fprintf(stderr, "\nUnique abbrev. of device names should work as well (except for 'all').\n");
    exit(1);
}

int main(int argc, char *argv[]) {
    int left, lft2, rite, rit2, levl, stat, dvic, indx, ndx2, mtch;
    char *devn, *lstr, *rstr; // mixer devname, leftstrn, ritestrn

    name = argv[0]; /* save program name */
    fild = open("/dev/mixer", O_RDONLY); // open mixer, read only
    if(fild == -1) { perror("unable to open /dev/mixer"); exit(1); }
    stat = ioctl(fild, SOUND_MIXER_READ_DEVMASK, &devm);
    if(stat == -1) { perror("SOUND_MIXER_READ_DEVMASK ioctl failed"); }
    stat = ioctl(fild, SOUND_MIXER_READ_STEREODEVS, &sdvz);
    if(stat == -1) { perror("SOUND_MIXER_READ_STEREODEVS ioctl failed"); }
    if(argc < 2 || argc > 4) { usag(); }    // call usage if wrong arg#
    devn = argv[1];    // save mixer devname
    for(indx = 0; indx < SOUND_MIXER_NRDEVICES; indx++) { // wich dvic 2 use
        if((1 << indx) & devm) {
            while(devn[0] == '-') { // optional -<device>
                ndx2 = 0; while(devn[ndx2++]) { devn[ndx2-1] = devn[ndx2]; }
            }
            mtch = 1; ndx2 = 0;
            if(devn[0] == 'h') { usag(); } // print usage for -help
            if(devn[0] == 'w' && sdevnamz[indx][0] == 'p' &&
                sdevnamz[indx][1] == 'c' &&    sdevnamz[indx][2] == 'm') {
                ndx2 = 1;
                break;
            } // shortcircuit if -w for pcm
            while((devn[ndx2] && ndx2 == 4 &&
                    devn[0]    == 'l' && devn[1] == 'i' && 
                    devn[2]    == 'n' && devn[3] == 'e' &&
                    devn[ndx2] == '1') ||    // weird hack for "line1"
    (devn[ndx2] &&     devn[ndx2] != '+' && devn[ndx2] != '-' && // && catch
                    devn[ndx2] != '0' && devn[ndx2] != '1' && // digits
                    devn[ndx2] != '2' && devn[ndx2] != '3' && // right
                    devn[ndx2] != '4' && devn[ndx2] != '5' && // after
                    devn[ndx2] != '6' && devn[ndx2] != '7' && // match
                    devn[ndx2] != '8' && devn[ndx2] != '9')) {
                if(devn[ndx2] != sdevnamz[indx][ndx2]) { mtch = 0; }
                ndx2++;
            } // loop through all of devname && serch for any !match
            if(mtch) { break; }
            if(devn[0] == 'a' && devn[1] == 'l' && devn[2] == 'l' && devn[3] == 0) { 
                indx = 255; break; 
            }    // hack for "all"
            if(devn[0] == 'q' && devn[1] == 0) { indx = 256; break; } // "-q"
        }
    }
    dvic = indx;    // got a valid dvic    
    if(ndx2 && devn[ndx2] && (devn[ndx2] == '+' || devn[ndx2] == '-' ||
        devn[ndx2] == '0' || devn[ndx2] == '1' || 
        devn[ndx2] == '2' || devn[ndx2] == '3' || 
        devn[ndx2] == '4' || devn[ndx2] == '5' || 
        devn[ndx2] == '6' || devn[ndx2] == '7' || 
        devn[ndx2] == '8' || devn[ndx2] == '9')) { 
        while(ndx2) {
            indx = 0; while(devn[indx++]) { devn[indx-1] = devn[indx]; }
            ndx2--;
        }
        lstr = rstr = devn;    indx = 127; // 127 is a flag for special argc==2
    }                                    // but behaves as if argc==3
    if(dvic < 255 && dvic == SOUND_MIXER_NRDEVICES) { /* didn't find a match */
        fprintf(stderr, "%s is not a valid mixer device\n", devn);
        usag();
    }
    if(argc == 4) { lstr = argv[2]; rstr = argv[3]; } // separate l/r argz
    if(argc == 3) { lstr = argv[2]; rstr = lstr; } // same arg for l&&r
    stat = ioctl(fild, MIXER_READ(dvic), &levl);
    if(stat == -1) { perror("MIXER_READ ioctl failed"); exit(1); }    
    lft2 = levl & 0xff; rit2 = (levl & 0xff00) >> 8; // unpack l2/r2
    if(argc == 2 && indx != 127) {
        left = lft2;
    } else if(lstr[0] == '+') { 
        ndx2 = 0; while(lstr[ndx2++]) { lstr[ndx2-1] = lstr[ndx2]; }
        left = lft2 + atoi(lstr); 
        if(argc < 4) {
            while(ndx2--) { lstr[ndx2+1] = lstr[ndx2]; }
            lstr[0] = '+'; // same char* as rstr so restore '+' in case
        }
    } else if(lstr[0] == '-') { 
        ndx2 = 0; while(lstr[ndx2++]) { lstr[ndx2-1] = lstr[ndx2]; }
        left = lft2 - atoi(lstr); 
        if(argc < 4) {
            while(ndx2--) { lstr[ndx2+1] = lstr[ndx2]; }
            lstr[0] = '-'; // "                           " '-' "     "
        }
    } else { left = atoi(lstr); }
    if       (argc == 2 && indx != 127) { 
        rite = rit2;
    } else if(rstr[0] == '+') { 
        ndx2 = 0; while(rstr[ndx2++]) { rstr[ndx2-1] = rstr[ndx2]; }    
        rite = rit2 + atoi(rstr); 
    } else if(rstr[0] == '-') { 
        ndx2 = 0; while(rstr[ndx2++]) { rstr[ndx2-1] = rstr[ndx2]; }
        rite = rit2 - atoi(rstr); 
    } else { rite = atoi(rstr); }
    if((argc > 2) && (left != rite) && !((1 << dvic) & sdvz) && dvic != 255) {
        fprintf(stderr, "warning: %s is not a stereo device\n", sdevnamz[dvic]);
    }
    levl = (rite << 8) + left;    // encode l/r into one levl
    if(dvic == 255) {
        for(indx = 0; indx<SOUND_MIXER_NRDEVICES; indx++) {
            if((1 << indx) & devm) { 
                stat = ioctl(fild, MIXER_READ(indx), &levl);
                if(stat == -1) { perror("MIXER_READ ioctl failed"); exit(1); }    
                left = levl & 0xff; rite = (levl & 0xff00) >> 8; // unpack l/r
                fprintf(stderr, "%8s: %0.2d%% / %0.2d%%\n", sdevnamz[indx], left, rite);
            }
        }
        if(argc > 2) {
            fprintf(stderr, "Sorry!  'all' currently is only able to list available mixer channel values.\nTo assign new values to all, each channel must be selected individually.\n");
        }
    } else if(dvic == 256) {
        for(indx = 0; indx<SOUND_MIXER_NRDEVICES; indx++) {
            if((1 << indx) & devm) { 
                stat = ioctl(fild, MIXER_READ(indx), &levl);
                if(stat == -1) { perror("MIXER_READ ioctl failed"); exit(1); }    
                left = levl & 0xff; rite = (levl & 0xff00) >> 8; // unpack l/r
                fprintf(stdout, "%s %d, %d\n", sdevnamz[indx], left, rite);
            }
        }
        if(argc > 2) {
            fprintf(stderr, "Sorry!  '-q' currently is only able to list available mixer channel values.\nTo assign new values to all, each channel must be selected individually.\n");
        }
    } else if(argc == 2 && indx != 127) { 
        fprintf(stderr, "%s: %d%% / %d%%\n", sdevnamz[dvic], left, rite);
    } else { // write new valz!
        stat = ioctl(fild, MIXER_WRITE(dvic), &levl);
        if (stat == -1) { perror("MIXER_WRITE ioctl failed"); exit(1); }
    }
    close(fild);    // close mixer && exit
    return 0;
}
