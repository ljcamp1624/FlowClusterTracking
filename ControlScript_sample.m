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
%   The sample here uses representative fluorescence movies of actin in an
%   HL60 cell undergoing cytoskeletal rearrangements during migration.
%
%%  Begin script
clear all;
close all;
clc;

%%  Define parameters
%
%   Refer to README.txt for a full explanation of all parameters.


% --------- File Parameters --------- %

%   File names and folders
fileName = 'SyntheticGaussians.tif';
importFolder = 'C:\Users\Lenny\Documents\GitHub\FlowClusterTracking\Synthetic Gaussians\';
exportFolder = 'C:\Users\Lenny\Documents\GitHub\FlowClusterTracking\Synthetic Gaussians\Output\';

%   Image Parameters
pxUnit = 'Micron';
pxPerUnit = 1; % NOTE: this is the *number* of pixels in 1 'pxUnit'. E.g., if pxUnit is 'Micron' then pxPerUnit is the number of pixels in a single micron.
timeUnit = 'min';
timeBtwFrames = 1/30;


% --------- Analysis Parameters --------- %

%   Optical Flow
flowSpatialSig = 7;
flowTimeSig = 4;
windowSig = 7;

%   Clustering
smoothSpatialSig = 5;
smoothTimeSig = 2;
diffTimeSig = 5;

%   Tracking
clusterRad = 7;
relThresh = 1;
% peakImThresh = 3; % Hard coded. Can be changed in ClusterTrack.
peakSize = 7;
maxDisp = 7;


% --------- Processing Parameters --------- %

%   Postprocessing
thetaBinSize = 5;
minTrackLength = 5;
trackSmoothNumNNs = 1;


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
% analysisParams.clusterParams.peakImThresh = peakImThresh; % Hard coded.
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
% MainAnalysisScript(fileParams, analysisParams);

%%  Create Movies to Check Parameters
% MoviesScript(fileParams, processingParams);

%%  Process Optical Flow
FlowProcessingScript(fileParams, processingParams);

%%  Process Flow Cluster Tracks
% TrackProcessingScript(fileParams, processingParams);
