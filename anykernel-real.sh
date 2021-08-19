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
}

# call function 10x biar seru
X=10
while [ $X != 0 ];
do
    cleanup_hadeh
    X=$(($X-1))
done

# end ramdisk changes

write_boot;
## end install

