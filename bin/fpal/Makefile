#
# makefile for etfp
#
#CFLAGS=-s -O2 -DLINUX
CFLAGS=-s -O6 -mcpu=pentium -DLINUX
#LIBS=-lncurses
NAME=etfp
LNAME=etfp

etfp: etfp.o
	cc $(CFLAGS) -o $(NAME) etfp.o $(LIBS)
	@echo "### Compiling of etfp complete! ###"

etfp.o: etfp.c
	@echo "####### Now compiling etfp! #######"
	cc $(CFLAGS) -c etfp.c

clean:
	rm *.o etfp

tar:
	cd .. && tar cf - $(LNAME)/ | gzip -9 > $(LNAME)/$(LNAME).tar.gz
