#!/system/bin/sh
WriteTo()
{
    echo "$2" > "$1"
}

# Report max frequency to unity tasks.
WriteTo /proc/sys/kernel/sched_lib_name "com.miHoYo,UnityMain,libunity.so"
WriteTo /proc/sys/kernel/sched_lib_mask_force 255