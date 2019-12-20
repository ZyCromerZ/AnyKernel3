# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Spectrum Injectror for DeadlyCute/QuantumKiller by ZyCromerZ
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=X01BD
device.name2=X01BDA
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chmod -R 755 $ramdisk/sbin;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc
backup_file init.rc;
remove_line init.rc "import init.spectrum.rc"
remove_line init.rc "/import init.spectrum.rc"

if [ -e $ramdisk/init.spectrum.rc ];then
  rm -rf $ramdisk/init.spectrum.rc
  ui_print "delete /init.spectrum.rc"
fi
if [ -e $ramdisk/init.spectrum.sh ];then
  rm -rf $ramdisk/init.spectrum.sh
  ui_print "delete /init.spectrum.sh"
fi
if [ -e $ramdisk/sbin/init.spectrum.rc ];then
  rm -rf $ramdisk/sbin/init.spectrum.rc
  ui_print "delete /sbin/init.spectrum.rc"
fi
if [ -e $ramdisk/sbin/init.spectrum.sh ];then
  rm -rf $ramdisk/sbin/init.spectrum.sh
  ui_print "delete /sbin/init.spectrum.sh"
fi
if [ -e $ramdisk/etc/init.spectrum.rc ];then
  rm -rf $ramdisk/etc/init.spectrum.rc
  ui_print "delete /etc/init.spectrum.rc"
fi
if [ -e $ramdisk/etc/init.spectrum.sh ];then
  rm -rf $ramdisk/etc/init.spectrum.sh
  ui_print "delete /etc/init.spectrum.sh"
fi
if [ -e $ramdisk/init.aurora.rc ];then
  rm -rf $ramdisk/init.aurora.rc
  ui_print "delete /init.aurora.rc"
fi
if [ -e $ramdisk/sbin/init.aurora.rc ];then
  rm -rf $ramdisk/sbin/init.aurora.rc
  ui_print "delete /sbin/init.aurora.rc"
fi
if [ -e $ramdisk/etc/init.aurora.rc ];then
  rm -rf $ramdisk/etc/init.aurora.rc
  ui_print "delete /etc/init.aurora.rc"
fi


write_boot;

## end install


unmount /system
unmount /vendor
mount /system
mount /vendor

# add spectrum support
if [ ! -e /vendor/etc/init/hw/init.qcom.rc.backup ];then
  cp -af /vendor/etc/init/hw/init.qcom.rc /vendor/etc/init/hw/init.qcom.rc.backup
fi
if [ -e /vendor/etc/init/hw/init.spectrum.rc.backup ];then
  rm -rf /vendor/etc/init/hw/init.spectrum.rc.backup
fi
remove_line /vendor/etc/init/hw/init.qcom.rc "import /init.spectrum.rc"
remove_line /vendor/etc/init/hw/init.qcom.rc "import init.spectrum.rc"
# cprofile remover
if [ -e /system/xbin/cprofile ];then
  rm -rf /system/xbin/cprofile
  ui_print "remove /system/xbin/cprofile"
fi
if [ -e /system/bin/cprofile ];then
  rm -rf /system/bin/cprofile
  ui_print "remove /system/bin/cprofile"
fi
if [ -e /vendor/bin/cprofile ];then
  rm -rf /vendor/bin/cprofile
  ui_print "remove /vendor/bin/cprofile"
fi
if [ -e /system/init.spectrum.rc ];then
  rm -rf /system/init.spectrum.rc
  ui_print "remove /system/init.spectrum.rc"
fi
if [ -e /system/init.spectrum.sh ];then
  rm -rf /system/init.spectrum.sh
  ui_print "remove /system/init.spectrum.sh"
fi
if [ -e /vendor/etc/init/hw/init.spectrum.rc ];then
  rm -rf /vendor/etc/init/hw/init.spectrum.rc
  remove_line /vendor/etc/init/hw/init.qcom.rc "import /vendor/etc/init/hw/init.spectrum.rc" 
fi

unmount /system
unmount /vendor
