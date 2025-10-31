# !/bin/bash

if [ $# -ne 2 ]; then
    echo "reindex_nek5000_extensions <path> <new offset>"
fi

cd $1

regex="^f0[0-9]+$"

offset=$2

for i in $(ls -t);
do
    IFS="." read -ra string_array <<< "$i"

    if [[ ${string_array[1]} =~ $regex ]]; then

        len=$((${#string_array[1]} - 1))
        printf_string="%0${len}d\n"

        oldnum=${string_array[1]:1}
        oldnum=$((10#$oldnum)) #strip leading zeros for arithmetic to avoid base 8 calculation

        newnum=$((oldnum + offset))

        printf -v newext $printf_string $newnum

        mv ${string_array[0]}.${string_array[1]} ${string_array[0]}'.f'$newext
    fi
done

