# Analyze Celestia Light Nodes step by step through a shell script.

This share analyzes the server from the following points: memory, CPU, disk IO, network traffic, etc.


```shell
apt-get install sysstat

apt-get install net-tools

apt-get install iftop

apt install htop
```

1. Check CPU utilization and load (top, vmstat)

2. Check disk, Inode utilization and I/O load (iostat)

3. Check memory utilization (free)

4. Check the 10 processes with the highest CPU and memory utilization (htop)

5. Check network traffic (iftop)

Use the shell script to share some performance and basic information about the current server, and also use this script to view the server in the process of running some simple optimization of Celestia running light node service process.


```shell
#! /bin/bash
# Get the IP address of the local server to monitor
IP=`ifconfig | grep inet | grep -vE 'inet6|127.0.0.1' | awk '{print $2}'`
echo "IP address:"$IP
 
# Get the total number of cpu cores
cpu_num=`grep -c "model name" /proc/cpuinfo`
echo "Total cores of cpu:"$cpu_num
 
# 1. Get CPU utilization
################################################
#us user space CPU utilization percentage
#sy Percentage of CPU occupied in kernel space
#ni Percentage of CPU occupied by processes in user process space that have changed priority
#id Percentage of idle CPU
#wa Percentage of CPU time waiting for input and output
#hi Hardware interrupts
#si Software interrupts
#################################################
# get the percentage of CPU occupied by user space
cpu_user=`top -b -n 1 | grep Cpu | awk '{print $2}' | cut -f 1 -d "%"`
echo "Percentage of CPU occupied in user space: "$cpu_user
 
# Get the percentage of CPU occupied in kernel space
cpu_system=`top -b -n 1 | grep Cpu | awk '{print $4}' | cut -f 1 -d "%"`
echo "Percentage of CPU occupied in kernel space:" $cpu_system
 
# Get the free CPU percentage
cpu_idle=`top -b -n 1 | grep Cpu | awk '{print $8}' | cut -f 1 -d "%"`
echo "Idle CPU percentage:"$cpu_idle
 
# Get the percentage of CPU waiting for input and output
cpu_iowait=`top -b -n 1 | grep Cpu | awk '{print $10}' | cut -f 1 -d "%"`
echo "Waiting for input and output as a percentage of CPU: "$cpu_iowait
 
#2. Get the number of CPU context switches and interrupts
# Get the number of CPU interrupts
cpu_interrupt=`vmstat -n 1 1 | sed -n 3p | awk '{print $11}'`
echo "Number of CPU interrupts:" $cpu_interrupt
 
# Get the number of CPU context switches
cpu_context_switch=`vmstat -n 1 1 | sed -n 3p | awk '{print $12}'`
echo "Number of CPU context switches:" $cpu_context_switch
 
#3. Get CPU load information
# Get the CPU load average from 15 minutes ago to now
cpu_load_15min=`uptime | awk '{print $11}' | cut -f 1 -d ','`
echo "CPU load average from 15 minutes ago to now:" $cpu_load_15min
 
# Get the CPU load average from 5 minutes ago to now
cpu_load_5min=`uptime | awk '{print $10}' | cut -f 1 -d ','`
echo "CPU load average from 5 minutes ago to now:" $cpu_load_5min
 
# Get the CPU load average from 1 minute ago to now
cpu_load_1min=`uptime | awk '{print $9}' | cut -f 1 -d ','`
echo "CPU load average from 1 minute ago to now:" $cpu_load_1min
 
# Get the task queue (number of processes waiting in the ready state)
cpu_task_length=`vmstat -n 1 1 | sed -n 3p | awk '{print $1}'`
echo "CPU task queue length:" $cpu_task_length
 
#4. Get memory information
# Get the total amount of physical memory
mem_total=`free | grep Mem | awk '{print $2}'`
echo "Total physical memory:" $mem_total
 
# Get the total amount of memory used by the operating system
mem_sys_used=`free | grep Mem | awk '{print $3}'`
echo "Total memory used (operating system): "$mem_sys_used
 
# Get the total amount of unused memory for the operating system
mem_sys_free=`free | grep Mem | awk '{print $4}'`
echo "Total memory remaining (operating system):" $mem_sys_free
 
# Get the total amount of memory used by the application
mem_user_used=`free | sed -n 3p | awk '{print $3}'`
echo "Total memory used (application):" $mem_user_used
 
# Get the total amount of unused memory for the application
mem_user_free=`free | sed -n 3p | awk '{print $4}'`
echo "Total memory remaining (for the application):" $mem_user_free
 
 
# Get the total size of the swap partition
mem_swap_total=`free | grep Swap | awk '{print $2}'`
echo "Total size of swap partition:"$mem_swap_total
 
# Get the size of the used swap partition
mem_swap_used=`free | grep Swap | awk '{print $3}'`
echo "Swap partition size used:" $mem_swap_used
 
# Get the remaining swap partition size
mem_swap_free=`free | grep Swap | awk '{print $4}'`
echo "Remaining swap partition size:" $mem_swap_free
 

#5. Get disk I/O statistics
echo "Statistics for the specified device (/dev/sda)"
# of read requests made to the device per second
disk_sda_rs=`iostat -kx | grep sda| awk '{print $4}'`
echo "Number of read requests to the device per second:" $disk_sda_rs
 
# of write requests to the device per second
disk_sda_ws=`iostat -kx | grep sda| awk '{print $5}'`
echo "Number of write requests initiated to the device per second:" $disk_sda_ws
 
# Average of I/O request queue lengths initiated to the device
disk_sda_avgqu_sz=`iostat -kx | grep sda| awk '{print $9}'`
echo "Average of the queue length of I/O requests to the device" $disk_sda_avgqu_sz
 
# Average time for each I/O request initiated to the device
disk_sda_await=`iostat -kx | grep sda| awk '{print $10}'`
echo "Average time per I/O request to the device:" $disk_sda_await
 
# Average time to initiate I/O service to the device
disk_sda_svctm=`iostat -kx | grep sda| awk '{print $11}'`
echo "Average value of I/O service time initiated to the device: "$disk_sda_svctm
 
# Percentage of CPU time to initiate I/O requests to the device
disk_sda_util=`iostat -kx | grep sda| awk '{print $12}'`
echo "Percentage of CPU time to initiate I/O requests to the device: "$disk_sda_util
```


First I checked the CPU, memory and IO load factor with the complete shell script above, executing `sh analyse.sh`
I get the following results,


![alt uptime](https://github.com/icphoto/celestia_node_analyse/blob/main/shell-cpu.png?raw=true)

The results showed that the CPU load was only around 2.2, the swap partition was not used, the tasks were only running the basic Celestia service, and the average IO request time was very low, thanks to my server configuration, which is currently 4 CPUs and 8G RAM.

After getting the above results, I then installed `apt install htop` and used `htop -t` to check the status of the currently running services including: CPU, physical memory and swap partition information, number of tasks, average load and connection uptime;

![alt uptime](https://github.com/icphoto/celestia_node_analyse/blob/main/htop.png?raw=true)

In fact, I tested the current server in two ways, and from the results it looks like the running light nodes are very healthy, with high memory and high CPU, running light nodes without any problems, maybe I should reduce my budget to be able to separate the server to run two services, of course for data availability I believe I will have more advantages with high CPU and memory.

![alt uptime](https://github.com/icphoto/celestia_node_analyse/blob/main/iftop.png?raw=true)

Finally, I checked the traffic through `iftop` and got a friendly result. The stable traffic input and output is one of the important indicators for light nodes, which I believe will provide Celestia with a stable node service and data availability service.
