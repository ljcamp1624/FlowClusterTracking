%%  Track Clusters
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
%   This function is called by TrackFlowClusters.m
%
function [peakIm, xyt, xyt2, tracks] = ClusterTrack(clusterIm, mask, peakSize, maxDisp)
%%  Build image with artificial peaks
[grad, jac] = CalculateDerivatives(clusterIm, 1);
peakIm = clusterIm.*jac./grad;
m = mean(peakIm(:));
s = std(peakIm(:));
z = (peakIm - m)/s;

%% Calculate the initial xyt matrix using pkfnd
peakImThresh = 3; % Hard coded. Pass as input if you want to modify in ControlScript.m
xyt = [];
for i = 1:size(clusterIm, 3)
    pks = pkfnd(z(:, :, i), peakImThresh, peakSize);
    xyt = [xyt; [pks, i + zeros(size(pks))]];
end

%% Remove points outside of mask
if isempty(xyt)
    xyt2 = [];
    tracks = [];
    return;
end
idx = sub2ind(size(mask), xyt(:, 2), xyt(:, 1), xyt(:, 3));
xyt(~mask(idx), :) = [];

%% Recalculate the xyt points using cntrd
xyt2 = [];
for i = 1:size(clusterIm, 3)
    pks2 = cntrd(clusterIm(:, :, i), xyt(xyt(:, 3) == i, :), floor(peakSize/2));
    if ~isempty(pks2)
        pks2 = pks2(:, [1, 2]);
    end
    xyt2 = [xyt2; [pks2, zeros(size(pks2, 1), 1) + i]];
end
if size(xyt2, 1) >= 2
    tracks = track(xyt2, maxDisp);
else
    tracks = zeros(0, 4);
end
end