#!/bin/bash
# For whatever reason, I needed to do this at some point. A similar problem exists for pngs.
if [ $# -ne 2 ]; then
    echo "reindex_nek5000_extensions <path> <new offset>"
fi

cd $1 # go to the target directory

# use the maximum extension length matching nekRS file extension convention (.f0nnnn)
len=$(ls -t *.f0* | awk -F. '{print $NF}' | awk '{print length}' | sort -nr | head -n 1)
len=$((len - 1)) # remove leading character 'f'
printf_string="%0${len}d" # create a printf formatted string with matching length of leading zeros for later use
offset=$2 # an integer to add to each file's extension

for i in $(ls -t *.f0*); # for each file in a call to ls
do
    IFS="." read -ra string_array <<< "$i" # split the file's name on '.'
    ext=${string_array[1]} # file extension
    oldnum=${ext:1} # strip the leading 'f' from the extension string
    oldnum=$((10#$oldnum)) # strip leading zeros so arithmetic avoids base 8 calculation
    newnum=$((oldnum + offset)) # perform addition
    printf -v newext $printf_string $newnum # cast a formatted string with leading zeros and new offset    
    mv $i ${string_array[0]}'.f'$newext # rename the file
done

