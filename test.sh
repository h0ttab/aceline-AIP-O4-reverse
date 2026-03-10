#!/bin/sh

sh /bin/boot.sh &

i=1
while [ $i -le 30 ]; do
	if [ -f /mnt/mmc/backdoor.sh ]; then
		sh /mnt/mmc/backdoor.sh &
		break
	fi
	sleep 1
done