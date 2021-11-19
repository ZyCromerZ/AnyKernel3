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
device.name1=lancelot
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/bootdevice/by-name/boot;
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

X=10;
while [ $X != 0 ];
do
    patch_cmdline "zyc.gpu_clock" " ";
    X=$(($X-1));
done

if [ ! -z "$(cat /tmp/zyc_kernelname | grep "Neutrino" )" ];then
    # 1100
    # 1075
    # 1050
    # 1025
    # 1000 (default)
    # 975
    # 950
    # 925
    # 900
    # 875
    # 850
    # 823
    # 796
    ui_print " ";
    GpuFreq="-1";
    no=0;
    for ListFreq in 1100 1075 1050 1025 1000 975 950 925 900 875 850 823 796; do
        if [ ! -z "$(cat /tmp/zyc_kernelname | grep "${ListFreq}Mhz" )" ];then
            GpuFreq="$no";
            [ "$ListFreq" > "950" ] && ui_print "GPU: set max clock to ${ListFreq}Mhz(oc)";
            [ "$ListFreq" <= "950" ] && ui_print "GPU: set max clock to ${ListFreq}Mhz";
            break;
        fi
        no=$(($no+1));
    done
    patch_cmdline "zyc.gpu_clock" "zyc.gpu_clock=$GpuFreq";
fi

rm -rf /tmp/zyc_kernelname;
# end ramdisk changes

write_boot;
## end install

