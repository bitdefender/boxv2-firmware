#!/bin/sh

if [ ! -f ../../bin/comcerto2000-glibc/keys/privatekey-2k.pem -o ! -f ../../bin/comcerto2000-glibc/keys/publickey-2k.rawkey ]; then
    LIBC=$(grep 'CONFIG_LIBC=' ../../.config | cut -d= -f2 | sed -e 's/^"//' -e 's/"$//')
    if [ "$LIBC" = "uClibc" ]; then
        DDIR="comcerto2000"
    else
        DDIR="comcerto2000-glibc"
    fi

    make clean
    make keys

    #generate private key, public key and hash on public key
    echo "Generating private key with size 1K..."
    openssl genrsa -out privatekey-1k.pem 1024
    echo "Done.\n\n"

    echo "Generating private key with size 2K..."
    openssl genrsa -out privatekey-2k.pem 2048
    echo "Done.\n\n"

    echo "Generating public key with size 1K and hash on public key..."
    sh mk_c2k_keys.sh gen_key privatekey-1k.pem publickey-1k.rawkey
    mv publichash publickeyhash-1k
    echo "Done.\n\n"

    echo "Generating public key with size 2K and hash on public key..."
    sh mk_c2k_keys.sh gen_key privatekey-2k.pem publickey-2k.rawkey
    mv publichash publickeyhash-2k
    echo "Done.\n\n"

    echo "Generating AES keys with size 128 and 256"
    sh mk_c2k_keys.sh gen_aes_key
    echo "Done.\n\n"

    mkdir -p ../../bin/$DDIR/keys
    mv *.key *.pem *.rawkey publickeyhash-* ../../bin/$DDIR/keys/
fi
