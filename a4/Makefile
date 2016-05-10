CC     = gcc
CFLAGS = -Wall
#CFLAGS = -Wall -g -DDEBUG
LIBS   = 
PRG    = grade

all   : $(PRG)

clean :
	rm -f $(PRG) a.out core *.o \#*

grade : grade.o
	$(CC) $(CFLAGS) $(LIBS) -o grade grade.c

