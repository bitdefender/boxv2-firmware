#!/bin/sh

usage()
{
	echo "Usage..."
	echo "$0 <options>"
	echo " options -"
	echo " <gen_aes_key>"
	echo "              - Generate the AES 128 and 256 bit keys"
	echo " <gen_key> <private_key> <public_key>"
	echo "		    - Generate the public key and sha256 hash of this key"
	echo "              - Generate the public key with this name"
}

clean_exit()
{
	if [ -e "$public_modulus" ]
	then
		rm $public_modulus
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

case "$1" in

gen_aes_key*)
	echo "Generating AES 128 bit key"

	aes_key=`openssl rand -hex 16` || exit 1

	echo $aes_key > aes_128_plain.key

	export tmp_aes_key=$aes_key
	perl -e 'print pack "H*", $ENV{'tmp_aes_key'}' > aes_128_hex.key

	echo "Generating AES 256 bit key"

	aes_key=`openssl rand -hex 32` || exit 1

	echo $aes_key > aes_256_plain.key

	export tmp_aes_key=$aes_key
	perl -e 'print pack "H*", $ENV{'tmp_aes_key'}' > aes_256_hex.key
	;;

gen_key)
	echo "Generating public key"
	public_modulus=`mktemp` || clean_exit 1
	privatekey=$2
	publickey=$3
	hashfile="publichash"

	if [ ! -e $privatekey ]; then
		echo "Private key file not found '$privatekey'"
		clean_exit 1
	fi

	#extract the public modulus(N) from the private key.
	openssl rsa -in $privatekey -modulus | awk -F"=" '{if ($1 == "Modulus"){print $2}}' > $public_modulus

	#Call header generation utility
	./c2k_key_gen $publickey $public_modulus
	echo "c2k_key_gen $publickey $public_modulus"
	#Calculate SHA256 hash on public key file.
	openssl dgst -binary -sha256 < $publickey > $hashfile
	echo "Generated hash on public key"
	;;

*)
	usage
	exit 1
	;;

esac
clean_exit 0

