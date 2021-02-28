#!/bin/bash

#set -x

# data_source="/Users/$USER/Desktop/testdata/"
# echo $data_source

# prefix='Wellington_Touch_Association_Incorporated_-_'
# echo $prefix

# rm -rfv "/Users/$USER/Desktop/testdataoutput/" && mkdir -p "/Users/$USER/Desktop/testdataoutput/"

# find "/Users/$USER/Desktop/testdata" -name "*$prefix*" -print0 |
 

# find ../../Downloads -name "*$PREFIX*" -exec sh -c 'x="{}"; cp "$x" "${x}_digs"' \;

# set -x

base_dir=/Users/scully/Desktop/testdata
# echo 'base_dir'
# echo $base_dir
# echo

# Note: $1 should look like "2021-01"
new_dir="/Users/scully/Desktop/$1_-_Monthly_Financial_Board_Reports"
mkdir -p $(echo $new_dir)
rm -f $(echo $new_dir)/*

echo 'new_dir'
echo $new_dir
echo

start=Wellington_Touch_Association_Incorporated_
rplc="$1_WTA_Board_Meeting_"
echo 'rplc'
echo $rplc
echo

for i in $(find $base_dir -name "$start*"); do
	# echo
	# echo '$i'
  # echo $i;
  first=${i/$start/$rplc}
	# echo
	# echo '$first'
  # echo $first
  next=$(echo "$first" | sed "s/__WTA[0-9]*_//g")
	echo
	echo '$next1'
	echo $next

	# line=$(echo "$next" | sed "s/_WTA[0-9]*_//g")
	# echo
	# echo '$line'
	# echo $line
	# next1=${next/WTA[0-9]*/.pdf}
	# next2=${next1/ .pdf/.pdf}
	# echo '$next2'
  # echo $next2
  # cp "$i" "$more"
	# exit 0
done
