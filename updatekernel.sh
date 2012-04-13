#!/sbin/busybox sh

# Update the kernel, and reboot if the running kernel does not support MTD

export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

if test ! -e "/efs/buyer_code.dat"; then
	exit 255
fi
bc=`cat /efs/buyer_code.dat`

kernel="/tmp/kernel"
if test -e "/tmp/kernel-$bc"; then
	kernel="/tmp/kernel-$bc"
fi

/tmp/flash_kernel $kernel /dev/block/bml7
if test $? -ne 0; then
	exit 1
fi

if test ! -e /proc/mtd; then
	reboot
	exit 1
fi
