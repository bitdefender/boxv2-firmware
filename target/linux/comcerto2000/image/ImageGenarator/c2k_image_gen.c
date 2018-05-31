/*
 * c2k_image_gen.c -- secureboot header generation utility
 *
 * Copyright (C) Mindspeed Technologies
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
#include "header.h"
#include <fcntl.h>
#include <sys/types.h>

#define MAX_KEY_FILE_SIZE 	(1024+1) //It can hold 4096 bit key in ascii string

/*
 * Table of CRC-32's of all single-byte values (made by make_crc_table)
 */
static const unsigned long crc_table[256] = {
  0x00000000L, 0x77073096L, 0xee0e612cL, 0x990951baL, 0x076dc419L,
  0x706af48fL, 0xe963a535L, 0x9e6495a3L, 0x0edb8832L, 0x79dcb8a4L,
  0xe0d5e91eL, 0x97d2d988L, 0x09b64c2bL, 0x7eb17cbdL, 0xe7b82d07L,
  0x90bf1d91L, 0x1db71064L, 0x6ab020f2L, 0xf3b97148L, 0x84be41deL,
  0x1adad47dL, 0x6ddde4ebL, 0xf4d4b551L, 0x83d385c7L, 0x136c9856L,
  0x646ba8c0L, 0xfd62f97aL, 0x8a65c9ecL, 0x14015c4fL, 0x63066cd9L,
  0xfa0f3d63L, 0x8d080df5L, 0x3b6e20c8L, 0x4c69105eL, 0xd56041e4L,
  0xa2677172L, 0x3c03e4d1L, 0x4b04d447L, 0xd20d85fdL, 0xa50ab56bL,
  0x35b5a8faL, 0x42b2986cL, 0xdbbbc9d6L, 0xacbcf940L, 0x32d86ce3L,
  0x45df5c75L, 0xdcd60dcfL, 0xabd13d59L, 0x26d930acL, 0x51de003aL,
  0xc8d75180L, 0xbfd06116L, 0x21b4f4b5L, 0x56b3c423L, 0xcfba9599L,
  0xb8bda50fL, 0x2802b89eL, 0x5f058808L, 0xc60cd9b2L, 0xb10be924L,
  0x2f6f7c87L, 0x58684c11L, 0xc1611dabL, 0xb6662d3dL, 0x76dc4190L,
  0x01db7106L, 0x98d220bcL, 0xefd5102aL, 0x71b18589L, 0x06b6b51fL,
  0x9fbfe4a5L, 0xe8b8d433L, 0x7807c9a2L, 0x0f00f934L, 0x9609a88eL,
  0xe10e9818L, 0x7f6a0dbbL, 0x086d3d2dL, 0x91646c97L, 0xe6635c01L,
  0x6b6b51f4L, 0x1c6c6162L, 0x856530d8L, 0xf262004eL, 0x6c0695edL,
  0x1b01a57bL, 0x8208f4c1L, 0xf50fc457L, 0x65b0d9c6L, 0x12b7e950L,
  0x8bbeb8eaL, 0xfcb9887cL, 0x62dd1ddfL, 0x15da2d49L, 0x8cd37cf3L,
  0xfbd44c65L, 0x4db26158L, 0x3ab551ceL, 0xa3bc0074L, 0xd4bb30e2L,
  0x4adfa541L, 0x3dd895d7L, 0xa4d1c46dL, 0xd3d6f4fbL, 0x4369e96aL,
  0x346ed9fcL, 0xad678846L, 0xda60b8d0L, 0x44042d73L, 0x33031de5L,
  0xaa0a4c5fL, 0xdd0d7cc9L, 0x5005713cL, 0x270241aaL, 0xbe0b1010L,
  0xc90c2086L, 0x5768b525L, 0x206f85b3L, 0xb966d409L, 0xce61e49fL,
  0x5edef90eL, 0x29d9c998L, 0xb0d09822L, 0xc7d7a8b4L, 0x59b33d17L,
  0x2eb40d81L, 0xb7bd5c3bL, 0xc0ba6cadL, 0xedb88320L, 0x9abfb3b6L,
  0x03b6e20cL, 0x74b1d29aL, 0xead54739L, 0x9dd277afL, 0x04db2615L,
  0x73dc1683L, 0xe3630b12L, 0x94643b84L, 0x0d6d6a3eL, 0x7a6a5aa8L,
  0xe40ecf0bL, 0x9309ff9dL, 0x0a00ae27L, 0x7d079eb1L, 0xf00f9344L,
  0x8708a3d2L, 0x1e01f268L, 0x6906c2feL, 0xf762575dL, 0x806567cbL,
  0x196c3671L, 0x6e6b06e7L, 0xfed41b76L, 0x89d32be0L, 0x10da7a5aL,
  0x67dd4accL, 0xf9b9df6fL, 0x8ebeeff9L, 0x17b7be43L, 0x60b08ed5L,
  0xd6d6a3e8L, 0xa1d1937eL, 0x38d8c2c4L, 0x4fdff252L, 0xd1bb67f1L,
  0xa6bc5767L, 0x3fb506ddL, 0x48b2364bL, 0xd80d2bdaL, 0xaf0a1b4cL,
  0x36034af6L, 0x41047a60L, 0xdf60efc3L, 0xa867df55L, 0x316e8eefL,
  0x4669be79L, 0xcb61b38cL, 0xbc66831aL, 0x256fd2a0L, 0x5268e236L,
  0xcc0c7795L, 0xbb0b4703L, 0x220216b9L, 0x5505262fL, 0xc5ba3bbeL,
  0xb2bd0b28L, 0x2bb45a92L, 0x5cb36a04L, 0xc2d7ffa7L, 0xb5d0cf31L,
  0x2cd99e8bL, 0x5bdeae1dL, 0x9b64c2b0L, 0xec63f226L, 0x756aa39cL,
  0x026d930aL, 0x9c0906a9L, 0xeb0e363fL, 0x72076785L, 0x05005713L,
  0x95bf4a82L, 0xe2b87a14L, 0x7bb12baeL, 0x0cb61b38L, 0x92d28e9bL,
  0xe5d5be0dL, 0x7cdcefb7L, 0x0bdbdf21L, 0x86d3d2d4L, 0xf1d4e242L,
  0x68ddb3f8L, 0x1fda836eL, 0x81be16cdL, 0xf6b9265bL, 0x6fb077e1L,
  0x18b74777L, 0x88085ae6L, 0xff0f6a70L, 0x66063bcaL, 0x11010b5cL,
  0x8f659effL, 0xf862ae69L, 0x616bffd3L, 0x166ccf45L, 0xa00ae278L,
  0xd70dd2eeL, 0x4e048354L, 0x3903b3c2L, 0xa7672661L, 0xd06016f7L,
  0x4969474dL, 0x3e6e77dbL, 0xaed16a4aL, 0xd9d65adcL, 0x40df0b66L,
  0x37d83bf0L, 0xa9bcae53L, 0xdebb9ec5L, 0x47b2cf7fL, 0x30b5ffe9L,
  0xbdbdf21cL, 0xcabac28aL, 0x53b39330L, 0x24b4a3a6L, 0xbad03605L,
  0xcdd70693L, 0x54de5729L, 0x23d967bfL, 0xb3667a2eL, 0xc4614ab8L,
  0x5d681b02L, 0x2a6f2b94L, 0xb40bbe37L, 0xc30c8ea1L, 0x5a05df1bL,
  0x2d02ef8dL
};


/* CRC calculation related defines */
#define DO1(buf) crc = crc_table[((int)crc ^ (*buf++)) & 0xff] ^ (crc >> 8);
#define DO2(buf)  DO1(buf); DO1(buf);
#define DO4(buf)  DO2(buf); DO2(buf);
#define DO8(buf)  DO4(buf); DO4(buf);

/*
 *****************************************
 *   calculate_crc_32 ()
 *
 *   Calculate 32 bit CRC
 *****************************************
 */
unsigned long calculate_crc_32(unsigned long crc, const unsigned char *buf, unsigned int len)
{
    crc = crc ^ 0xffffffffL;
    while (len >= 8)
    {
      DO8(buf);
      len -= 8;
    }
    if (len) do {
      DO1(buf);
    } while (--len);
    return crc ^ 0xffffffffL;
}

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
	int fdo, fdi, fd1, fd2, timestamp, keylen = 0, keypkg = 0 , aes_iv_len = 0;
	unsigned int crc = CRC_INIT, hdr_len, hashtype, bytes, hash_len;
	unsigned char hdr_buf[MAX_HEADER_LENGTH];
	ssboot_img_hdr *h1 = (ssboot_img_hdr *)hdr_buf;
	unsigned char pub_key_buf[C2K_KEY_LENGTH_4K];
	unsigned char aes_iv_buf[C2K_AES_IV_LENGTH];
	unsigned char *hash_val_buf = (unsigned char *)(h1 + 1), *img_buf;
	struct stat st;
	char *timestmp, *image, *hash, *signature, *pblcky, *keymode, *aes_iv=NULL;
	int ii;

	if ( argc < 4 )
	{
		printf( "Usage: %s", argv[0] );
		goto out;
	}
	else
	{
		hdr_len = SSBOOT_HEADER_LEN;

		timestmp = argv[1];
		image	= argv[2];
		hash	= argv[3];
		signature = argv[4];
		pblcky = argv[5];
		keymode = argv[6];

		timestamp = atoi(timestmp);
		printf("timestamp = %d\n", timestamp);

		stat(image, &st);
		printf("image length = %d\n", (int)st.st_size);

		if (strcmp(hash, "null") == 0)
			hashtype = 0;
		else if (strcmp(hash, "sha256") == 0)
			hashtype = 1;
		else if(strcmp(hash, "rsa") == 0)
		{
			if(argc < 6)
			{
				printf("Invalid number of arguments to %s\n", argv[0]);
				goto out;
			}
			else
			{
				if(pblcky != NULL)
				{
					keylen = bn_atoi(pblcky, &pub_key_buf[0], C2K_KEY_LENGTH_4K);
					if ((keylen * 8) != 1024 && (keylen * 8) != 2048)
					{
						printf("Key size %d bit not supported\n", keylen * 8);
						goto out;
					}
					printf("Copied Public key of length %d.\n", keylen);
				}

				if (strcmp(keymode, "insertkey") == 0)
					keypkg = 1;

				hashtype = 2;
			}
		}
		else if (strcmp(hash, "aes_rsa") == 0)
		{
			if(argc < 7)
			{
				printf("Invalid number of arguments to %s\n", argv[0]);
				goto out;
			}
			else
			{
				if(pblcky != NULL)
				{
					keylen = bn_atoi(pblcky, &pub_key_buf[0], C2K_KEY_LENGTH_4K);
					if ((keylen * 8) != 1024 && (keylen * 8) != 2048)
					{
						printf("Key size %d bit not supported\n", keylen * 8);
						goto out;
					}
					printf("Copied Public key of length %d.\n", keylen);
				}

				if (strcmp(keymode, "insertkey") == 0)
					keypkg = 1;

				hashtype = 3;
				aes_iv = argv[7];
				if(aes_iv != NULL)
				{
					aes_iv_len = bn_atoi(aes_iv, &aes_iv_buf[0], C2K_AES_IV_LENGTH);
					if (((aes_iv_len * 8) != 128) && ((aes_iv_len * 8) != 256))
					{
						printf("AES key IV size %d bit not supported\n", aes_iv_len * 8);
						goto out;
					}
					printf("Copied AES IV of length %d.\n", aes_iv_len);
				}
			}
		}

		h1->magic 		= C2K_MAGIC;
		h1->timestamp 		= timestamp;
		h1->ssboot_header_crc 	= 0x0;

		if(keypkg)
			h1->key_length	= keylen;
		else
			h1->key_length	= 0;

		h1->hash_type 		= hashtype;
		h1->image_len 		= (unsigned int)st.st_size;

                if ( ( h1->hash_type == 2) || ( h1->hash_type == 3) )
                        hash_len = keylen;
                else
                        hash_len = SSBOOT_HASH_LENGTH;


		/* Copy Hash Value If available */
		if ( h1->hash_type )
		{
			printf("Copying Hash Value...\n");
			if((fd2 = open(signature, O_RDONLY, S_IREAD)) == -1)
			{
				printf("ERROR: Cannot open the file %s\n", signature);
				goto out;
			}
			bytes = read(fd2, hash_val_buf, hash_len);
			if (bytes != hash_len)
				goto out;
		}
		else
		{
			printf("Copying null Hash...\n");
			memset(hash_val_buf, 0, hash_len);
		}
		hdr_len += hash_len;

		if((pblcky != NULL) && keypkg)
		{
			memcpy((unsigned char *)&hdr_buf[hdr_len],(unsigned char *)&pub_key_buf[0], keylen);
			hdr_len += keylen;
		}

		if ( aes_iv != NULL)
		{
			memcpy((unsigned char *)&hdr_buf[hdr_len],(unsigned char *)&aes_iv_buf[0], aes_iv_len);
			hdr_len += aes_iv_len;
		}

		crc = calculate_crc_32(crc, (unsigned char *)&hdr_buf[0], hdr_len);
		h1->ssboot_header_crc = crc;
	}

	/*printf("hdr_len = %d hash_len = %d keylen %d aes_iv_len %d \n",hdr_len,hash_len,keylen,aes_iv_len);

        for(ii=0; ii < hdr_len; ii++) {
                if (!(ii % 16))
                        printf("\n");
                printf(" 0x%02x", hdr_buf[ii]);
        }
        printf("\n");*/

	printf("Preparing the image with header...\n");
	if((fdi = open(image, O_RDONLY, S_IREAD)) == -1)
	{
		printf("ERROR: Cannot open the file %s\n", image);
		goto out;
	}
	if((fdo = open(strcat(image, ".c2kimg"), O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) == -1)
	{
		printf("ERROR: Cannot create a file %s\n", strcat(image, ".c2kimg"));
		goto out;
	}
	if(hdr_len != write(fdo, &hdr_buf[0], hdr_len))
	{
		printf("ERROR: Write to the file %s has failed\n", strcat(image, ".c2kimg"));
		goto out;
	}
	img_buf = malloc(st.st_size);
	if (img_buf == NULL)
	{
		printf("ERROR: Out of memory\n");
		goto out;
	}
	bytes = read(fdi, img_buf, st.st_size);
	if(bytes != write(fdo, img_buf, bytes))
	{
		printf("ERROR: Write to the file %s has failed\n", image);
		goto out;
	}
	free(img_buf);

out:
	if(fd1) close(fd1);
	if(fd2) close(fd2);
	if(fdi) close(fdi);
	if(fdo) close(fdo);
	return 0;
}

