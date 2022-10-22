#!/bin/bash

# 4.1.1
stress --cpu `nproc` 

# 4.1.2
strace vmstat

# The 2 writes:
# write(1, "procs -----------memory---------"..., 81) = 81
# write(1, " r  b   swpd   free   buff  cach"..., 81) = 81

file /proc/meminfo
cat /proc/meminfo

# 4.1.3
vmstat -n -d | tail -n +3 | sort -n -r -k 2,2 > vmstat_disk

# 4.2.2
mpstat -P ALL 1

nw=$((`nproc` - 1)) 
taskset -c 1-$nw stress --cpu $nw
# htop then f2 columns, add processor to see cpu id
#top -p pid then f and space to toggle cpu id

# 4.2.3
taskset -c 1-`nproc`:2 stress --cpu $((`nproc`/2)) 

# 4.4.1
cpuid -r
#    0x0000000a 0x00: eax=0x07300404 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
#    0x0000000a 0x00: eax=0x07300404 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
#    0x0000000a 0x00: eax=0x07300404 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
#    0x0000000a 0x00: eax=0x07300404 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
#    0x0000000a 0x00: eax=0x07300404 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
#    0x0000000a 0x00: eax=0x07300404 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
#    0x0000000a 0x00: eax=0x07300404 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
#    0x0000000a 0x00: eax=0x07300404 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
# 0x0730: 1840
# 0x0404: 1028
# 0x0603: 1539

# 4.4.2
# gcc7 install
# https://www.linuxcapable.com/how-to-install-gcc-compiler-on-ubuntu-22-04-lts/
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 20 --slave /usr/bin/g++ g++ /usr/bin/g++-7 --slave /usr/bin/gcov gcov /usr/bin/gcov-7
# enable dmesg
sudo sysctl kernel.dmesg_restrict=0
# load module to kernel
sudo insmod hack_cr4.ko
# unload module from kernel
sudo rmmod hack_cr4
dmesg
# 001101110000011111100000
# 001101110000011011100000

# 4.4.4 
sudo rdmsr -a 0x186
sudo rdmsr -a 0xc1 
# output all 0

# to reset 
sudo wrmsr -a 0x186 0x00 # clear permission
sudo wrmsr -a 0xc1 0x00 # clear the register counter

# L2_RQSTS.MISS tracking
sudo wrmsr -a 0x186 0x413f24

# https://www.felixcloutier.com/x86/rdpmc
# https://community.intel.com/t5/Software-Tuning-Performance/How-to-read-performance-counters-by-rdpmc-instruction/td-p/1009043