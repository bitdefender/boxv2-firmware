all: clean header

header:
	$(CC) c2k_image_gen.c -o c2k_image_gen

install:
	cp mk_c2k_image.sh /usr/local/bin/
	cp c2k_image_gen /usr/local/bin/

clean:
	rm -f c2k_image_gen *.c2kimg

