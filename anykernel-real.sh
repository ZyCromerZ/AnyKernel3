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

### AnyKernel install
# begin attributes
attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
} # end attributes


## boot shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh && attributes;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

# begin ramdisk changes

# hadeh :)
cleanup_hadeh() {
    patch_cmdline "lyb_boost_def" " "
    patch_cmdline "lyb_eff_def" " "
    patch_cmdline "lyb_tsmod" " "
    # patch_cmdline "dfps.min_fps" " "
    # patch_cmdline "dfps.max_fps" " "
    # patch_cmdline "dfps.dynamic_fps" " "
    # patch_cmdline "dfps.skip_fps" " "
    patch_cmdline "zyc.adrenoboost" " "
    patch_cmdline "zyc.cpulimit" " "
    patch_cmdline "zyc.sultan_pid" " "
    patch_cmdline "zyc.sultan_shrink" " "
    patch_cmdline "zyc.cib" " "
    patch_cmdline "zyc.thermal_lock" " "
}

# call function 10x biar seru
X=10
while [ $X != 0 ];
do
    cleanup_hadeh
    X=$(($X-1))
done

cleanup_n_update() {
    local Yaitu="$1"
    local Isinya="$2"
    local X=10
    while [ $X != 0 ];
    do
        patch_cmdline "$Yaitu" " "
        X=$(($X-1))
    done
    if [ "$Isinya" != "null" ];then
        patch_cmdline "$Yaitu" "$Yaitu=$Isinya"
    fi
}

if [ ! -z "$(cat /tmp/zyc_kernelname | grep ADT0 )" ];then
    patch_cmdline "zyc.adrenoboost" "zyc.adrenoboost=0";
    ui_print "- Set Adrenoboost default value to Disable"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ADT1 )" ];then
    patch_cmdline "zyc.adrenoboost" "zyc.adrenoboost=1";
    ui_print "- Set Adrenoboost default value to Low"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ADT2 )" ];then
    patch_cmdline "zyc.adrenoboost" "zyc.adrenoboost=2";
    ui_print "- Set Adrenoboost default value to Medium"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ADT3 )" ];then
    patch_cmdline "zyc.adrenoboost" "zyc.adrenoboost=3";
    ui_print "- Set Adrenoboost default value to High"
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep MPDCL )" ];then
    patch_cmdline "zyc.cpulimit" "zyc.cpulimit=0"
    ui_print "- Disable limit CPU min/max freq on msm_performance module by default";

elif [ ! -z "$(cat /tmp/zyc_kernelname | grep MPECL )" ];then
    patch_cmdline "zyc.cpulimit" "zyc.cpulimit=1"
    ui_print "- Enable limit CPU min/max freq on msm_performance module by default";
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep CIBE )" ];then
    patch_cmdline "zyc.cib" "zyc.cib=1"
    ui_print "- Enable Cpu input Boost by default";

elif [ ! -z "$(cat /tmp/zyc_kernelname | grep CIBD )" ];then
    ui_print "- Disable Cpu input Boost by default";
    patch_cmdline "zyc.cib" "zyc.cib=0"
fi

# if [ ! -z "$(cat /tmp/zyc_kernelname | grep DSP )" ];then
#     patch_cmdline "zyc.sultan_pid" "zyc.sultan_pid=0"
#     ui_print "- Disable sultan_pid and sultan_pid_map by default";

# elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ESP )" ];then
#     patch_cmdline "zyc.sultan_pid" "zyc.sultan_pid=1"
#     ui_print "- Enable sultan_pid and sultan_pid_map by default";
# fi


# if [ ! -z "$(cat /tmp/zyc_kernelname | grep DSH )" ];then
#     patch_cmdline "zyc.sultan_shrink" "zyc.sultan_shrink=0"
#     ui_print "- Disable sultan_pid_shrink by default";

# elif [ ! -z "$(cat /tmp/zyc_kernelname | grep ESH )" ];then
#     patch_cmdline "zyc.sultan_shrink" "zyc.sultan_shrink=1"
#     ui_print "- Enable sultan_pid_shrink by default";
# fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep DFDYE )" ];then
    cleanup_n_update "dfps.dynamic_fps" "1"
    ui_print "- Enable Display Dynamic Refreshrate by default";

elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFDYD )" ];then
    ui_print "- Disable Display Dynamic Refreshrate by default";
    cleanup_n_update "dfps.dynamic_fps" "0"
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep DFSF1 )" ];then
    cleanup_n_update "dfps.skip_fps" "1"
    ui_print "- set dfps.skip_fps to 1";
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFSF2 )" ];then
    cleanup_n_update "dfps.skip_fps" "2"
    ui_print "- set dfps.skip_fps to 2";
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFSF3 )" ];then
    cleanup_n_update "dfps.skip_fps" "3"
    ui_print "- set dfps.skip_fps to 3";
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFSFC )" ];then
    ui_print "- clear dfps.skip_fps value";
    cleanup_n_update "dfps.skip_fps" "null"
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMin120Hz )" ];then
    ui_print "- Set dfps.min_fps to 120Hz"
    cleanup_n_update "dfps.min_fps" "120"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMin100Hz )" ];then
    ui_print "- Set dfps.min_fps to 100Hz"
    cleanup_n_update "dfps.min_fps" "100"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMin90Hz )" ];then
    ui_print "- Set dfps.min_fps to 90Hz"
    cleanup_n_update "dfps.min_fps" "90"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMin75Hz )" ];then
    ui_print "- Set dfps.min_fps to 75Hz"
    cleanup_n_update "dfps.min_fps" "75"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMin60Hz )" ];then
    ui_print "- Set dfps.min_fps to 60Hz"
    cleanup_n_update "dfps.min_fps" "60"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMin50Hz )" ];then
    ui_print "- Set dfps.min_fps to 50Hz"
    cleanup_n_update "dfps.min_fps" "50"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMin48Hz )" ];then
    ui_print "- Set dfps.min_fps to 48Hz"
    cleanup_n_update "dfps.min_fps" "48"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMin30Hz )" ];then
    ui_print "- Set dfps.min_fps to 30Hz"
    cleanup_n_update "dfps.min_fps" "30"
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMax120Hz )" ];then
    ui_print "- Set dfps.max_fps to 120Hz"
    cleanup_n_update "dfps.max_fps" "120"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMax100Hz )" ];then
    ui_print "- Set dfps.max_fps to 100Hz"
    cleanup_n_update "dfps.max_fps" "100"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMax90Hz )" ];then
    ui_print "- Set dfps.max_fps to 90Hz"
    cleanup_n_update "dfps.max_fps" "90"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMax75Hz )" ];then
    ui_print "- Set dfps.max_fps to 75Hz"
    cleanup_n_update "dfps.max_fps" "75"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMax60Hz )" ];then
    ui_print "- Set dfps.max_fps to 60Hz"
    cleanup_n_update "dfps.max_fps" "60"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMax50Hz )" ];then
    ui_print "- Set dfps.max_fps to 50Hz"
    cleanup_n_update "dfps.max_fps" "50"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMax48Hz )" ];then
    ui_print "- Set dfps.max_fps to 48Hz"
    cleanup_n_update "dfps.max_fps" "48"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep DFMax30Hz )" ];then
    ui_print "- Set dfps.max_fps to 30Hz"
    cleanup_n_update "dfps.max_fps" "30"
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep FST16 )" ];then
    cleanup_n_update "zyc.thermal_lock" "16"
    ui_print "- Set zyc.thermal_lock to 16"
elif [ ! -z "$(cat /tmp/zyc_kernelname | grep FST10 )" ];then
    cleanup_n_update "zyc.thermal_lock" "10"
    ui_print "- Set zyc.thermal_lock to 10"
fi

if [[ ! -z "$(cat /tmp/zyc_kernelname | grep ODTBO )" ]];then
    cleanup_n_update "zyc.old_mdsi" "1"
    ui_print "- Set zyc.old_mdsi to 1"
elif [[ ! -z "$(cat /tmp/zyc_kernelname | grep NDTBO )" ]];then
    cleanup_n_update "zyc.old_mdsi" "0"
    ui_print "- Set zyc.old_mdsi to 0"
else
    if [[ -e /system/build.prop ]];then
        android_ver=$(file_getprop /system/build.prop ro.build.version.sdk);
        if [[ "$android_ver" -ge "31" ]];then
            cleanup_n_update "zyc.old_mdsi" "0"
            ui_print "- Set zyc.old_mdsi to 0"
        else
            cleanup_n_update "zyc.old_mdsi" "1"
            ui_print "- Set zyc.old_mdsi to 1"
        fi
    fi
fi

if [ ! -z "$(ls $home | grep "dtb-" )" ];then
    if [ -f $home/dtb-stock-uc-oc ] && [ ! -z "$(cat /tmp/zyc_kernelname | grep STOCK-UC-OC )" ];then
        cp -af $home/dtb-stock-uc-oc $home/dtb;
        ui_print "- Using STOCK-UC-OC dtb";
    elif [ -f $home/dtb-stock-uc ] && [ ! -z "$(cat /tmp/zyc_kernelname | grep STOCK-UC )" ];then
        cp -af $home/dtb-stock-uc $home/dtb;
        ui_print "- Using STOCK-UC dtb";
    elif [ ! -z "$(cat /tmp/zyc_kernelname | grep STOCK )" ];then
        cp -af $home/dtb-stock $home/dtb;
        ui_print "- Using STOCK dtb";
    elif [ -f $home/dtb-muv-uc-oc ] && [ ! -z "$(cat /tmp/zyc_kernelname | grep MUV-UC-OC )" ];then
        cp -af $home/dtb-muv-uc-oc $home/dtb;
        ui_print "- Using MUV-UC-OC dtb";
    elif [ -f $home/dtb-muv-uc ] && [ ! -z "$(cat /tmp/zyc_kernelname | grep MUV-UC )" ];then
        cp -af $home/dtb-muv-uc $home/dtb;
        ui_print "- Using MUV-UC dtb";
    elif [ -f $home/dtb-muv ] && [ ! -z "$(cat /tmp/zyc_kernelname | grep MUV )" ];then
        cp -af $home/dtb-muv $home/dtb;
        ui_print "- Using MUV dtb";
    elif [ -f $home/dtb-uv-uc-oc ] && [ ! -z "$(cat /tmp/zyc_kernelname | grep UV-UC-OC )" ];then
        cp -af $home/dtb-uv-uc-oc $home/dtb;
        ui_print "- Using UV-UC-OC dtb";
    elif [ -f $home/dtb-uv-uc ] && [ ! -z "$(cat /tmp/zyc_kernelname | grep UV-UC )" ];then
        cp -af $home/dtb-uv-uc $home/dtb;
        ui_print "- Using UV-UC dtb";
    elif [ -f $home/dtb-uv ] && [ ! -z "$(cat /tmp/zyc_kernelname | grep UV )" ];then
        cp -af $home/dtb-uv $home/dtb;
        ui_print "- Using UV dtb";
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

