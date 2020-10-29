%%  Calculate Difference Images
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
function CalculateDifferenceImages(fileParams, clusterParams, originalImages, smoothImages)
%% Process parameters
exportFolder = fileParams.exportFolder;
tSig = clusterParams.timeSig;

%%  Convert images
originalImages = double(originalImages);
smoothImages = double(smoothImages);

%%  Calculate t-gradient filter (along 3rd dimension of the image)
[iy, ix, it] = meshgrid(-3:3, -3:3, -3*tSig:3*tSig);
fx = exp(-ix.*ix/2)/sqrt(2*pi);
fy = exp(-iy.*iy/2)/sqrt(2*pi);
ft = exp(-it.*it/2/tSig/tSig)/sqrt(2*pi)/tSig;
gt = it.*fx.*fy.*ft/tSig/tSig;

%%  Calculate Difference Images
originalDiffImages = imfilter(originalImages, gt, 'replicate');
smoothDiffImages = imfilter(smoothImages, gt, 'replicate');

%%  Save
save([exportFolder, 'DifferenceImages.mat'], 'originalDiffImages', 'smoothDiffImages', 'tSig', '-v7.3');
end