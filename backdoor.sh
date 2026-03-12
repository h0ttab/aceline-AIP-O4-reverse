#!/bin/sh

telnetd -l /bin/sh -p 23 &

timeout=60

while [ $timeout -gt 0 ]; do
	if [ -f /var/hostapd.conf ]; then
		break
	fi
	timeout=$((timeout-1))
	sleep 1
done

sleep 1

killall hostapd
{
echo "wpa=2"
echo "wpa_passphrase=MySecretPassword123"
echo "wpa_key_mgmt=WPA-PSK"
echo "wpa_pairwise=TKIP CCMP"
echo "rsn_pairwise=CCMP"
} >> /var/hostapd.conf

sleep 1
hostapd -B /var/hostapd.conf &