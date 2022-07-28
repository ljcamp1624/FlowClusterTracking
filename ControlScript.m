%%  Flow Tracking Control Script
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
%%  Introduction
%
%   The goal of this code is to measure the optical flow of concentration
%   fields on a pixel scale, and to use clustering and tracking to
%   quantify the flow on an intermediate mesoscale. This code utilizes
%   Lucas-Kanade Optical Flow and Crocker-Grier Particle Tracking.
%
%   The sample here uses dynamic synthetic gaussians.
%
%%  Begin script
clear all;
close all;
clc;

%%  Define parameters
%
%   Refer to README.txt for a full explanation of all parameters.


% --------- Control Script Parameters --------- %

run(1) = 1;     % MainAnalysisScript:       1 = run
run(2) = 1;     % MoviesScript              1 = run
run(3) = 2;     % FlowProcessingScript      1 = run, 2 = run with plotting
run(4) = 2;     % TrackProcessingScript     1 = run, 2 = run with plotting


% --------- File Parameters --------- %

%   File names and folders
fileName = '.tif';
importFolder = '';
exportFolder = '';

%   Image Parameters
pxUnit = '';
pxPerUnit = ; % NOTE: this is the *number* of pixels in 1 'pxUnit'. E.g., if pxUnit is 'Micron' then pxPerUnit is the number of pixels in a single micron.
timeUnit = '';
timeBtwFrames = ;


% --------- Analysis Parameters --------- %

%   Optical Flow
flowSpatialSig = ;
flowTimeSig = ;
windowSig = ;

%   Clustering
smoothSpatialSig = ;
smoothTimeSig = ;
diffTimeSig = ;

%   Tracking
clusterRad = ;
relThresh = ;
peakSig = ;
peakThresh = ;
peakSize = ;
maxDisp = ;


% --------- Processing Parameters --------- %

%   Postprocessing
thetaBinSize = ;
minTrackLength = ;
trackSmoothNumNNs = ;


%%  Set parameters

%   Set File Parameters
fileParams.fileName = fileName;
fileParams.importFolder = importFolder;
fileParams.exportFolder = exportFolder;
fileParams.pxUnit = pxUnit;
fileParams.pxPerUnit = pxPerUnit;
fileParams.timeUnit = timeUnit;
fileParams.timeBtwFrames = timeBtwFrames;

%   Set Adjustable Analysis Parameters
analysisParams.flowParams.spatialSig = flowSpatialSig;
analysisParams.flowParams.timeSig = flowTimeSig;
analysisParams.flowParams.windowSig = windowSig;
analysisParams.smoothParams.spatialSig = smoothSpatialSig;
analysisParams.smoothParams.timeSig = smoothTimeSig;
analysisParams.clusterParams.timeSig = diffTimeSig;
analysisParams.clusterParams.clusterRad = clusterRad;
analysisParams.clusterParams.peakThresh = peakThresh;
analysisParams.clusterParams.relThresh = relThresh;
analysisParams.clusterParams.peakSize = peakSize;
analysisParams.clusterParams.maxDisp = maxDisp;
analysisParams.proccesingParams.minTrackLength = minTrackLength;
analysisParams.proccesingParams.trackSmoothNumNNs = trackSmoothNumNNs;

%   Set Processing Parameters
processingParams.thetaBinSize = thetaBinSize;
processingParams.relThresh = relThresh;
% processingParams.clusterParams.peakImThresh = peakImThresh; % Hard coded.
processingParams.minTrackLength = minTrackLength;
processingParams.trackSmoothNumNNs = trackSmoothNumNNs;

%%  Run Main Analysis Script
if run(1) == 1
    MainAnalysisScript(fileParams, analysisParams);
end

%%  Create Movies to Check Parameters
if run(2) == 1
    MoviesScript(fileParams, processingParams);
end

%%  Process Optical Flow
if run(3) == 1
    FlowProcessingScript(fileParams, processingParams, 0);
elseif run(3) == 2
    FlowProcessingScript(fileParams, processingParams, 1);
end

%%  Process Flow Cluster Tracks
if run(4) == 1
    TrackProcessingScript(fileParams, processingParams, 0);
elseif run(4) == 2
    TrackProcessingScript(fileParams, processingParams, 1);
end
