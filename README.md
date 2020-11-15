# Lidar-Jetson-Nano-Matlab-SLAM
LidarSLAM in MATLAB using the interference of ROS, Jetson Nano
![](https://github.com/Phayuth/Lidar-Jetson-Nano-Matlab-SLAM/blob/master/MatlabSlamDemo.png?raw=true)
# Requirement
## Hardware
1x [Nvidia Jetson Nano](https://developer.nvidia.com/sites/default/files/akamai/embedded/images/jetsonNano/JetsonNano-DevKit_Front-Top_Right_trimmed.jpg)\
1x [Lidar YDX4 with USB adapter](https://www.robotshop.com/media/catalog/product/cache/image/1350x/9df78eab33525d08d6e5fb8d27136e95/y/d/ydlidar-x4-360-laser-scanner-2_3.jpg)
## Software
Robotic Operating System (ROS) on Nvidia Jetson Nano Ubuntu OS\
Matlab on Window10 OS
# Installation
### Jetson Nano Ubuntu
#### Install Lidar YDX4 ROS Package
Update Ubuntu Source
```
$ sudo apt-get update
```
Create ROS workspace for YDX4 Lidar
```
$ mkdir -p ~/ydlidar_ws/src
```
Clone YDX4 Github repository into src directory and Catkin_make
```
$ mkdir -p ~/ydlidar_ws/src
$ cd ..
$ catkin_make
```
Source setup.bash file\
Openup ~/.bashrc
```
$ gedit ~/.bashrc
```
Scroll down until the last line and write
```
source ~/ydlidar_ws/devel/setup.bash
```
Then Exit out\
Add a device alias /dev/ydlidar to the X4 serial port
```
$ cd src/ydlidar/startup
$ sudo chmod +x initenv.sh
$ sudo sh initenv.sh
```
# Connection
![](https://github.com/s1mpleton/Lidar-Jetson-Nano-Matlab-SLAM/blob/master/Lidar-Connection-Jetsonnano.png)
```
Step 1 : Connect YDX4 and its USB adapter to Jetson Nano via usb serial port
Step 2 : Connect Jetson Nano Ethernet port to Router port
Step 3 : Connect Window10 PC to Router port
```
#### Testing Connection
Discover each machine IP address
##### On Ubuntu Terminal
```
$ ip addr
```
##### On Window10 cmd window
```
$ ipconfig
```
Then Ping each other IP address via
```
$ ping (IP_adress)
```
# Setup ROS master and ROS client
Use Jetson nano as ROS master, Matlab Window as ROS client
### Jetson nano
Openup ~/.bashrc
```
$ gedit ~/.bashrc
```
Scroll down until the last line and write\
Note: Replace {IP} with _localhost_ = if SelfHost, and  _IP Adress of Host_ = if Host by another Machine 
```
export ROS_MASTER_URI=http://{IP}:11311
export ROS_HOSTNAME={Machine IP Adress}
export ROS_IP={Machine IP Adress}
```
Then Exit out
# MATLAB SLAM Function
## Initiate Stage
### Initiate Lidar YDX4
On Ubuntu terminal
Run ROSCORE
```
$ roscore
```
Open Another terminal
```
$ cd ydlidar_ws/src/ydlidar/launch
$ rosluanch lidar.launch
```
### Initiate Subscriber in Matlab
On Matlab terminal
```
>> rosinit('IP Address of ROS Machine');
```
Confirm connection via
```
>> rostopic list
>> rostopic echo /scan
```
### Execute Matlab Script
Run Matlab Script : Slam_Matlab.m\
Change 'For loop'
```
for i=1:{Desire Duration}
```
At the end of for loop, the Result will display on Figure.
#### All Set.
