LD= -l:libjpeg.so.62  -lm

all: embed decode 

embed: embed.o
	$(CC) embed.o  -o embed $(LD)

decode: decode.o 
	$(CC) decode.o -o decode $(LD)


