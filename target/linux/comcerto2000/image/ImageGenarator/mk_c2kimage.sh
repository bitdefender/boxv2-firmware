#!/bin/sh
################################################################################
# This script generates c2k images(that includes image header) from the standard
# binary file. It can generates header with NULL, SHA256, RSA signatures, and
# key inbuilt to the header. This script internally invoke header generation
# application with corresponding parameters.
#
# Example Usage:
# To generate firmware image with NULL hash
# 	mk_c2kimage.sh null firmware.bin
#
# To generate firmware image with SHA256
#	mk_c2kimage.sh sha256 firmware.bin
#
# To generate firmware image with RSA signature and key inbuilt to the header
#	mk_c2kimage.sh rsa private.pem insertkey firmware.bin
#
# To generate firmware image with RSA signature and no key inserted in the header
#	mk_c2kimage.sh rsa private.pem nokey firmware.bin
#
# To generate firmware image with RSA signature and key inbuilt to the header and encrypt the image
#	mk_c2kimage.sh aes_rsa private.pem insertkey firmware.bin
#
# To generate firmware image with RSA signature and no key inserted in the header and encrypt the image
#	mk_c2kimage.sh aes_rsa private.pem nokey firmware.bin
#
# OpenSSL command to generate new private key
#	openssl genrsa -out private.pem 2048
#
# Note: RSA key size is determined from the given private key.
################################################################################

usage()
{
	echo "Usage..."
	echo "$0 <options> <fw_file>"
	echo " <fw_file>    - Firmware image"
	echo " options -"
	echo " <null>       - Place NULL hash in the header"
	echo " <sha256>     - Place SHA256 hash in the header"
	echo " <rsa> <private_key> <insertkey|nokey>"
	echo "              - Place RSA signature in the header using private_key"
	echo "                insertkey|nokey to inbuilt or exclude the key from header"
	echo " <aes_rsa> <private_key> <insertkey|nokey>"
	echo "              - Encrypt the image and place RSA signature in the header using private_key"
	echo "                insertkey|nokey to inbuilt or exclude the key from header"
}

clean_exit()
{
	if [ -e "$public_modulus" ]
	then
		rm $public_modulus
	fi
	if [ -e "$sig_file" ]
	then
		rm $sig_file
	fi
	if [ -e "$hash_file" ]
	then
		rm $hash_file
	fi
	exit $1
}

check_image()
{
	if [ "$1" = "" ]; then
		usage
		clean_exit 1
	fi

	if [ ! -e $1 ]; then
		echo "Firmware file not found "$1
		clean_exit 1
	fi
}


#This function calculates C2K custom hash on given input file
# $1 input file name
# $2 file name to store hash
calculate_c2k_hash()
{
	img_size=$(stat -c%s $1)
	part_size=$(((252*1024)))
	tmp_hash_file=`mktemp` || exit 1

	#create  one temp filename to use as prefix
	prefix=`mktemp` && rm $prefix

	echo "Calculating custom SHA256 hash on $1 size $img_size"
	split -b $part_size $1 $prefix

	for part_file in `ls $prefix*`
	do
		echo "$(stat -c%s $part_file)"
		openssl dgst -binary -sha256 < $part_file >> $tmp_hash_file
		rm $part_file
	done

	if [ $img_size -gt $part_size ]; then
		openssl dgst -binary -sha256 < $tmp_hash_file > $2
	else
		cat $tmp_hash_file > $2
	fi
	rm $tmp_hash_file
}

case "$1" in
null)
	echo "Generating C2K image with NULL hash"
	timestamp=`date +%s` || exit 1
	image=$2

	check_image $image

	#Call header generation utility
	./c2k_image_gen $timestamp $image $1
	echo "c2k_image_gen $timestamp $image $1"
	;;

sha256)
	echo "Generating C2K image with SHA256.."
	hash_file=`mktemp` || exit 1
	timestamp=`date +%s` || exit 1
	image=$2

	check_image $image

	#Calculate SHA256 hash on fw file.
	calculate_c2k_hash $image $hash_file
	if [ $? != 0 ]; then
		echo "Error while calculating hash on $image"
		clean_exit 1
	fi

	#Call header generation utility
	./c2k_image_gen $timestamp $image $1 $hash_file
	echo "c2k_image_gen $timestamp $image $1 $hash_file"
	;;

rsa*)
	echo "Generating C2K image with RSA signature .."
	public_modulus=`mktemp` || clean_exit 1
	sig_file=`mktemp` || clean_exit 1
	hash_file=`mktemp` || clean_exit 1
	private_key=$2
	keymode=$3
	timestamp=`date +%s` || exit 1
	image=$4

	check_image $image

	if [ ! -e $private_key ]; then
		echo "Private key file not found '$private_key'"
		clean_exit 1
	fi

	#Calculate SHA256 hash on fw file.
	calculate_c2k_hash $image $hash_file
	#RSA Sign the hash using private key
	openssl rsautl -sign -inkey $private_key -keyform PEM -pkcs -in $hash_file -out $sig_file

	#extract the public modulus(N) from the private key.
	openssl rsa -in $private_key -modulus | awk -F"=" '{if ($1 == "Modulus"){print $2}}' > $public_modulus

	./c2k_image_gen $timestamp $image $1 $sig_file $public_modulus $keymode
	echo "c2k_image_gen $timestamp $image $1 $sig_file $public_modulus $keymode"
	;;

aes_rsa*)
	echo "Generating C2K image with RSA signature and encrypted with AES"
	public_modulus=`mktemp` || clean_exit 1
	sig_file=`mktemp` || clean_exit 1
	hash_file=`mktemp` || clean_exit 1
	aes_iv_file=`mktemp` || clean_exit 1
	private_key=$2
	keymode=$3
	timestamp=`date +%s` || exit 1
	image=$4
	aes_key_size=$5
	enc_image=$image.enc

	check_image $image

	if [ $aes_key_size = 128 ]; then
		aes_key=`cat aes_128_plain.key` || exit 1
		aes_iv=`openssl rand -hex 16` || exit 1
		openssl enc -aes-128-cbc -p -nosalt -K $aes_key -iv $aes_iv -in $image -out $enc_image
	fi
	if [ $aes_key_size = 256 ]; then
		aes_key=`cat aes_256_plain.key` || exit 1
		aes_iv=`openssl rand -hex 16` || exit 1
		openssl enc -aes-256-cbc -p -nosalt -K $aes_key -iv $aes_iv -in $image -out $enc_image
	fi

	echo $aes_iv > $aes_iv_file

	echo "************VERY IMPORTANT*************"
	echo "Program this AES key $aes_key into OTP area stored in aes.key file"

	#Calculate SHA256 hash on fw file.
	if [ ! -e $private_key ]; then
		echo "Private key file not found '$private_key'"
		clean_exit 1
	fi

	#Calculate SHA256 hash on fw file.
	calculate_c2k_hash $enc_image $hash_file

	#RSA Sign the hash using private key
	openssl rsautl -sign -inkey $private_key -keyform PEM -pkcs -in $hash_file -out $sig_file

	#extract the public modulus(N) from the private key.
	openssl rsa -in $private_key -modulus | awk -F"=" '{if ($1 == "Modulus"){print $2}}' > $public_modulus

	./c2k_image_gen $timestamp $enc_image $1 $sig_file $public_modulus $keymode $aes_iv_file
	echo "c2k_image_gen $timestamp $enc_image $1 $sig_file $public_modulus $keymode $aes_iv_file"
	;;

*)
	usage
	exit 1
	;;

esac
clean_exit 0

