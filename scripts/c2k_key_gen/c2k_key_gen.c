/*
 * c2k_key_gen.c -- AES and RSA key generation utility
 *
 * Copyright (C) 2014 by Mindspeed Technologies
 *
 * This software is distributed under the terms of the GNU General
 * Public License ("GPL") as published by the Free Software Foundation,
 * either version 2 of that License or (at your option) any later version.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <fcntl.h>
#include <sys/types.h>

#define C2K_KEY_LENGTH_4K	512
#define MAX_KEY_FILE_SIZE 	(1024+1) //It can hold 4096 bit key in ascii string

int bn_atoi(char *keyfile, unsigned char *key, int maxkeylen)
{
	int infd=0,outfd=0;
	int ret=0;
	int i,boffset=0;
	unsigned char k,c;
	char astr[MAX_KEY_FILE_SIZE];
	struct stat st;

	infd = open(keyfile, O_RDONLY);
	if(infd < 0) {
		printf("Failed to open file\n");
		goto bad_exit;
	}
	stat(keyfile, &st);
	if(st.st_size > MAX_KEY_FILE_SIZE) {
		printf("Too big infile %d\n", (int)st.st_size);
		goto bad_exit;
	}

	if(read(infd, astr, st.st_size) != st.st_size) {
		printf("Failed to read from %s\n", keyfile);
		goto bad_exit;
	}
	for(i = 0; ((i<st.st_size) && (isxdigit((unsigned char)astr[i]))); i++)
	{
		c=astr[i];
		if((c >= '0') && (c <='9')) k=c-'0';
		else if ((c >= 'a') && (c <= 'f')) k=c-'a'+10;
		else if ((c >= 'A') && (c <= 'F')) k=c-'A'+10;
		else k = 0;

		boffset=i/2;
		if( boffset > maxkeylen)
			goto bad_exit;
		if(i%2)
			key[boffset] = key[boffset]|k;
		else
			key[boffset] = k<<4;

	}
	if(!boffset)
	 	goto bad_exit;

	boffset++; //To get length

	ret = boffset;
bad_exit:
	if(infd) close(infd);
	return ret;
}

int main(int argc, char *argv[])
{
	int fd1, keylen = 0;
	unsigned char pub_key_buf[C2K_KEY_LENGTH_4K];
	char *signature, *pblcky;

	if ( argc < 3 )
	{
		printf( "Usage: %s", argv[0] );
		goto out;
	}
	else
	{
		signature = argv[1];
		pblcky = argv[2];

		// Generating public key only
		{
			keylen = bn_atoi(pblcky, &pub_key_buf[0], C2K_KEY_LENGTH_4K);
			if ((keylen * 8) != 1024 && (keylen * 8) != 2048)
                        {
				printf("Key size %d bit not supported\n", keylen * 8);
                                goto out;
                        }
			else
			{
				printf("Public key length = %d.\n", keylen);
				if((fd1 = open(argv[1], O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) == -1)
				{
					printf("ERROR: Cannot create a file %s\n", argv[1]);
					goto out;
				}
	                        if(keylen != write(fd1, &pub_key_buf[0], keylen))
					printf("ERROR: Write to the file %s has failed\n", argv[1]);
				goto out;
			}
		}
	}

out:
	if(fd1) close(fd1);
	return 0;
}

