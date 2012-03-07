#!/tmp/busybox sh

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

BB=/tmp/busybox

if $BB test -e /dev/block/mtdblock0 ; then
	$BB echo "MTD not supported"
	exit 1
fi

SDCARD=""
if $BB grep -q "^/dev/block/mmcblk0p1 /sdcard " /proc/mounts ; then
	SDCARD="/sdcard"
fi
if $BB grep -q "^/dev/block/mmcblk0p1 /mnt/sdcard " /proc/mounts ; then
	SDCARD="/mnt/sdcard"
fi
if $BB test -z "$SDCARD" ; then
	$BB echo "sdcard not mounted"
	exit 2
fi

is_mounted()
{
	if $BB grep -q "^$1" /proc/mounts ; then
		return 0
	fi
	return 1
}

is_rfs()
{
	if is_mounted "$1" ; then
		$BB umount "$1"
	fi
	if is_mounted "$1" ; then
		$BB echo "cannot unmount $1"
		exit 3
	fi

	if $BB mount -t rfs $1 /$2 ; then
		$BB umount /$2
		return 0
	fi
	return 1
}

backup()
{
	$BB dd if="$1" of="$SDCARD/$2.img"
}

convert()
{
	if is_mounted "$1" ; then
		$BB umount "$1"
	fi
	if is_mounted "$1" ; then
		$BB echo "cannot unmount $1"
		exit 3
	fi
	/tmp/make_ext4fs "$1"
}

if is_rfs "/dev/block/stl9" ; then
	backup "/dev/block/stl3"  efs
	backup "/dev/block/stl9"  system
	backup "/dev/block/stl10" dbdata
	backup "/dev/block/mmcblk0p2" data

	convert "/dev/block/stl3"  efs
	convert "/dev/block/stl9"  system
	convert "/dev/block/stl10" dbdata
	convert "/dev/block/stl11" cache
	convert "/dev/block/mmcblk0p2" data
fi
