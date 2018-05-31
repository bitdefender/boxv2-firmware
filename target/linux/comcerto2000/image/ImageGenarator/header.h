
typedef struct _ssboot_img_hdr
{
	unsigned int magic;		/* Magic No to identify Header == 0x4D535044 */
	unsigned int timestamp;		/* image creation timestamp in second starting from 01/01/76 */
	unsigned int ssboot_header_crc;	/* 32 bit CRC of header */
	unsigned int key_length;	/* Length of Public Key 0/1K,2K/4K. */
	unsigned int hash_type;		/* Hash Type 0/Sha-256/Rsa-Sha-256/AES/Aes-sha-256/Aes-Rsa-sha-256.
					   Zero - Initialized with all zero [size 32 bytes],
					   SHA-256 - SHA-256 hash on the image [size 32 bytes], 
					   RSA-SHA-256 - RSA encrypted sha-256 hash on the
					   image [size key size].
					   AES-RSA-SHA-256 - AES Decryption and RSA encrypted sha-256 hash on the Image */
	unsigned int image_len;		/* Length of Current Image (excluding header). */
} ssboot_img_hdr;

#define SSBOOT_HEADER_LEN       sizeof(ssboot_img_hdr)

#define CRC_INIT		0x0
#define SSBOOT_HASH_LENGTH	32
#define C2K_KEY_LENGTH_4K	512
#define C2K_AES_128_KEY_LENGTH	16
#define C2K_AES_256_KEY_LENGTH	32
#define C2K_AES_IV_LENGTH	16
#define MAX_HEADER_LENGTH	(SSBOOT_HEADER_LEN + 2 * C2K_KEY_LENGTH_4K + C2K_AES_IV_LENGTH)

#define	C2K_MAGIC		0x4D535044

