#!/sbin/busybox sh

# Read system data out of /efs and put it into /system/etc

export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

if test ! -e "/efs/serial.info"; then
	exit 1
fi
cp /efs/serial.info /system/etc/serial.info
if test ! -e "/efs/buyer_code.dat"; then
	exit 1
fi
cp /efs/buyer_code.dat /system/etc/buyer_code.dat
if test ! -e "/efs/imei/.nvmac.info"; then
	exit 1
fi
cp /efs/imei/.nvmac.info /system/etc/wifi_addr
if test ! -e "/efs/imei/bt.txt"; then
	exit 1
fi
addr=`cat /efs/imei/bt.txt | cut -d':' -f2`
echo "${addr:0:2}:${addr:2:2}:${addr:4:2}:${addr:6:2}:${addr:8:2}:${addr:10:2}" > /system/etc/bt_addr
