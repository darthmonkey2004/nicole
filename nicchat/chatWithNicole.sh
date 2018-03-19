#!/bin/bash
string="$QUERY_STRING"
urldecode() {
    # urldecode <string>

    local url_encoded="${string//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
    printf $'\n'
}
echo "Content-Type: text/html"
echo ''
query="$QUERY_STRING"
user=$(echo "$query" | cut -d '=' -f 2 | cut -d '&' -f 1)
usersay=$(echo "$query" | cut -d '=' -f 3)
string="$usersay"
export USERSAY=$(urldecode;)
echo "$user says: $USERSAY"
echo ''
echo '<br>'
echo '' > "/usr/lib/cgi-bin/nicchat/chat2.log"
echo "$user&$USERSAY" > "/usr/lib/cgi-bin/nicchat/inputfile.in"
waiting=1
while [ "$waiting" = "1" ]; do
	data=$(cat '/usr/lib/cgi-bin/nicchat/chat2.log')
	if [ -n "$data" ]; then
		data=$(echo "$data" | cut -d ':' -f 4)
		data=${data:1}
		echo "Nicole says:$data"
		echo ''
		echo '<br>'
		echo '<br>'
		waiting=0
		echo '' > "/usr/lib/cgi-bin/nicchat/inputfile.in"
	fi
done
echo '' > '/usr/lib/cgi-bin/nicchat/chat2.log'
exit 0
