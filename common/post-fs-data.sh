#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
LOGFILE=/cache/magisk.log
MODDIR=${0%/*}

# MOUNTPOINT=/magisk

# COREDIR=$MOUNTPOINT/.core

# TMPDIR=/dev/magisk
# DUMMDIR=$TMPDIR/dummy
# MIRRDIR=$TMPDIR/mirror
# MOUNTINFO=$TMPDIR/mnt

# Use the included busybox for maximum compatibility and reliable results
# e.g. we rely on the option "-c" for cp (reserve contexts), and -exec for find
if [ -d /data/busybox ]; then
  TOOLPATH=/data/busybox
else
  TOOLPATH=/dev/busybox
fi
# BINPATH=/data/magisk

# export OLDPATH=$PATH
# export PATH=$TOOLPATH:$OLDPATH

log_print() {
  echo $1
  echo "phh: $1" >> $LOGFILE
  log -p i -t phh "$1"
}

bind_mount() {
  if [ -e "$1" -a -e "$2" ]; then
    mount -o bind $1 $2
    if [ "$?" -eq "0" ]; then 
      log_print "Mount: $1"
    else 
      log_print "Mount Fail: $1"
    fi 
  fi
}

# if other su binaries exist, route them to ours
# mount -o bind $MODDIR/bin/su /sbin/su 2>/dev/null
mount -o bind $MODDIR/bin/su /system/bin/su 2>/dev/null
# mount -o bind $MODDIR/bin/su /system/xbin/su 2>/dev/null

# poor man's overlay on /system/xbin
if [ -f "$MODDIR/xbin_bind/enable" ]; then
  log_print "Binding phh's su to xbin"
  rm -rf "$MODDIR/xbin_bind"
  mkdir -p "$MODDIR/xbin_bind"
  touch "$MODDIR/xbin_bind/enable"
  $TOOLPATH/cp -afc /system/xbin/. $MODDIR/xbin_bind
  rm -rf $MODDIR/xbin_bind/su $MODDIR/xbin_bind/sepolicy-inject 2>/dev/null
  chmod -R 755 $MODDIR/xbin_bind
  chcon -hR "u:object_r:system_file:s0" $MODDIR/xbin_bind
  ln -s $MODDIR/bin/* $MODDIR/xbin_bind 2>/dev/null
  bind_mount $MODDIR/xbin_bind /system/xbin
fi
