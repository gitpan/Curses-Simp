# makefile for etfp
# Author: Pip Stuart <Pip@CPAN.Org>
#CFLAGS  = -s -O2 -DLINUX
CFLAGS  = -s -O6 -mcpu=pentium -DLINUX
NAME    = etfp
LNAME   = etfp
INSTALL = install

etfp: etfp.o
	cc $(CFLAGS) -o $(NAME) etfp.o $(LIBS)
	@echo "### Compiling of etfp complete! ###"

etfp.o: etfp.c
	@echo "####### Now compiling etfp! #######"
	cc $(CFLAGS) -c etfp.c

clean:
	rm *.o etfp

install: $(NAME)
	$(INSTALL) -m 775 $(NAME) /usr/local/bin/

tar:
	cd .. && tar cf - $(LNAME)/ | gzip -9 > $(LNAME)/$(LNAME).tgz
