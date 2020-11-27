# Lidar-Jetson-Nano-Matlab-Hector-SLAM
![](https://github.com/Phayuth/Lidar-Jetson-Nano-Matlab-SLAM/blob/master/MatlabSlamDemo.png?raw=true)
# Requirement
## Hardware
1x [Nvidia Jetson Nano](https://developer.nvidia.com/sites/default/files/akamai/embedded/images/jetsonNano/JetsonNano-DevKit_Front-Top_Right_trimmed.jpg)\
1x [Lidar YDX4 with USB adapter](https://www.robotshop.com/media/catalog/product/cache/image/1350x/9df78eab33525d08d6e5fb8d27136e95/y/d/ydlidar-x4-360-laser-scanner-2_3.jpg)
## Software
- Robotic Operating System (ROS) on Nvidia Jetson Nano Ubuntu OS
- Matlab on Window10 OS
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
$ git clone https://github.com/EAIBOT/ydlidar.git
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
$ cd -p ydlidar_ws/src/ydlidar/launch
$ roslaunch lidar.launch
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
# Hector SLAM
[Hector SLAM](http://wiki.ros.org/hector_slam) is a ROS packages that contain SLAM Algorithm to create the Occupancy Grid Map from sensor.

#### Install package
Create a directory catkin_make and clone the package into the source folder then compile using catkin make.
```
$ mkdir -p catkin_ws/src
$ cd -p caktin_ws/src
$ git clone https://github.com/tu-darmstadt-ros-pkg/hector_slam.git
$ cd ..
$ catkin_make
```
## Lidar Only
To do SLAM with Lidar only we have to modify some file:
- lidar.launch
- hector mapping_default.launch
- tutorial.launch
#### Navigate to lidar.launch
```
$ cd -p catkin_ws/src/ydlidar/launch
$ gedit lidar.launch
```
Comment out or remove the last tf launch file command static_transform_publisher then save
```
$ <!--node pkg="tf" type="static_transform_publisher" name="base_link_to_laser4" args="0.2245 0.0 0.2 0.0 0.0  0.0 /base_footprint /laser_frame 40" /-->
```
#### Navigate to hector mapping_default.launch
```
$ cd -p catkin_ws/src/hector_slam/hector_mapping/launch/
```
Change:
```
<arg name="base_frame" default="base_footprint"/>   to    <arg name="base_frame" default="base_frame"/>
<arg name="odom_frame" default="nav"/>              to    <arg name="odom_frame" default="base_frame"/>
```
Add the the new tf command the the last line
```
<node pkg="tf" type="static_transform_publisher" name="base_frame_to_laser_frame" args="0 0 0 0 0 0 base_frame laser_frame 100"/>
```
#### Navigate to tutorial.launch
```
$ cd -p hector_slam/hector_slam_launch/launch/
```
Change:
```
<param name="/use_sim_time" value="true"/>         to     <param name="/use_sim_time" value="false"/>   
```
### Launch the SLAM node
```
$ roslaunch tutorial.launch
```
