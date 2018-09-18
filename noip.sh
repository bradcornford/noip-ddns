#!/bin/bash

# No-IP uses emails as usernames, so make sure that you encode the @ as %40
USERNAME=$1
PASSWORD=$2
HOST=$3
STOREDIPFILE="/tmp/current_ip_noip-$HOST"

if [ ! -e $STOREDIPFILE ]; then
	touch $STOREDIPFILE
fi

NEWIP=$(curl -kLs http://api.ipify.org)
STOREDIP=$(cat $STOREDIPFILE)

if [ "$NEWIP" != "$STOREDIP" ]; then
	RESULT=$(curl -kLs "https://$(echo -ne $USERNAME | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g'):$(echo -ne $PASSWORD | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g')@dynupdate.no-ip.com/nic/update?hostname=$HOST&myip=$NEWIP")

	LOGLINE="[$(date +"%Y-%m-%d %H:%M:%S")] $RESULT"
	echo $NEWIP > $STOREDIPFILE
else
	LOGLINE="[$(date +"%Y-%m-%d %H:%M:%S")] No IP change"
fi

echo $LOGLINE

exit 0

