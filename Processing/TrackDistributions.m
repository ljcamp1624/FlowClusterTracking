%%  Flow Distributions Function
%
%   Copyright (C) 2020 Leonard Campanello - All Rights Reserved
%   You may use, distribute, and modify this code under the terms of a
%   CC BY 4.0 License.
%
%   If you use, distribute, or modify this code, please cite
%   Lee*, Campanello*, et al. MBoC 2020
%   https://doi.org/10.1091/mbc.E19-11-0614
%
%   Written by Leonard Campanello
%   Available on https://github.com/ljcamp1624/OpticalFlowAnalysis
%
%   Direct all questions and correspondence to Leonard Campanello and
%   Wolfgang Losert at the University of Maryland:
%   ljcamp (at) umd (dot) edu
%   wlosert (at) umd (dot) edu
%
%%  Begin function
%
%   This function is called by FlowProcessingScript.m
%
function [instVelCounts, longInstVelCounts, smoothInstVelCounts, avgVelCounts, longAvgVelCounts, smoothAvgVelCounts] = TrackDistributions(exportFolder, listsFileName, distributionsFileName, o1, p1, q1, o2, p2, q2, velBinSize, velMax, fileParams, thetaBinSize)
%%  Process parameters
velBins = 0:velBinSize:velMax;
angBins = (0:thetaBinSize:360) - thetaBinSize/2;
velFac = 1/fileParams.pxPerUnit/fileParams.timeBtwFrames;
velUnit = [fileParams.pxUnit, '/', fileParams.timeUnit];

%%  Calculate velocity and angle distributions
[instVelList, instAngList, instVelCounts, instAngCounts] = CalculateVelocityCounts(velFac, velBins, thetaBinSize, angBins, o1);
[avgVelList, avgAngList, avgVelCounts, avgAngCounts] = CalculateVelocityCounts(velFac, velBins, thetaBinSize, angBins, o2);
[longInstVelList, longInstAngList, longInstVelCounts, longInstAngCounts] = CalculateVelocityCounts(velFac, velBins, thetaBinSize, angBins, p1);
[longAvgVelList, longAvgAngList, longAvgVelCounts, longAvgAngCounts] = CalculateVelocityCounts(velFac, velBins, thetaBinSize, angBins, p2);
[smoothInstVelList, smoothInstAngList, smoothInstVelCounts, smoothInstAngCounts] = CalculateVelocityCounts(velFac, velBins, thetaBinSize, angBins, q1);
[smoothAvgVelList, smoothAvgAngList, smoothAvgVelCounts, smoothAvgAngCounts] = CalculateVelocityCounts(velFac, velBins, thetaBinSize, angBins, q2);

%%  Save flow lists and distributions
save([exportFolder, listsFileName], 'velFac', 'velUnit', ...
    'instVelList', 'longInstVelList', 'smoothInstVelList', ...
    'avgVelList', 'longAvgVelList', 'smoothAvgVelList', ...
    'instAngList', 'longInstAngList', 'smoothInstAngList', ...
    'avgAngList', 'longAvgAngList', 'smoothAvgAngList');
save([exportFolder, distributionsFileName], 'velFac', 'velBins', 'velBinSize', 'velMax', 'velUnit', 'angBins', 'thetaBinSize', ...
    'instVelCounts', 'longInstVelCounts', 'smoothInstVelCounts', ...
    'avgVelCounts', 'longAvgVelCounts', 'smoothAvgVelCounts', ...
    'instAngCounts', 'longInstAngCounts', 'smoothInstAngCounts', ...
    'avgAngCounts', 'longAvgAngCounts', 'smoothAvgAngCounts');

end