# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=ExampleKernel by osm0sis @ xda-developers
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=vayu
device.name2=bhima
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# hadeh :)
cleanup_hadeh() {
    patch_cmdline "lyb_boost_def" " "
    patch_cmdline "lyb_eff_def" " "
    patch_cmdline "lyb_tsmod" " "
    patch_cmdline "dfps.min_fps" " "
    patch_cmdline "dfps.max_fps" " "
    patch_cmdline "zyc.adrenoboost" " "
    patch_cmdline "zyc.cpulimit" " "
}

# call function 10x biar seru
X=10
while [ $X != 0 ];
do
    cleanup_hadeh
    X=$(($X-1))
done

if [ ! -z "$(cat /tmp/zyc_kernelname | grep ADT0 )" ];then
    patch_cmdline "zyc.adrenoboost" "zyc.adrenoboost=0";
    ui_print "Set Adrenoboost default value to Disable"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ADT1 )" ];then
    patch_cmdline "zyc.adrenoboost" "zyc.adrenoboost=1";
    ui_print "Set Adrenoboost default value to Low"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ADT2 )" ];then
    patch_cmdline "zyc.adrenoboost" "zyc.adrenoboost=2";
    ui_print "Set Adrenoboost default value to Medium"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ADT3 )" ];then
    patch_cmdline "zyc.adrenoboost" "zyc.adrenoboost=3";
    ui_print "Set Adrenoboost default value to High"
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep MPDCL )" ];then
    patch_cmdline "zyc.cpulimit" "zyc.cpulimit=0"
    ui_print "- Disable limit CPU min/max freq on msm_performance module";

elif [ ! -z "$(cat /tmp/zyc_kernelname | grep MPECL )" ];then
    patch_cmdline "zyc.cpulimit" "zyc.cpulimit=1"
    ui_print "- Enable limit CPU min/max freq on msm_performance module";
fi

rm -rf /tmp/zyc_kernelname
# end ramdisk changes

write_boot;
## end install

