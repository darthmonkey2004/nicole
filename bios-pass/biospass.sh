#!/bin/bash

files=$(ls "$HOME/nicole/bios-pass/" | grep ".py")
echo "$files" > temp
readarray ary < temp
rm temp
for i in "${ary[@]}"; do
:man=$(echo "$i" | cut -d '-' -f 1 | cut -d '.' -f 1)
:type=$(echo "$i" | cut -d '-' -f 2 | cut -d '.' -f 1)
:echo "$type:"

asus="Asus:Machine Date:01-01-2011:asus.py"
compaq="Compaq:5 decimal digits:12345:5dec.py"
fujitsu1="Fujitsu-Siemens:5 decimal digits:12345:5dec.py"
fujitsu2="Fujitsu-Siemens:8 hexadecimal digits:DEADBEEF:fsi-hex.py"
fujitsu3="Fujitsu-Siemens:5x4 hexadecimal digits:AAAA-BBBB-CCCC-DEAD-BEEF:fsi-hex.py"
fujitsu4="Fujitsu-Siemens:5x4 decimal digits:1234-4321-1234-4321-1234:fsi-5x4dec.py"
fujitsu5="Fujitsu-Siemens:6x4 decimal digits:8F16-1234-4321-1234-4321-1234:fsi-6x4dec.py"
hp5dec="Hewlett-Packard:5 decimal digits:12345:5dec.py"
hpCompaq="Hewlett-Packard/Compaq Netbooks:10 characters:CNU1234ABC:hpmini.py"
insyde="Insyde H20 (generic):8 decimal digits:03133610:insyde.py"
phoenixGeneric="Phoenix (generic):5 decimal digits:12345:phoenixGeneric-5dec.py"
sony4="Sony:4x4 hexadecimal digits:1234-1234-1234-1234:sony-4x4.py"
sony7="Sony:7 digit serial number:1234567:sony-serial.py"
samsung="Samsung:12 hexadecimal digits:07088120410C0000:samsung.py"
