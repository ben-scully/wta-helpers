#!/bin/bash
# set -x

# Note: $1 should look like "2021-01"

# CREATE new dir for copied files
new_dir="/Users/scully/Desktop/$1_-_Monthly_Financial_Board_Reports"
mkdir -p $(echo $new_dir)
rm -f $(echo $new_dir)/*

# echo 'new_dir'
# echo $new_dir
# echo

# NAME change/replacement
start=Wellington_Touch_Association_Incorporated_
rplc="$1_WTA_Board_Meeting_"
# echo 'rplc'
# echo $rplc
# echo

# WHERE to find the files we want to rename/copy
base_dir=/Users/scully/Downloads
# echo 'base_dir'
# echo $base_dir
# echo

for i in $(find $base_dir -name "$start*"); do
	# echo
	# echo '$i'
  # echo $i;

	# TITLE change the title of the file
  first=${i/$start/$rplc}
	
	# echo
	# echo '$first'
  # echo $first

	# STRIP nonsense off the end
  next=$(echo "$first" | sed "s/__WTA[0-9]*_//g")
	
	echo
	echo '$next'
	echo $next

	# PUT in a new folder
	new_location=$(echo "$next" | sed "s~$base_dir~$new_dir~g")
	echo
	echo '$new_location'
	echo $new_location

  cp "$i" "$new_location"
	# exit 0
done
