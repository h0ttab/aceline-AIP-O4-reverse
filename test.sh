#!/bin/sh

sh /bin/boot.sh &

timeout=30

while [ $timeout -gt 0 ]; do
    if [ -f /mnt/mmc/backdoor.sh ]; then
		sh /mnt/mmc/backdoor.sh &
		break
	fi
	timeout=$((timeout-1))
	sleep 1
done