/* 36AM9T7  - etfp.c created by Pip@CPAN.Org to gET && sET GNU/Linux
 *   console Fonts && Palettes.  This utility was derived from 
 *   Fonter   written by Chris Monahan <roler@primenet.com> &&
 *   setcolor written by Bob McCracken  <kerouac@ssnet.com>
 * 2do:
 *   ck if font ops need closing escapes from fonter too
 *   add ioctl return code error cks to pal calls too
 * Notz:
 *   0. The palette numbering scheme conforms to the ANSI standard,
 *     (1 = red,  4 = blue, etc.), NOT to the VGA numbering scheme
 *     (1 = blue, 4 = red,  etc.).
 *   1. RGB levels are in the range 0..255.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License Version 2 as 
 * published by the Free Software Foundation
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/kd.h>
#include <sys/ioctl.h>

const unsigned int  mjvr    =  1;
const unsigned int  mnvr    =  0;
const unsigned char ptvr[8] = "41O0KHw\0"; 
extern int opterr, optind;
int indx = 0, jndx = 0, offs = 0, hite = 16;
char *term;
char  filn[256], parm[256], hedr[4] = { 0x36, 0x04, 0x00, 0x00 }; // hite last
FILE *FILN;
unsigned char cpal[48], font[4096], buff[8192], dumy;
unsigned char dpal[48] = { // Dfalt kernel color after booting
  0x00, 0x00, 0x00, 0xAA, 0x00, 0x00, 0x00, 0xAA, 0x00, 0xAA, 0x55, 0x00,
  0x00, 0x00, 0xAA, 0xAA, 0x00, 0xAA, 0x00, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA,
  0x55, 0x55, 0x55, 0xFF, 0x55, 0x55, 0x55, 0xFF, 0x55, 0xFF, 0xFF, 0x55,
  0x55, 0x55, 0xFF, 0xFF, 0x55, 0xFF, 0x55, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
struct consolefontdesc cfnt;
/*struct consolefontdesc {
    unsigned short charcount;  // characters in font (256 or 512)         
    unsigned short charheight; // scan lines per character (1-32)         
    char          *chardata;   // font data in expanded form (8192 bytes) 
  }*/
unsigned char GSMD = 0, PFMD = 0, RSET = 0, PSFF = 1, SETP = 0, 
              LOCL = 0, HELP = 0, SHOV = 0;
// Dfalt Flags: GetMode, PalMode, don't reset pal, .psf files, Set Pal flag, 
//     set pals are global (!local), don't show help, don't show version info

int NumbTest() { // test if a particular parameter is entirely numbers
  int cndx;
  for(cndx = 0; cndx < strlen(parm); cndx++) {
    if(parm[cndx] < '0' || '9' < parm[cndx]) { return(0); }
  }
  return(1);
}

void RsetPale() { // reset palette through appropriate method
  int pndx;
  if(LOCL && strcmp(term, "xterm")) { // just reset local virtual terminal
    printf ("\e]R"); // escape reset (doesn't work on xterm)
  } else { // reinitialize global palette
    for(pndx = 0; pndx < 48; pndx++) { cpal[pndx] = dpal[pndx]; }
    ioctl(0, PIO_CMAP, &cpal);
  }
}

void PrntPale(int pndx) { // print one palette index && rgb values
  printf("%d %d %d %d   ", pndx, 
    cpal[(pndx * 3) + 0], cpal[(pndx * 3) + 1], cpal[(pndx * 3) + 2]);
}

void GettPale(int qndx) { // print all palette values or just chosen one
  ioctl(0, GIO_CMAP, &cpal);
  if(qndx == -1) { for(qndx = 0; qndx < 16; qndx++) { PrntPale(qndx); } }
  else           {                                    PrntPale(qndx);   }
  printf("\n");
}

void SettPale(int pndx, int redd, int grnn, int bluu) { // set palette values
  if(LOCL) { // just change local virtual terminal
    if(!strcmp(term, "xterm")) { // xterm
      printf("\e]4;%d;#%2.2x%2.2x%2.2x\e\\", pndx, redd, grnn, bluu);
      if       (pndx == 0) { // If setting 'black', also set the background 
        printf("\e]11;#%2.2x%2.2x%2.2x\e\\",       redd, grnn, bluu);
      } else if(pndx == 7) { // if setting 'white', also set the foreground 
        printf("\e]10;#%2.2x%2.2x%2.2x\e\\",       redd, grnn, bluu);
      }
    } else { // GNU/Linux console
      printf("\e]P%1.1X%2.2X%2.2X%2.2X", pndx, redd, grnn, bluu); 
    }
  } else { // change global palette
    ioctl(0, GIO_CMAP, &cpal);
    if(0 <= pndx && pndx <= 15  && 0 <= redd && redd <= 255 &&
       0 <= grnn && grnn <= 255 && 0 <= bluu && bluu <= 255) {
      cpal[(pndx * 3) + 0] = redd;
      cpal[(pndx * 3) + 1] = grnn;
      cpal[(pndx * 3) + 2] = bluu;
    }
    ioctl(0, PIO_CMAP, &cpal);
  }
}

int main(int argc, char **argv) {
  term = getenv("TERM");
  strcpy(filn, "DfltFont.psf");
  hedr[3] = hite;
  if(argc > 1) { // there's params to process
    opterr = 0; // don't display pal since there are params
    for(indx = 1; indx < argc; indx++) { // parse command-line params
      if(!strcmp(argv[indx], "--help")) { HELP = 1; } // help mode
      if(!strcmp(argv[indx], "-h")) { HELP = 1; } 
      if(!strcmp(argv[indx], "-?")) { HELP = 1; } 
      if(!strcmp(argv[indx], "-g")) { GSMD = 0; } // get mode
      if(!strcmp(argv[indx], "-s")) { GSMD = 1; } // set mode
      if(!strcmp(argv[indx], "-w")) { GSMD = 1; } //  aka write mode
      if(!strcmp(argv[indx], "-p")) { PFMD = 0; } // pal  mode
      if(!strcmp(argv[indx], "-f")) { PFMD = 1; } // font mode
      if(!strcmp(argv[indx], "-l")) { LOCL = 1; } // local SetPal mode
      if(!strcmp(argv[indx], "-o")) { PSFF = 0; } // not .psf files(.fnt instd)
      if(!strcmp(argv[indx], "-r")) { RSET = 1; } // reset pal
      if(!strcmp(argv[indx], "-v")) { SHOV = 1; } // just print Version
      if(!strstr(argv[indx], "-"))  { // param that doesn't start with "-"
        strcpy(parm, argv[indx + 0]);
        if(strlen(argv[indx + 0]) <= 2 && NumbTest()) {
          if((indx + 3) <= argc) {
            strcpy(parm, argv[indx + 1]);
            if(NumbTest()) {
              strcpy(parm, argv[indx + 2]);
              if(NumbTest()) {
                strcpy(parm, argv[indx + 3]);
                if(NumbTest()) {
                  SETP = 1; GSMD = 1;
                }
              }
            }
          }
          if(SETP) {
            SettPale(atoi(argv[indx + 0]), atoi(argv[indx + 1]), 
                     atoi(argv[indx + 2]), atoi(argv[indx + 3]));
            indx += 3; SETP = 0;
          } else {
            GettPale(atoi(argv[indx])); // just a getpal index
          }
        } else {
          strcpy(filn, argv[indx]); // non-default font filename
        }
      }
      if(RSET) { RsetPale(); RSET = 0; }
    }
  }
  if(HELP) { // show help info && exit
    printf("
Usage: etfp [OPTIONS] [-f FontFile.psf] [PalIndex [PalRed PalGreen PalBlue]]
Description: etfp is a simple utility to sET or gET GNU/Linux console
  Fonts or Palettes.

OPTIONS    DESCRIPTION
  -h         Show this Help text
  -v         Show Version info.
  -g         Get mode.  (default)
  -s         Set mode.
  -p         Pal  mode. (default)
  -f         Font mode.
  -l         Local SetPal mode (makes palette change to current vterm only).
  -o         Omit font headers (ie. Use .fnt files instead of default .psf).
  -r         Reset palette values.

    Default behavior is to Get current Palette data (ie. print pal data ints).
    If PalIndex is supplied, that specific pal entry's RGB values are printed.
    If Pal Red, Green, && Blue follow the Index, etfp automagically changes
      to Set mode to update that palette entry.
    If Font mode is initiated, the default Get behavior obtains the current
      console font && writes it to FontFile.psf.
    If no FontFile parameter is given, then \"DfltFont.psf\" is used.\n
"); // poop on stupid compilers that deprecate multi-line strings! =(
    return(0);
  }
  if(SHOV) {
    printf("etfp v%d.%d.%s - by Pip Stuart <Pip@CPAN.Org>\n", mjvr, mnvr, ptvr);
    return(0);
  }
  if(PFMD) { // font stuff
    if(getenv("DISPLAY")) { // font opers are bad in X, mmmkay?
      printf("!EROR! Please don't run etfp font commands from X windows.\n");
      return(1);
    }
    printf("\e(U\e(K"); // this line forces whole font to update the sys char generator
    if(GSMD && ((FILN = fopen(filn, "r")) != NULL)) { // Set Mode
      if(PSFF) { fread(&hedr, 4, 1, FILN); }    // read  .psf file header
      hite = hedr[3];
      for(indx = 0; indx < 256; indx++) { 
        fread(&buff[indx*32], hite, 1, FILN); 
      }
      fclose(FILN);
      if(ioctl(dumy, PIO_FONT, buff) == -1) {   // set(aka put) font data
        perror("ioctlPIO_FONT"); close(dumy); exit(-1); 
      }
    } else {                                          // Get Mode
      if((FILN = fopen(filn, "w")) == NULL) {
        printf("!EROR! Cannot write to file!\n");
        return(1);
      } else {
        if(ioctl(dumy, GIO_FONTX, &cfnt) == -1) { // get per char height
          perror("ioctlGIO_FONTX"); close(dumy); exit(-1); 
        }
//        printf("CharCoun:%u\nCharHite:%u\nFontData:%s\n", 
//               cfnt.charcount, cfnt.charheight, cfnt.chardata);
        hite = cfnt.charheight;
        hedr[3] = hite;
        if(PSFF) { fwrite(&hedr, 4, 1, FILN); } // write .psf file header
        memset(buff, 0, sizeof(buff));
        memset(font, 0, sizeof(font));
        if(ioctl(dumy, GIO_FONT, buff) == -1) {   // get font data
          perror("ioctlGIO_FONT"); close(dumy); exit(-1); 
        }
        for(indx = 0; indx < 256; indx++) {
          fwrite(&buff[indx * 32], hite, 1, FILN);
          for(jndx = 0; jndx < hite; jndx++) { 
            font[offs++] = buff[(indx * 32) + jndx]; 
          }
        }
        fclose(FILN);
      }
    }
  } else { // Pal Mode
// non-Dfalt (Gett|Sett|Rset)Pale() calls all happen in param processing above
    if(!GSMD) { GettPale(-1); } // Dfalt get all pal values
  }
  return(0);
}
