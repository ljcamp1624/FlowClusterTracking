%%  Import Images
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
function ImportImage(fileParams)
%%  Load Parameters
fileName = fileParams.fileName;
importFolder = fileParams.importFolder;
exportFolder = fileParams.exportFolder;

%%  Determine the number of frames
info = imfinfo([importFolder, fileName]);
numFrames = length(info);

%%  Preallocate image file
originalImages = imread([importFolder, fileName], 1);
originalImages = zeros([size(originalImages), numFrames]);

%%  Read images
for i = 1:numFrames
    originalImages(:, :, i) = imread([importFolder, fileName], i);
end

%%  Save images
if ~exist(exportFolder, 'dir')
    mkdir(exportFolder);
end
save([exportFolder, 'OriginalImages.mat'], 'originalImages', 'numFrames', '-v7.3');
end