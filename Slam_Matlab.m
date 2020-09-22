rosshutdown
clear
close all
clc
%%
rosinit('192.168.6.240');
laser = rossubscriber('/scan');
maxLidarRange = 8;
mapResolution = 20;
slamAlg = lidarSLAM(mapResolution, maxLidarRange);
slamAlg.LoopClosureThreshold = 210;
slamAlg.LoopClosureSearchRadius = 8;
for i = 1:100
    laserdata = receive(laser,1);
    Angles = double((laserdata.AngleMin:laserdata.AngleIncrement:laserdata.AngleMax-laserdata.AngleIncrement)');
    Ranges = double(laserdata.Ranges);
    lidarScanNew=lidarScan(Ranges,Angles);
    [isScanAccepted, loopClosureInfo, optimizationInfo] = addScan(slamAlg, lidarScanNew);
    if isScanAccepted
        fprintf('Added scan %d \n', i);
    end

%%
%     figure(1)
%     show(slamAlg);
%     title({'Map of the Environment','Pose Graph for 10 Scans'});
    %% occupancy grid map built
    [scans, optimizedPoses]  = scansAndPoses(slamAlg);
    map = buildMap(scans, optimizedPoses, mapResolution, maxLidarRange);
    figure(2); 
    show(map);
%     hold on
%     show(slamAlg.PoseGraph, 'IDs', 'off');
    hold off
    title('Occupancy Grid Map Built Using Lidar SLAM');
    axis([-8 8 -8 8])
end