%%  Track Optical-Flow Clusters
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
function TrackFlowClusters(fileParams, clusterParams, vxMat, vyMat, relMat, smoothDiffImage)
%%  Process parameters
exportFolder = fileParams.exportFolder;
relThresh = clusterParams.relThresh;
clusterRad = clusterParams.clusterRad;
peakSize = clusterParams.peakSize;
maxDisp = clusterParams.maxDisp;

%%  Create cluster image

%   Set up flow images
magMat = sqrt(vxMat.^2 + vyMat.^2);
vxMat = vxMat./(magMat + eps);
vyMat = vyMat./(magMat + eps);

%   Calculate flow alignment
gaussFilter = fspecial('gaussian', 2*ceil(3*clusterRad) + 1, clusterRad);
gaussFilter((size(gaussFilter, 1) + 1)/2, (size(gaussFilter, 2) + 1)/2) = 0;
gaussFilter = gaussFilter/sum(gaussFilter(:));
flowAlignment = vxMat.*imfilter(vxMat, gaussFilter, 'replicate') + vyMat.*imfilter(vyMat, gaussFilter, 'replicate');

%   Calculate cluster images
relMask = relMat > relThresh;
magMask = magMat > eps;
posMask = smoothDiffImage > 0;
negMask = smoothDiffImage < 0;
clusterIm    = relMat.*flowAlignment; 
clusterImMask = relMask & magMask;
clusterImPosMask = relMask & magMask & posMask;
clusterImNegMask = relMask & magMask & negMask;

%%  Find and track peaks in cluster image
peakIm = CreatePeakImage(clusterIm);
[xyt, xyt2, tracks] = ClusterTrack(peakIm, clusterIm, clusterImMask, peakSize, maxDisp);
[xytPos, xytPos2, tracksPos] = ClusterTrack(peakIm, clusterIm, clusterImPosMask, peakSize, maxDisp);
[xytNeg, xytNeg2, tracksNeg] = ClusterTrack(peakIm, clusterIm, clusterImNegMask, peakSize, maxDisp);

%% Save results
save([exportFolder, 'FlowClusterTracks.mat'], 'peakIm', 'clusterIm', 'relMask', 'magMask', 'posMask', 'negMask', 'xyt', 'xyt2', 'xytPos', 'xytPos2', 'xytNeg', 'xytNeg2', 'tracks', 'tracksPos', 'tracksNeg', 'flowAlignment', 'peakSize', 'maxDisp', 'relThresh');
end