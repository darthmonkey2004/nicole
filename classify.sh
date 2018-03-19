#!/bin/bash


if [ -n "$1" ]; then
	class="$1"
else
	read -p "Enter class name: " class
fi
if [ -n "$2" ]; then
	url="$2"
else
	read -p "Enter image url: " url
fi
class="sign_stop"
url="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/STOP_sign.jpg/220px-STOP_sign.jpg"
http POST http://192.168.2.4:4444/api/train images:='[{"class": "$class", "image": "$url"}]'
http GET http://192.168.2.4:4444/api/retrain
http GET "http://192.168.2.4:4444/api/classify?image=$url"
