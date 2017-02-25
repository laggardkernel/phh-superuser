#!/system/bin/sh

LOGFILE=/cache/magisk.log
MODDIR=${0%/*}

if [ -d /data/busybox ]; then
  TOOLPATH=/data/busybox
else
  TOOLPATH=/dev/busybox
fi

log_print() {
  echo $1
  echo "phh: $1" >> $LOGFILE
  log -p i -t phh "$1"
}

# Disable the other root
[ -d "/magisk/zzsupersu" ] && touch /magisk/zzsupersu/disable

log_print "Live patching sepolicy"
$MODDIR/bin/sepolicy-inject --live

log_print "Moving and linking /sbin binaries"
mount -o rw,remount rootfs /
mv /sbin /sbin_orig
mkdir /sbin
chmod 755 /sbin
ln -s /sbin_orig/* /sbin
mount -o ro,remount rootfs /

# Expose the root path
log_print "Mounting supath"
rm -rf /magisk/.core/bin $MODDIR/sbin_bind
mkdir -p $MODDIR/sbin_bind 
$TOOLPATH/cp -afc /sbin/. $MODDIR/sbin_bind
chmod 755 $MODDIR/sbin_bind
ln -s $MODDIR/bin/* $MODDIR/sbin_bind
mount -o bind $MODDIR/sbin_bind /sbin

# Run su.d
for script in $MODDIR/su.d/* ; do
  if [ -f "$script" ]; then
    chmod 755 $script
    log_print "su.d: $script"
    sh $script
  fi
done

log_print "Starting su daemon"
[ ! -z $OLDPATH ] && export PATH=$OLDPATH
/sbin/su --daemon
