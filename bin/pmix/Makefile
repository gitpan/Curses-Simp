#
# makefile for ximp
#
#CFLAGS=-s -O2 -DLINUX
CFLAGS=-s -O6 -mcpu=pentium -DLINUX
#LIBS=-lncurses
NAME=ximp
LNAME=ximp

ximp: ximp.o
	cc $(CFLAGS) -o $(NAME) ximp.o $(LIBS)
	@echo "### Compiling of ximp complete! ###"

ximp.o: ximp.c
	@echo "####### Now compiling ximp! #######"
	cc $(CFLAGS) -c ximp.c

clean:
	rm *.o ximp

tar:
	cd .. && tar cf - $(LNAME)/ | gzip -9 > $(LNAME)/$(LNAME).tar.gz
