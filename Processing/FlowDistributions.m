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
function [allAngCounts, relMaskAngCounts, peakMaskAngCounts, relAndPeakMaskAngCounts] = FlowDistributions(exportFolder, fileName, angList, timeList, relList, peakList, relThresh, peakImThresh, thetaBinSize)
%%  Calculate flow distributions

%   Modify angList for thetaBinSize
angListMod = mod(angList*180/pi + thetaBinSize/2, 360) - thetaBinSize/2;

%   Calculate masks
relMask = relList > relThresh;
peakMask = peakList > peakImThresh;

%   Calculate distribution counts
bins = (0:thetaBinSize:360) - thetaBinSize/2;
timeArray = unique(timeList);
allAngCounts = [];
relMaskAngCounts = [];
peakMaskAngCounts = [];
relAndPeakMaskAngCounts = [];
for tIdx = 1:length(timeArray)
    timeMask = timeList == timeArray(tIdx);
    allAngCounts = [allAngCounts; histcounts(angListMod(timeMask), bins)];
    relMaskAngCounts = [relMaskAngCounts; histcounts(angListMod(timeMask & relMask), bins)];
    peakMaskAngCounts = [peakMaskAngCounts; histcounts(angListMod(timeMask & peakMask), bins)];
    relAndPeakMaskAngCounts = [relAndPeakMaskAngCounts; histcounts(angListMod(timeMask & relMask & peakMask), bins)];
end

%%  Save flow distributions
save([exportFolder, fileName], 'allAngCounts', 'relMaskAngCounts', 'peakMaskAngCounts', 'relAndPeakMaskAngCounts', 'thetaBinSize');

end