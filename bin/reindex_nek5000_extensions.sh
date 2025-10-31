# !/bin/bash

if [ $# -ne 2 ]; then
    echo "reindex_nek5000_extensions <path> <new offset>"
fi

cd $1 # go to the target directory

regex="^f0[0-9]+$" # search for a string with characters "f0nnnnn", where n is in [0-9]

offset=$2 # an integer to add to each file's extension

for i in $(ls -t); # for each file in a call to ls
do
    IFS="." read -ra string_array <<< "$i" # split the file on '.'

    if [[ ${string_array[1]} =~ $regex ]]; then # if the file's extension matches our target...

        # len should be the same for all files, so it would be better to do this check before this for loop
        len=$((${#string_array[1]} - 1)) # get the length of the extension from ls 

        printf_string="%0${len}d" # better up front with where len should be defined

        oldnum=${string_array[1]:1} # string the leading 'f' from the extension string
        oldnum=$((10#$oldnum)) # strip leading zeros so arithmetic avoids base 8 calculation

        newnum=$((oldnum + offset)) # perform addition

        printf -v newext $printf_string $newnum # cast it formatted string with leading zeros and new offset
        
        mv $i ${string_array[0]}'.f'$newext # rename the file
    fi
done

