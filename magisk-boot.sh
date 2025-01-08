#!/system/bin/sh
HOMEDIR=/data/data/com.arlosoft.macrodroid/files/bin
SRCDIR=/storage/emulated/0/init.d
SU_MINISCRIPT='
cd $HOMEDIR

# Patch selinux policy -- error messages here are normal
./magiskpolicy --live --magisk "allow magisk * * *"
	exit 1
setenforce 0
'

mkdir -p $HOMEDIR
cd $HOMEDIR 

	cp $SRCDIR/bin/magiskinit ./
	chmod 700 magiskinit
	ln -fs magiskinit magiskpolicy
	ln -fs magiskinit magisk

# strip ':c512...' tail from selinux context
ctx=$(cat /proc/$$/attr/current)
newctx=${ctx/%:s0:*/:s0}

# start SU daemon
export HOMEDIR
echo "$SU_MINISCRIPT" | runcon $newctx sh

sh -c '
	HOMEDIR=/data/data/com.arlosoft.macrodroid/files/bin
	SRCDIR=/storage/emulated/0/init.d
	cd $HOMEDIR
	mount -o rw,remount /
	mkdir -p /sbin
	mkdir -p $HOMEDIR
	cp $SRCDIR/bin/magiskinit ./
	chmod 700 magiskinit
	ln -fs magiskinit magiskpolicy
	./magiskinit -x magisk /data/data/com.arlosoft.macrodroid/files/bin/magisk
	cp magisk su
	./magisk --daemon
	./magisk --post-fs-data
	./magisk --service
	./magisk --boot-complete
	./su
	magisk --daemon
	magisk --post-fs-data
	magisk --service
	magisk --boot-complete
	su
'

cp -r /sbin/* /apex/com.android.runtime/bin


