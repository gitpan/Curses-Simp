# makefile for ximp
# Author: Pip Stuart <Pip@CPAN.Org>
#CFLAGS  = -s -O2 -DLINUX
CFLAGS  = -s -O6 -mcpu=pentium -DLINUX
NAME    = ximp
LNAME   = ximp
INSTALL = install

ximp: ximp.o
	cc $(CFLAGS) -o $(NAME) ximp.o $(LIBS)
	@echo "### Compiling of ximp complete! ###"

ximp.o: ximp.c
	@echo "####### Now compiling ximp! #######"
	cc $(CFLAGS) -c ximp.c

clean:
	rm *.o ximp

install: $(NAME)
	$(INSTALL) -m 775 $(NAME) /usr/local/bin/

tar:
	cd .. && tar cf - $(LNAME)/ | gzip -9 > $(LNAME)/$(LNAME).tgz
