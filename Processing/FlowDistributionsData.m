%%  Flow Distributions Data Function
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
function [angList, timeList, relList, peakList] = FlowDistributionsData(exportFolder, fileName, vxMat, vyMat, relMat, diffIm, peakIm, clusterIm)
%%  Calculate flow data
angMat = atan2(vyMat, vxMat);
magMat = sqrt(vxMat.*vxMat + vyMat.*vyMat);
[~, ~, timeMat] = meshgrid(1:size(angMat, 1), 1:size(angMat, 2), 1:size(angMat, 3));

%%  Flow data where magnitude is > 0
magMask = magMat > eps;
angList = angMat(magMask(:)) - pi/2;
magList = magMat(magMask(:));
timeList = timeMat(magMask(:));
relList = relMat(magMask(:));
diffList = diffIm(magMask(:));
peakList = peakIm(magMask(:));
clusterList = clusterIm(magMask(:));

%%  Save flow data
save([exportFolder, fileName], 'angList', 'magList', 'timeList', 'relList', 'diffList', 'peakList', 'clusterList');
end