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
function FlowDistributions(folder, importFileName, exportFileName, relThresh, peakImThresh, thetaBinSize)
%%  Load flow data
load([folder, importFileName], 'angList', 'relList', 'peakList');

%%  Calculate flow distributions

%   Modify angList for thetaBinSize
angListMod = mod(angList*180/pi + thetaBinSize/2, 360) - thetaBinSize/2;

%   Calculate full histogram
allAngCounts = histcounts(angListMod, (0:thetaBinSize:360) - thetaBinSize/2);

%   Calculate masks
relMask = relList > relThresh;
peakMask = peakList > peakImThresh;

%   Calculate masked histograms
relMaskAngCounts = histcounts(angListMod(relMask), (0:thetaBinSize:360) - thetaBinSize/2);
peakMaskAngCounts = histcounts(angListMod(peakMask), (0:thetaBinSize:360) - thetaBinSize/2);
relAndPeakMaskAngCounts = histcounts(angListMod(relMask & peakMask), (0:thetaBinSize:360) - thetaBinSize/2);

%%  Save flow distributions
save([folder, exportFileName], 'allAngCounts', 'relMaskAngCounts', 'peakMaskAngCounts', 'relAndPeakMaskAngCounts');

end