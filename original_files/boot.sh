#!/bin/sh

# set reserve memery
echo 512 > /proc/sys/vm/min_free_kbytes

# enumerate all jffs nodes to prevent loss
du -a /var/syscfg > /dev/null

# mount /mnt/mtd
mount -t squashfs /dev/mtdblock3 /mnt/mtd
mnt_mtd_mount_result=$?

/mnt/mtd/bin/first_aid.sh

# load exfat ko
if [ -f /mnt/mtd/module/exfat_t31.ko ];then
  /sbin/insmod /mnt/mtd/module/exfat_t31.ko
else [ -f /lib/modules/exfat_t31.ko ];
  /sbin/insmod /lib/modules/exfat_t31.ko
fi

# start sellcmdD
/bin/shellcmdD &

# load gpio driver
if [ -f /mnt/mtd/module/gpioCtrl.ko ];then
    /sbin/insmod /mnt/mtd/module/gpioCtrl.ko
else
    /sbin/insmod /lib/modules/gpioCtrl.ko
fi
sleep 0.1

# load other driver, wifi, 4G and other driver needed
/bin/load_driver.sh

# wait till sd card can be detected
sleep 2

# check sd ota upgrade
if [ -f /mnt/mmc/ota_firmware.pkg ];then
    echo "find sd card ota_firmware.pkg, start ota upgrade from sd card!!"
    /bin/ota_upgrade 2
fi

# check mount /mnt/mtd result
if [ "$mnt_mtd_mount_result" -eq 0 ];then
  echo "mount /mnt/mtd success"
else
  echo "mount /mnt/mtd failed!!"
  echo "start ota upgrade..."
  /bin/ota_upgrade 0 &
  exit 0
fi

# ipc start
sh /mnt/mtd/bin/ipc_start.sh &