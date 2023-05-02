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
