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
fileName = 'SampleMCF10A_ROI.tif';
importFolder = 'C:\Users\Lenny\Documents\GitHub\FlowClusterTracking\HEK\';
exportFolder = 'C:\Users\Lenny\Documents\GitHub\FlowClusterTracking\HEK\Output\';

%   Image Parameters
pxUnit = 'Micron';
pxPerUnit = 1; % NOTE: this is the *number* of pixels in 1 'pxUnit'. E.g., if pxUnit is 'Micron' then pxPerUnit is the number of pixels in a single micron.
timeUnit = 'min';
timeBtwFrames = 1/30;


% --------- Analysis Parameters --------- %

%   Optical Flow
flowSpatialSig = 3;
flowTimeSig = 2;
windowSig = 3;

%   Clustering
smoothSpatialSig = 9;
smoothTimeSig = 4;
diffTimeSig = 5;

%   Tracking
clusterRad = 7;
relThresh = 1000;
peakSig = 8;
peakThresh = 3;
peakSize = 10;
maxDisp = 10;


% --------- Processing Parameters --------- %

%   Postprocessing
thetaBinSizeFlow = 5;       % degrees
minTrackLength = 5;         % frames
trackSmoothNumNNs = 1;      % frames
velBinSize = .05;            % (pxUnit/timeUnit)
velMax = 20;               % (pxUnit/timeUnit)
thetaBinSizeTracks = 15;    % degrees

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
analysisParams.clusterParams.peakSig = peakSig;
analysisParams.clusterParams.peakThresh = peakThresh;
analysisParams.clusterParams.relThresh = relThresh;
analysisParams.clusterParams.peakSize = peakSize;
analysisParams.clusterParams.maxDisp = maxDisp;
analysisParams.proccesingParams.minTrackLength = minTrackLength;
analysisParams.proccesingParams.trackSmoothNumNNs = trackSmoothNumNNs;

%   Set Processing Parameters
processingParams.thetaBinSizeFlow = thetaBinSizeFlow;
processingParams.relThresh = relThresh;
processingParams.peakThresh = peakThresh;
processingParams.minTrackLength = minTrackLength;
processingParams.trackSmoothNumNNs = trackSmoothNumNNs;
processingParams.velBinSize = velBinSize;
processingParams.velMax = velMax;
processingParams.thetaBinSizeTracks = thetaBinSizeTracks;

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
