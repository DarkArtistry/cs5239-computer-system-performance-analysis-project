#!/usr/bin/env bash

# echo "0_compression_rate,1_compression_rate,2_compression_rate,3_compression_rate,4_compression_rate,5_compression_rate,6_compression_rate,7_compression_rate,8_compression_rate,9_compression_rate" > compression_rate.csv
# echo "0_compression_time,1_compression_time,2_compression_time,3_compression_time,4_compression_time,5_compression_time,6_compression_time,7_compression_time,8_compression_time,9_compression_time" > compression_time.csv
for var in "$@"
do
    echo "File : $var"
    Level="Level: "
    RealT="Real Time: "
    UserT="User Time: "
    SysT="System Time: "
    for i in 0 1 2 3 4 5 6 7 8 9
        do
            Level+="$i,"
            ZipOutput="$((time zip -$i -v $var.zip $var) 2>&1))"
            read -a array <<< $ZipOutput
            # Real time - Real is wall clock time - time from start to finish of the call. This is all elapsed time including time slices used by other processes and time the process spends blocked (for example if it is waiting for I/O to complete).
            RealTime=${array[13]}
            RealTime=${RealTime#*m}
            RealTime=${RealTime%s*}
            RealT+="$RealTime,"

            # User time - is the amount of CPU time spent in user-mode code (outside the kernel) within the process. This is only actual CPU time used in executing the process. Other processes and time the process spends blocked do not count towards this figure.
            UserTime=${array[15]}
            UserTime=${UserTime#*m}
            UserTime=${UserTime%s*}
            UserT+="$UserTime,"

            # System time -  is the amount of CPU time spent in the kernel within the process. This means executing CPU time spent in system calls within the kernel, as opposed to library code, which is still running in user-space. Like 'user', this is only CPU time used by the process. See below for a brief description of kernel mode (also known as 'supervisor' mode) and the system call mechanism.
            SysTime=${array[17]}
            SysTime=${SysTime#*m}
            SysTime=${SysTime%s*}
            SysT+="$SysTime,"

            originalSize=$(stat -c %s $var)
            compressedSize=$(stat -c %s $var.zip)
            reducedSize=$(($originalSize-$compressedSize))
            reductionScale=$(echo "scale=4; $reducedSize / $originalSize" | bc)

            echo $originalSize
            echo $compressedSize
            echo $reducedSize
            echo $reductionScale

        done
    echo $Level
    echo $RealT
    echo $UserT
    echo $SysT
done
