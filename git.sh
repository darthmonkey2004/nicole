#!/bin/bash

gitInit() {
	if [ -z "$user" ]; then
		read -p "Enter user name: " user
	fi
	git config --global user.name "$user"
	if [ -z "$email" ]; then
		read -p "Enter email address: " email
	fi
	git config --global user.email "$email"
	echo "Git initialization complete."
}
clone() {
	if [ -z "$url" ]; then
		read -p "Enter git repo url: " url
	fi
	if [ -z "$path" ]; then
		path="."
	fi
	git clone "$url" "$path"
	Echo "Finished!"
}
add() {
	if [ -z "$path" ]; then
		read -p "Enter file path: " path
	fi
	git add "$path"
	echo "Added!"
}
addAll() {
	git add .
	dir=$(pwd)
	echo "Added all items in $dir"
}
commit() {
	read -p "This will update the repo. Are you sure?" yesno
	if [ "$yesno" = "yes" ] || [ "$yesno" = "y" ]; then
		git add CHANGES IN RED
		if [ -z "$desc" ]; then
			read -p "Enter a description: " desc
		fi
		git commit -m "$description"
		git push
		echo "Updated!"
		echo "Cancelled."
	fi
}
update() {
	echo "updating..."
	git checkout master
	git pull
	echo "Done!"
}
newBranch() {
	if [ -z "$branch" ]; then
		read -p "Enter branch name: " branch
	fi
	git checkout -b "$branch"
	echo "Created!"
}
viewChanges() {
	git status
}

if [ -n "$1" ]; then
	com="$1"
else
	read -p "Enter a command: " com
fi
if [ -n "$2" ]; then
	arg1="$2"
else
	read -p "Argument 1: (blank for none)" arg1
fi
if [ -n "$3" ]; then
	arg1="$3"
else
	read -p "Argument 2: (blank for none)" arg2
fi
$com
