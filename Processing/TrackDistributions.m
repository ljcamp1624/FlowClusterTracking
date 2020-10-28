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
function [instVelCounts, longInstVelCounts, smoothInstVelCounts, avgVelCounts, longAvgVelCounts, smoothAvgVelCounts] = TrackDistributions(exportFolder, fileName, o1, p1, q1, o2, p2, q2, velBinSize, velMax, fileParams, thetaBinSize)
%%  Process parameters
velBins = 0:velBinSize:velMax;
angBins = (0:thetaBinSize:360) - thetaBinSize/2;
velFac = 1/fileParams.pxPerUnit/fileParams.timeBtwFrames;
velUnit = [fileParams.pxUnit, '/', fileParams.timeUnit];

%%  Calculate velocity distributions

instVelList = [velFac*sqrt(o1(:, 1).^2 + o1(:, 2).^2)./o1(:, 3), o1(:, 5:6)];
longInstVelList = [velFac*sqrt(p1(:, 1).^2 + p1(:, 2).^2)./p1(:, 3), p1(:, 5:6)];
smoothInstVelList = [velFac*sqrt(q1(:, 1).^2 + q1(:, 2).^2)./q1(:, 3), q1(:, 5:6)];
avgVelList = [velFac*sqrt(o2(:, 1).^2 + o2(:, 2).^2)./o2(:, 3), o2(:, 5:6)];
longAvgVelList = [velFac*sqrt(p2(:, 1).^2 + p2(:, 2).^2)./p2(:, 3), p2(:, 5:6)];
smoothAvgVelList = [velFac*sqrt(q2(:, 1).^2 + q2(:, 2).^2)./q2(:, 3), q2(:, 5:6)];

%   Calculate distribution counts
timeArray = unique([o1(:, 5); p1(:, 5); q1(:, 5); o2(:, 5); p2(:, 5); q2(:, 5)]);
instVelCounts = [];
longInstVelCounts = [];
smoothInstVelCounts = [];
avgVelCounts = [];
longAvgVelCounts = [];
smoothAvgVelCounts = [];
for tIdx = 1:length(timeArray)
    currTime = timeArray(tIdx);
    instVelCounts =         [instVelCounts;         histcounts(instVelList(instVelList(:, 2) == currTime, 1), velBins)];
    longInstVelCounts =     [longInstVelCounts;     histcounts(longInstVelList(longInstVelList(:, 2) == currTime, 1), velBins)];
    smoothInstVelCounts =   [smoothInstVelCounts;   histcounts(smoothInstVelList(smoothInstVelList(:, 2) == currTime, 1), velBins)];
    avgVelCounts =          [avgVelCounts;          histcounts(avgVelList(avgVelList(:, 2) == currTime, 1), velBins)];
    longAvgVelCounts =      [longAvgVelCounts;      histcounts(longAvgVelList(longAvgVelList(:, 2) == currTime, 1), velBins)];
    smoothAvgVelCounts =    [smoothAvgVelCounts;    histcounts(smoothAvgVelList(smoothAvgVelList(:, 2) == currTime, 1), velBins)];
end

%%  Calculate angle distributions

instAngList =       [mod(o1(:, 4)*180/pi + thetaBinSize/2, 360) - thetaBinSize/2, o1(:, 5:6)];
longInstAngList =   [mod(p1(:, 4)*180/pi + thetaBinSize/2, 360) - thetaBinSize/2, p1(:, 5:6)];
smoothInstAngList = [mod(q1(:, 4)*180/pi + thetaBinSize/2, 360) - thetaBinSize/2, q1(:, 5:6)];
avgAngList =        [mod(o2(:, 4)*180/pi + thetaBinSize/2, 360) - thetaBinSize/2, o2(:, 5:6)];
longAvgAngList =    [mod(p2(:, 4)*180/pi + thetaBinSize/2, 360) - thetaBinSize/2, p2(:, 5:6)];
smoothAvgAngList =  [mod(q2(:, 4)*180/pi + thetaBinSize/2, 360) - thetaBinSize/2, q2(:, 5:6)];

%   Calculate distribution counts
instAngCounts = [];
longInstAngCounts = [];
smoothInstAngCounts = [];
avgAngCounts = [];
longAvgAngCounts = [];
smoothAvgAngCounts = [];
for tIdx = 1:length(timeArray)
    currTime = timeArray(tIdx);
    instAngCounts =         [instAngCounts;         histcounts(instAngList(instAngList(:, 2) == currTime, 1), angBins)];
    longInstAngCounts =     [longInstAngCounts;     histcounts(longInstAngList(longInstAngList(:, 2) == currTime, 1), angBins)];
    smoothInstAngCounts =   [smoothInstAngCounts;   histcounts(smoothInstAngList(smoothInstAngList(:, 2) == currTime, 1), angBins)];
    avgAngCounts =          [avgAngCounts;          histcounts(avgAngList(avgAngList(:, 2) == currTime, 1), angBins)];
    longAvgAngCounts =      [longAvgAngCounts;      histcounts(longAvgAngList(longAvgAngList(:, 2) == currTime, 1), angBins)];
    smoothAvgAngCounts =    [smoothAvgAngCounts;    histcounts(smoothAvgAngList(smoothAvgAngList(:, 2) == currTime, 1), angBins)];
end

%%  Save flow distributions
save([exportFolder, fileName], 'velBins', 'velBinSize', 'velMax', 'velUnit', 'angBins', 'thetaBinSize', ...
    'instVelCounts', 'longInstVelCounts', 'smoothInstVelCounts', ...
    'avgVelCounts', 'longAvgVelCounts', 'smoothAvgVelCounts', ...
    'instAngCounts', 'longInstAngCounts', 'smoothInstAngCounts', ...
    'avgAngCounts', 'longAvgAngCounts', 'smoothAvgAngCounts');
end