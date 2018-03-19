#!/bin/bash
getDevice() {
        usb=$(ls /dev/ttyUSB*)
        acm=$(ls /dev/ttyACM*)
        if [ -n "$usb" ]; then
                dev="$usb"
        fi
        if [ -n "$acm" ]; then
                dev="$acm"
        fi
        echo "Device chosen: '$dev'"
}
stop() {
	echo "/5/1/0/0/" > "$dev"
        echo "Stopped"
}
drive() {
	if [ -n "$eng_l" ] && [ -n "$eng_r" ]; then
		echo "/5/1/$eng_l/$eng_r" > "$dev"
	        echo "Drive: Forward (Engine1: $eng_l, Engine2: $eng_r)"
	else
		echo "/5/1/255/255/" > "$dev"
	        echo "Drive: Forward (Engine1: MAX, Engine2: MAX)"
	fi
}
reverse() {
	if [ -n "$eng_l" ] && [ -n "$eng_r" ]; then
		echo "/5/2/$eng_l/$eng_r" > "$dev"
	        echo "Drive: Reverse (Engine1: $eng_l, Engine2: $eng_r)"
	else
		echo "/5/2/255/255/" > "$dev"
	        echo "Drive: Reverse (Engine1: MAX, Engine2: MAX)"
	fi
}
left() {
        if [ -n "$eng_l" ] && [ -n "$eng_r" ]; then
                eng_l=$(( eng_l / 2 ))
                echo "/5/1/$eng_l/$eng_r" > "$dev"
	        echo "Drive: Forward, Turn left (Engine1: $eng_l, Engine2: $eng_r)"
        else
                echo "/5/1/127/255/" > "$dev"
	        echo "Drive: Forward, Turn left (Engine1: HALF, Engine2: MAX)"
        fi
}
right() {
        if [ -n "$eng_l" ] && [ -n "$eng_r" ]; then
                eng_r=$(( eng_r / 2 ))
                echo "/5/1/$eng_l/$eng_r" > "$dev"
	        echo "Drive: Forward, Turn right (Engine1: $eng_l, Engine2: $eng_r)"
        else
                echo "/5/1/255/127/" > "$dev"
		echo "Drive: Forward, Turn right (Engine1: MAX, Engine2: HALF)"
        fi
}
var="$@"
if [ -n "$var" ]; then
	ary=($var) 
	for i in "${ary[@]}"; do
		pos=$(( pos + 1 ))
		if [ "$i" = -d ]; then
			dev="${ary[$pos]}"
		elif [ "$i" = -b ]; then
			baud="${ary[$pos]}"
		elif [ "$i" = -f ]; then
			function="${ary[$pos]}"
			pos=$(( pos + 1 ))
			arg1="${ary[$pos]}"
			pos=$(( pos + 1 ))
			arg2="${ary[$pos]}"
		fi
	done
fi
if [ -z "$function" ]; then
	read -p "Enter command: " function
fi
if [ -n "$arg2" ] && [ -n "$arg1" ]; then
	com="$function $arg1 $arg2"
elif [ -z "$arg2" ] && [ -n "$arg1" ]; then
	com="$function $arg1"
elif [ -z "$arg2" ] && [ -z "$arg1" ]; then
	com="$function"
else
	echo "failed to run function '$function'"
	exit 1
fi
$com;

