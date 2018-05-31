#!/bin/sh

while IFS=: read f1 f2 f3 f4 f5
do
field1=$f1
field2=$f2
field3=$f3
field4=$f4
field5=$f5
done < hdr_gen_cfg

make clean;make header

echo "Generating kernel Image"
sh mk_c2kimage.sh $field1 $field2 $field3 $field4 $field5
if [ "$field1" = "aes_rsa" ]; then
  mv -v $field4.enc.c2kimg uImage1
else
  mv -v $field4.c2kimg uImage1
fi
echo "Done.\n\n"

echo "Removing original kernel Image"
if [ "$field1" = "aes_rsa" ]; then
rm uImage uImage.enc *.key *.rawkey *.pem publickeyhash-*
else
rm uImage *.key *.rawkey *.pem publickeyhash-*
fi
echo "Done.\n\n"
