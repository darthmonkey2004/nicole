#!/bin/bash




shelveBackup() {
	if [ -f db.shelve ]; then
		echo "$(ls db.shelve)" > temp
		readarray temp < temp
		count="${#temp[@]}"
		count=$(( count + 1 ))
		mv db.shelve db.$count.shelve
		rm temp
	fi
}
index() {
	shelveBackup;
	cd "$HOME/nicole"
	echo "Indexing images directory..."
	python index.py --dataset images --shelve db.shelve 2>/dev/null
	if [ -f db.shelve ]; then
		echo "Index complete. Matching active."
	else
		echo "Index failed. Exiting..."
		exit 1
	fi
}
echo "1: $1, 2: $2"
if [ ! -d "$HOME/nicole/images" ]; then
	mkdir "$HOME/nicole/images"
fi
if [ -n "$1" ]; then
	path="$1"
	echo "Path: $path"
else
	echo "Path not provided.. using current working directory."
	path=$(pwd)
fi
find "$path" -name "*.jpg" > temp
find "$path" -name "*.jpeg" >> temp
readarray ary < temp
count="${#ary[@]}"
rm temp
for i in "${ary[@]}"; do
	pos=(( $pos + 1 ))
	name=$(basename "$i")
	i=$(echo "$i" | cut -d $'\n' -f 1)
	echo "Migrating '$i' ($pos/$count)..."
	mv "$i" "$HOME/nicole/images/$name"
	if [ -f "$HOME/nicole/images/$name" ]; then
		echo "Moved."
	else
		echo "Migrate error: Cancelling..."
		exit 1
	fi
done
index;
if [ ! -d "$path/duplicates" ]; then
	mkdir "$path/duplicates"
fi
ls "$HOME/nicole/images" > temp
sorted=$(sort -V -f temp)
echo "$sorted" > temp
readarray ary < temp
count="${#ary[@]}"
for i in ${ary[@]}; do
		pos=(( $pos + 1 ))
		i=$(echo "$i" | cut -d $'\n' -f 1)
		echo "Testing '$i'... ($pos/$count)"
		dupes=$(python search.py --dataset images --shelve db.shelve --query "$HOME/nicole/images/$i" 2>/dev/null)
		mv "$HOME/nicole/images/$i" "$path/$i" 2>/dev/null
		if [ -n "$dupes" ]; then
			echo "Duplicate found: Original='$i', Duplicates:'$dupes'"
			echo "$dupes" > dupes.txt
			readarray list < dupes.txt
			rm dupes.txt
			for d in "${list[@]}"; do
				d=$(echo "$d" | cut -d $'\n' -f 1)
				name=$(basename "$d")
				echo "Moving '$d' to '$path/duplicates/$name'"
				mv "$d" "$path/duplicates/$name" 2>/dev/null
			done
		fi
done

