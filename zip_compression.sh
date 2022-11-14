#!/usr/bin/env bash

#############################################################
# INSTRUCTIONS:                                             #
# bash compression.sh file1 file2 ...                       #
# Example: bash compression.sh big.txt MARBLES.bmp RAY.bmp  #
#############################################################

for var in "$@"
do
    echo "File : $var"
    echo "-------------"
    Level="Level: "
    RealT="Real Time: "
    UserT="User Time: "
    SysT="System Time: "
    InitialSize="Initial Size: "
    ZipSize="Compressed Size: "
    ReductionSize="Reduction Size: "
    ReductionScale="Reduction Scale: "
    CompressionRatio="Compression Ratio: "

    for i in 0 1 2 3 4 5 6 7 8 9
        do
            Level+="$i,"
            ZipOutput="$((time zip -$i -v $var.zip $var) 2>&1))"
            # echo $ZipOutput
            array=($ZipOutput)
            # read -a array <<< $ZipOutput
            # echo $array[13]
            # echo "----"
            # Real time - Real is wall clock time - time from start to finish of the call. This is all elapsed time including time slices used by other processes and time the process spends blocked (for example if it is waiting for I/O to complete).
            RealTime=${array[13]}
            # echo "$RealTime"
            RealTime=${RealTime#*m}
            RealTime=${RealTime%s*}
            RealT+="$RealTime,"
            # echo "$RealTime"

            # User time - is the amount of CPU time spent in user-mode code (outside the kernel) within the process. This is only actual CPU time used in executing the process. Other processes and time the process spends blocked do not count towards this figure.
            UserTime=${array[15]}
            # echo $UserTime
            UserTime=${UserTime#*m}
            UserTime=${UserTime%s*}
            UserT+="$UserTime,"
            # echo $UserTime

            # System time -  is the amount of CPU time spent in the kernel within the process. This means executing CPU time spent in system calls within the kernel, as opposed to library code, which is still running in user-space. Like 'user', this is only CPU time used by the process. See below for a brief description of kernel mode (also known as 'supervisor' mode) and the system call mechanism.
            SysTime=${array[17]}
            # echo $SysTime
            SysTime=${SysTime#*m}
            SysTime=${SysTime%s*}
            SysT+="$SysTime,"
            # echo $SysTime


            originalSize=$(stat -c %s $var)
            compressedSize=$(stat -c %s $var.zip)
            reducedSize=$(($originalSize-$compressedSize))
            reducedScale=$(echo "scale=4; $reducedSize / $originalSize" | bc)
            compressionRatioCal=$(echo "$compressedSize/$originalSize")

            InitialSize+="$originalSize,"
            ZipSize+="$compressedSize,"
            ReductionSize+="$reducedSize,"
            ReductionScale+="$reducedScale,"
            CompressionRatio+="$compressionRatioCal"
        done
    echo $Level
    echo $RealT
    echo $UserT
    echo $SysT
    echo $InitialSize
    echo $ZipSize
    echo $ReductionSize
    echo $ReductionScale
    echo $CompressionRatio
    echo ""
done