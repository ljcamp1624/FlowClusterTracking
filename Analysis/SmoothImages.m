%%  Smooth Images
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
function SmoothImages(fileParams, smoothParams, originalImages)
%%  Load Parameters
exportFolder = fileParams.exportFolder;
xySig = smoothParams.spatialSig;
tSig = smoothParams.timeSig;

%%  Smooth Images
if tSig == 0
    smoothSig = [xySig, xySig, 0];
    smoothImages = imgaussfilt(originalImages, [xySig, xySig], 'padding', 'replicate');
else
    smoothSig = [xySig, xySig, tSig];
    smoothImages = imgaussfilt3(originalImages, smoothSig, 'padding', 'replicate');
end

%%  Save
try
    save([exportFolder, 'SmoothImages.mat'], 'smoothImages', 'smoothSig');
catch
    save([exportFolder, 'SmoothImages.mat'], 'smoothImages', 'smoothSig', '-v7.3');
end