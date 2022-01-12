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

if [ ! -z "$(cat /tmp/zyc_kernelname | grep DSP )" ];then
    patch_cmdline "zyc.sultan_pid" "zyc.sultan_pid=0"
    ui_print "- Disable sultan_pid and sultan_pid_map by default";

elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ESP )" ];then
    patch_cmdline "zyc.sultan_pid" "zyc.sultan_pid=1"
    ui_print "- Enable sultan_pid and sultan_pid_map by default";
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep DST )" ];then
    patch_cmdline "zyc.sultan_tid" "zyc.sultan_tid=0"
    ui_print "- Disable sultan_tid and sultan_tid_map by default";

elif [ ! -z "$(cat /tmp/zyc_kernelname | grep EST )" ];then
    patch_cmdline "zyc.sultan_tid" "zyc.sultan_tid=1"
    ui_print "- Enable sultan_tid and sultan_tid_map by default";
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep DSH )" ];then
    patch_cmdline "zyc.sultan_shrink" "zyc.sultan_shrink=0"
    ui_print "- Disable sultan_pid_shrink by default";

elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ESH )" ];then
    patch_cmdline "zyc.sultan_shrink" "zyc.sultan_shrink=1"
    ui_print "- Enable sultan_pid_shrink by default";
fi

if [ ! -z "$(ls $home | grep "dtb-" )" ];then
    if [ ! -z "$(cat /tmp/zyc_kernelname | grep STOCK-UC-OC )" ];then
        cp -af $home/dtb-stock-uc-oc $home/dtb;
        ui_print "- Using STOCK-UC-OC dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep STOCK-UC )" ];then
        cp -af $home/dtb-stock-uc $home/dtb;
        ui_print "- Using STOCK-UC dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep STOCK )" ];then
        cp -af $home/dtb-stock $home/dtb;
        ui_print "- Using STOCK dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep UV-UC-OC )" ];then
        cp -af $home/dtb-uv-uc-oc $home/dtb;
        ui_print "- Using UV-UC-OC dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep UV-UC )" ];then
        cp -af $home/dtb-uv-uc $home/dtb;
        ui_print "- Using UV-UC dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep UV )" ];then
        cp -af $home/dtb-uv $home/dtb;
        ui_print "- Using UV dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep MUV-UC-OC )" ];then
        cp -af $home/dtb-muv-uc-oc $home/dtb;
        ui_print "- Using MUV-UC-OC dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep MUV-UC )" ];then
        cp -af $home/dtb-muv-uc $home/dtb;
        ui_print "- Using MUV-UC dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep MUV )" ];then
        cp -af $home/dtb-muv $home/dtb;
        ui_print "- Using MUV dtb";
    else
        cp -af $home/dtb-stock $home/dtb;
        ui_print "- Using STOCK dtb";
    fi
    rm -rf $home/dtb-*;
fi

rm -rf /tmp/zyc_kernelname;
# end ramdisk changes

write_boot;
## end install

