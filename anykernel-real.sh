### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# begin properties
properties() { '
kernel.string=ExampleKernel by osm0sis @ xda-developers
do.devicecheck=1
do.modules=1
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=begonia
device.name2=begoniain
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
block=/dev/block/platform/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh && attributes;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

# init.rc
# backup_file init.rc;
# replace_string init.rc "cpuctl cpu,timer_slack" "mount cgroup none /dev/cpuctl cpu" "mount cgroup none /dev/cpuctl cpu,timer_slack";

# # init.tuna.rc
# backup_file init.tuna.rc;
# insert_line init.tuna.rc "nodiratime barrier=0" after "mount_all /fstab.tuna" "\tmount ext4 /dev/block/platform/omap/omap_hsmmc.0/by-name/userdata /data remount nosuid nodev noatime nodiratime barrier=0";
# append_file init.tuna.rc "bootscript" init.tuna;

# # fstab.tuna
# backup_file fstab.tuna;
# patch_fstab fstab.tuna /system ext4 options "noatime,barrier=1" "noatime,nodiratime,barrier=0";
# patch_fstab fstab.tuna /cache ext4 options "barrier=1" "barrier=0,nomblk_io_submit";
# patch_fstab fstab.tuna /data ext4 options "data=ordered" "nomblk_io_submit,data=writeback";
# append_file fstab.tuna "usbdisk" fstab;

# begin ramdisk changes

X=10;
while [ $X != 0 ];
do
    patch_cmdline "zyc.gpu_clock" " ";
    patch_cmdline "zyc.uv_gpu" "";
    patch_cmdline "zyc.uv_vsram" "";
    patch_cmdline "zyc.uv_cpu" "";
    patch_cmdline "androidboot.forceenforcing" "";
    X=$(($X-1));
done

if [ -z "$(cat /tmp/zyc_kernelname | grep "Neutrino-Stock" )" ];then
    # 0 900Mhz
    # 1 897Mhz
    # 2 892Mhz
    # 3 888Mhz
    # 4 884Mhz
    # 5 880Mhz
    # 6 875Mhz
    # 7 871Mhz
    # 8 867Mhz
    # 9 862Mhz
    # 10 858Mhz
    # 11 854Mhz
    # 12 850Mhz
    # 13 835Mhz
    # 14 821Mhz
    # 15 806Mhz (default)
    ui_print " ";
    GpuFreq="15";
    no=0;
    for ListFreq in 900 897 892 888 884 880 875 871 867 862 858 854 850 835 821 806; do
        if [ ! -z "$(cat /tmp/zyc_kernelname | grep "${ListFreq}Mhz" )" ];then
            GpuFreq="$no";
            [ "$no" != "15" ] && ui_print "GPU: set max clock to ${ListFreq}Mhz(oc)";
            [ "$no" == "15" ] && ui_print "use standard max clock 806Mhz(stock)";
            break;
        fi
        no=$(($no+1));
    done
    patch_cmdline "zyc.gpu_clock" "zyc.gpu_clock=$GpuFreq";
    # 100 = 1mV
    # no=0;
    # UvGpu=0;
    # while [ $no -lt 50 ]; do
    #     if [ ! -z "$(cat /tmp/zyc_kernelname | grep "G${no}mV" )" ];then
    #         UvGpu="${no}00";
    #         ui_print "GPU: Undervolt to -${no}mV";
    #         break;
    #     fi
    #     no=$(($no+1));
    # done
    # [ "$no" != "50" ] && patch_cmdline "zyc.uv_gpu" "zyc.uv_gpu=$UvGpu";
    # no=0;
    # UvVsram=0;
    # while [ $no -lt 50 ]; do
    #     if [ ! -z "$(cat /tmp/zyc_kernelname | grep "V${no}mV" )" ];then
    #         UvVsram="${no}00";
    #         ui_print "VSRAM: Undervolt to -${no}mV";
    #         break;
    #     fi
    #     no=$(($no+1));
    # done
    # [ "$no" != "50" ] && patch_cmdline "zyc.uv_vsram" "zyc.uv_vsram=$UvVsram";
    # no=0;
    # UvCpu=0;
    # while [ $no -lt 50 ]; do
    #     if [ ! -z "$(cat /tmp/zyc_kernelname | grep "C${no}mV" )" ];then
    #         UvCpu="${no}00";
    #         ui_print "CPU: Undervolt to -${no}mV";
    #         break;
    #     fi
    #     no=$(($no+1));
    # done
    # [ "$no" != "50" ] && patch_cmdline "zyc.uv_cpu" "zyc.uv_cpu=$UvCpu";
fi

if [ ! -z "$(cat /tmp/zyc_kernelname | grep "Enforcing" )" ] || [ -f /system_root/system/app/SecurityCoreAdd/SecurityCoreAdd.apk ] || [ -f /system/app/SecurityCoreAdd/SecurityCoreAdd.apk ];then
    patch_cmdline "androidboot.forceenforcing" "androidboot.forceenforcing=y";
fi

rm -rf /tmp/zyc_kernelname;

# end ramdisk changes

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install


## init_boot shell variables
#block=init_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for init_boot patching
#reset_ak;

# init_boot install
#dump_boot; # unpack ramdisk since it is the new first stage init ramdisk where overlay.d must go

#write_boot;
## end init_boot install


## vendor_kernel_boot shell variables
#block=vendor_kernel_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for vendor_kernel_boot patching
#reset_ak;

# vendor_kernel_boot install
#split_boot; # skip unpack/repack ramdisk, e.g. for dtb on devices with hdr v4 and vendor_kernel_boot

#flash_boot;
## end vendor_kernel_boot install


## vendor_boot shell variables
#block=vendor_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for vendor_boot patching
#reset_ak;

# vendor_boot install
#dump_boot; # use split_boot to skip ramdisk unpack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot

#write_boot; # use flash_boot to skip ramdisk repack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot
## end vendor_boot install

