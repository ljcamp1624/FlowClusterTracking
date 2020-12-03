%%  Calculate Optical Flow
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
%   This function is called by Mainscript.m
%
function CalculateOpticalFlow(fileParams, flowParams, images)
%% Process parameters
exportFolder = fileParams.exportFolder;
xySig = flowParams.spatialSig;
tSig = flowParams.timeSig;
wSig = flowParams.windowSig;

%%  Choose Optical Flow Calculation Method
OFmethod = 'LK-all'; % 'LK-all' = Lucas-Kanade all frames

%%  Calculate Optical Flow
if strcmp(OFmethod, 'LK-all')
    %%  Lucas-Kanade Method, all frames at once
    % 
    %   *IMPORTANT NOTE*:
    %   This version calculates all frames at once. It's faster, but might
    %   cause RAM issues. For example, one option would be to review how the
    %   size of "gt" in "LKxOptFlow_allFrames" is determined and break your
    %   image series into separate chunks. Contact Leonard Campanello at
    %   ljcamp (at) umd (dot) edu if you need assistance with a workaround.
    [vxMat, vyMat, relMat] = LKxOptFlow_allFrames(images, xySig, tSig, wSig);

    %  Save
    save([exportFolder, 'OpticalFlow.mat'], 'xySig', 'tSig', 'wSig', 'vxMat', 'vyMat', 'relMat', '-v7.3');

elseif strcmp(OFmethod, 'LK')
    %%  Lucas-Kanade Method
    % 
    %   Baseline code is included in LKxOptFlow.m
    error('Unfinished code for LK optical flow calculation.');
    
end
end