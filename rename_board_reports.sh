#!/bin/bash
# set -x

####################################
# List of files I need to download
# - account transactions
# - aged receivables
# - balance sheet
# - p&l

# Note: $1 should look like "2021-01"
if [[ ! $1 =~ 202[0-4]-[0-1][0-9] ]]; then
  echo "Error: You didn't pass a valid date as \$1"
  exit 64
fi

# CREATE new dir for copied files
new_dir="$HOME/Desktop/$1_-_Monthly_Financial_Board_Reports"
mkdir -p $(echo $new_dir)
rm -f $(echo $new_dir)/*

echo 'new_dir'
echo $new_dir
echo

# NAME change/replacement
start=Wellington_Touch_Association_Incorporated_
rplc="$1_WTA_Board_Meeting_"
echo 'rplc'
echo $rplc
echo

# WHERE to find the files we want to rename/copy
base_dir="$HOME/Downloads"
echo 'base_dir'
echo $base_dir
echo

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

	# PUT in the new folder
	new_location=$(echo "$next" | sed "s~$base_dir~$new_dir~g")
	echo
	echo '$new_location'
	echo $new_location

  cp "$i" "$new_location"
	# exit 0
done
