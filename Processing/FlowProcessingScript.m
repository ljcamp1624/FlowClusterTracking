%%  Flow Processing Script
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
%   This function is called by ControlScript.m
%
function FlowProcessingScript(fileParams, processingParams)
%%  Start ParameterMoviesScript
fprintf('\n- - - Starting FlowProcessingScript - - -\n\n')

%% Process folders
exportFolder = fileParams.exportFolder;
flowExportFolder = [fileParams.exportFolder, 'FlowProcessingFolder', filesep];
if ~exist(flowExportFolder, 'dir')
    mkdir(flowExportFolder);
end

%%  Process file names
fileName1 = [flowExportFolder, 'FlowDistributionsData.mat'];
fileName2 = [flowExportFolder, 'PosFlowDistributionsData.mat'];
fileName3 = [flowExportFolder, 'NegFlowDistributionsData.mat'];

%%  Process parameters
relThresh = processingParams.relThresh;
peakImThresh = 3; % Hard coded.
thetaBinSize = processingParams.thetaBinSize;

%%  Load optical flow
if exist(fileName1, 'file') || exist(fileName2, 'file') || exist(fileName3, 'file')
    fprintf('- Optical Flow Distributions Data Located\n');
else
    fprintf('- Loading Optical Flow to Create Distributions Data\n');
    load([exportFolder, 'OpticalFlow.mat'], 'vxMat', 'vyMat', 'relMat');
    fprintf('  Loading Difference Images to Create Distributions Data\n');
    load([exportFolder, 'DifferenceImages.mat'], 'smoothDiffImages');
    fprintf('  Loading Cluster Images to Create Distributions Data\n');
    load([exportFolder, 'FlowClusterTracks.mat'], 'peakIm', 'peakImPos', 'peakImNeg', 'clusterIm', 'clusterImPos', 'clusterImNeg');
end

%%  Calculate optical flow distributions data

%   All data
if exist(fileName1, 'file')
    fprintf('- FlowDistributionsData Located\n');
else
    fprintf('- Creating Distributions Data\n');
    [angList, timeList, relList, peakList] = FlowDistributionsData(flowExportFolder, 'FlowDistributionsData', vxMat, vyMat, relMat, smoothDiffImages, peakIm, clusterIm);
end

%   Positive data
if exist(fileName2, 'file')
    fprintf('- PosFlowDistributionsData Located\n');
else
    fprintf('- Creating Positive Distributions Data\n');
    [posAngList, posTimeList, posRelList, posPeakList] = FlowDistributionsData(flowExportFolder, 'PosFlowDistributionsData', vxMat, vyMat, relMat, smoothDiffImages, peakImPos, clusterImPos);
end

%   Negative data
if exist(fileName3, 'file')
    fprintf('- NegFlowDistributionsData Located\n');
else
    fprintf('- Creating Negative Distributions Data\n');
    [negAngList, negTimeList, negRelList, negPeakList] = FlowDistributionsData(flowExportFolder, 'NegFlowDistributionsData', vxMat, vyMat, relMat, smoothDiffImages, peakImNeg, clusterImNeg);
end

%%  Fit optical flow distributions to model

%   Process file names
fileName4 = [flowExportFolder, 'FlowModels.mat'];
fileName5 = [flowExportFolder, 'PosFlowModels.mat'];
fileName6 = [flowExportFolder, 'NegFlowModels.mat'];

%   All data
if exist(fileName4, 'file')
    fprintf('- FlowModels Located\n');
else
    if ~exist('angList', 'var')
        fprintf('- Load FlowDistributionsData to Create Flow Models\n');
        load(fileName1, 'angList', 'timeList', 'relList', 'peakList');
    end
    fprintf('- Creating FlowModels\n');
    FitFlowDistributions(flowExportFolder, 'FlowModels', angList, timeList, relList, peakList, relThresh, peakImThresh);
end

%   Positive data
if exist(fileName5, 'file')
    fprintf('- PosFlowModels Located\n');
else
    if ~exist('posAngList', 'var')
        fprintf('- Load PosFlowDistributionsData to Create Positive Flow Models\n');
        posData = load(fileName2, 'angList', 'timeList', 'relList', 'peakList');
        posAngList = posData.angList;
        posTimeList = posData.timeList;
        posRelList = posData.relList;
        posPeakList = posData.peakList;
    end
    fprintf('- Creating Positive Flow Models\n');
    FitFlowDistributions(flowExportFolder, 'PosFlowModels', posAngList, posTimeList, posRelList, posPeakList, relThresh, peakImThresh);
end

%   Negative data
if exist(fileName6, 'file')
    fprintf('- NegFlowModels Located\n');
else
    if ~exist('negAngList', 'var')
        fprintf('- Load NegFlowDistributionsData to Create Positive Flow Models\n');
        negData = load(fileName3, 'angList', 'timeList', 'relList', 'peakList');
        negAngList = negData.angList;
        negTimeList = negData.timeList;
        negRelList = negData.relList;
        negPeakList = negData.peakList;
    end
    fprintf('- Creating Negative Flow Models\n');
    FitFlowDistributions(flowExportFolder, 'NegFlowModels', negAngList, negTimeList, negRelList, negPeakList, relThresh, peakImThresh);
end

%%  Calculate and plot optical flow distributions
FlowDistributions(flowExportFolder, 'FlowDistributionsData', 'FlowDistributionsCounts', relThresh, peakImThresh, thetaBinSize);
FlowDistributions(flowExportFolder, 'PosFlowDistributionsData', 'PosFlowDistributionsCounts', relThresh, peakImThresh, thetaBinSize);
FlowDistributions(flowExportFolder, 'NegFlowDistributionsData', 'NegFlowDistributionsCounts', relThresh, peakImThresh, thetaBinSize);

%%  Plot optical flow distributions

%%  

%%  End ParameterMoviesScript
fprintf('\n- - - FlowProcessingScript Complete! - - -\n\n')
end