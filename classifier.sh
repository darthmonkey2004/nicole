nv_setup() {
	echo "Checking for git..."
	if ! which git; then
		echo "Installing git.."
		sudo apt-get install -y git
	fi
	cd ~/
	if [ ! -d nicole ]; then
		echo "Cloning 'nicole' repostiroy..."
		git clone https://github.com/darthmonkey2004/nicole.git
	fi
	cd nicole
	if [ ! -d classifier ]; then
		echo "Cloning classifier from github..."
		git clone https://github.com/darthmonkey2004/SnackClassifier.git
		echo "Done."
	fi
	mv SnackClassifier classifier
	cd classifier
	echo "Checking for pip.."
	if ! which pip; then
		echo "Installing pip..."
		sudo apt-get install -y pip
	fi
	if ! which http; then
		sudo apt-get install -y httpie
	fi
	echo "Installing requirements..."
	pip install -r requirements.txt
	cd configuration
	mv environment.ini environment.bak.ini
	echo "[system]" > environment.ini
	read -p "Enter port to use for web api: (leave blank for default of 4444)" port
	if [ -z "$port" ]; then
		port=4444
	fi
	echo "PORT = $port" >> environment.ini
	echo "" >> environment.ini
	echo "[classifier]" >> environment.ini
	echo "IMAGE_FOLDER_PATH = '$HOME/nicole/classifier/static/images'" >> environment.ini
	echo "CLASSIFIER_TYPE = bayes" >> environment.ini
	echo "CLASSIFIER_TRAIN_PATH = '$HOME/nicole/classifier/static/images/toTrain'" >> environment.ini
	echo "Finished!"
}
nv_start() {
	cd "$HOME/nicole/classifier"
	python manage.py runserver
}
nv_listClassifiers() {
	url="http://$localip:$port/classify/names"
	curl "$url"
}
nv_trainImg() {
	"http POST \"http://$host:$port/api/train\" \
	  images:='[{\"class\": \"test\", \"image\": \"$img_url\"}]'"
}
nv_trainList() {
	if [ -z "$imglist" ]; then
		read -p "Enter path to image list: " imglist
	fi
	if [ ! -f "$imglist" ]; then
		echo "List not found! Exiting.."
		exit 1
	else
		echo "List found. Importing..."
	fi
	echo "{" > temp
	echo '	"images": [' >> temp
	echo "		{" >> temp
	readarray ary < "$imglist"
	count="${#ary[@]}"
	for i in "${ary[@]}"; do
		pos=$(( pos + 1 ))
		i=$(echo "$i" | cut -d $'\n' -f 1)
		class=$(echo "$i" | cut -d ',' -f 1)
		url=$(echo "$i" | cut -d ',' -f 2)
		echo "			\"class\": \"$class\"," >> temp
		echo "			\"image\": \"$url\""
		if [ "$pos" -lt "$count" ]; then
			echo "		}," >> temp
		else
			echo "		}" >> temp
		fi
	done
	echo "	]" >> temp
	echo "}" >> temp
	http POST http://$host:$port/api/train < temp
	rm temp
}
nv_retrain() {
	http GET http://$host:$port/api/retrain
}
nv_classifyImg() {
	http GET "http://$host:$port/api/classify?image=$imgurl"
}
