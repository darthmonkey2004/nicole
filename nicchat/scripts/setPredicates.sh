#!/bin/bash


cd "$HOME/nicole/nicchat"
mkdir "$HOME/nicchat_temp"
files=$(find . -name "*.aiml")
echo "$files" > "$HOME/nicchat_temp/filelist.txt"
readarray ary < "$HOME/nicchat_temp/filelist.txt"
rm "$HOME/nicchat_temp/filelist.txt"
for i in "${ary[@]}"; do
	file=$(basename "$i")
	file="$HOME/nicole/nicchat/$file"
	echo "$file"
	data=$(cat "$file" | grep "<set name=")
	echo "$data" >> "$HOME/nicchat_temp/predicates.txt"
done

