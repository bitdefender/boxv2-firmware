#find ./ -name '*.gz' -maxdepth 1 | xargs -i  cat {}  > /dev/se_data

for file in $(find ./  -type f -maxdepth 1  -name "*.gz") ; do
    echo ${file}
    #${datfile}=${file}".dat"
    #echo ${datfile}
    (echo -n  "${file}.dat" ; cat "${file}.dat") > /dev/se_data
    cat ${file} > /dev/se_data
done

