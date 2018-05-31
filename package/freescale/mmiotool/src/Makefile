
CC	=	gcc
CFLAGS	+= 	-g -O -Wall -Wshadow
ALL	=	mmiotool

%.o : %.c
	$(CC) $(CFLAGS) -c $<

all:	$(ALL)


mmiotool: mmiotool.o
	$(CC) $(CFLAGS) $(LDFLAGS) mmiotool.o -o mmiotool

clean:
	$(RM) *.o $(ALL)

