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
fileName1 = 'FlowDistributionsData.mat';
fileName2 = 'PosFlowDistributionsData.mat';
fileName3 = 'NegFlowDistributionsData.mat';

%%  Process parameters
relThresh = processingParams.relThresh;
peakImThresh = 3; % Hard coded.
thetaBinSize = processingParams.thetaBinSize;

%%  Load optical flow
if exist([flowExportFolder, fileName1], 'file') || exist([flowExportFolder, fileName2], 'file') || exist([flowExportFolder, fileName3], 'file')
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
if exist([flowExportFolder, fileName1], 'file')
    fprintf('- FlowDistributionsData Located\n');
else
    fprintf('- Creating Distributions Data\n');
    [angList, timeList, relList, peakList] = FlowDistributionsData(flowExportFolder, fileName1(1:(end - 4)), vxMat, vyMat, relMat, smoothDiffImages, peakIm, clusterIm);
end

%   Positive data
if exist([flowExportFolder, fileName2], 'file')
    fprintf('- PosFlowDistributionsData Located\n');
else
    fprintf('- Creating Positive Distributions Data\n');
    [posAngList, posTimeList, posRelList, posPeakList] = FlowDistributionsData(flowExportFolder, fileName2(1:(end - 4)), vxMat, vyMat, relMat, smoothDiffImages, peakImPos, clusterImPos);
end

%   Negative data
if exist([flowExportFolder, fileName3], 'file')
    fprintf('- NegFlowDistributionsData Located\n');
else
    fprintf('- Creating Negative Distributions Data\n');
    [negAngList, negTimeList, negRelList, negPeakList] = FlowDistributionsData(flowExportFolder, fileName3(1:(end - 4)), vxMat, vyMat, relMat, smoothDiffImages, peakImNeg, clusterImNeg);
end

%%  Calculate optical flow distributions

%   Process file names
fileName4 = 'FlowDistributions.mat';
fileName5 = 'PosFlowDistributions.mat';
fileName6 = 'NegFlowDistributions.mat';

%   All data
if exist([flowExportFolder, fileName4], 'file')
    fprintf('- FlowDistributions Located\n');
    oldThetaBinSize = load([flowExportFolder, fileName4], 'thetaBinSize');
    oldThetaBinSize = oldThetaBinSize.thetaBinSize;
else
    oldThetaBinSize = 360;
end
if oldThetaBinSize ~= thetaBinSize
    if ~exist('angList', 'var')
        fprintf('- Loading FlowDistributionsData to Create Flow Distributions\n');
        load([flowExportFolder, fileName1], 'angList', 'timeList', 'relList', 'peakList');
    end
    fprintf('- Creating FlowDistributionsData with current parameters\n');
    [allAllAngCounts, allRelMaskAngCounts, allPeakMaskAngCounts, allRelAndPeakMaskAngCounts] = FlowDistributions(flowExportFolder, fileName4(1:(end - 4)), angList, timeList, relList, peakList, relThresh, peakImThresh, thetaBinSize);
end

%   Positive data
if exist([flowExportFolder, fileName5], 'file')
    fprintf('- PosFlowDistributions Located\n');
    oldThetaBinSize = load([flowExportFolder, fileName5], 'thetaBinSize');
    oldThetaBinSize = oldThetaBinSize.thetaBinSize;
else
    oldThetaBinSize = 360;
end
if oldThetaBinSize ~= thetaBinSize
    if ~exist('posAngList', 'var')
        fprintf('- Loading PosFlowDistributionsData to Create Positive Flow Distributions\n');
        posData = load([flowExportFolder, fileName2], 'angList', 'timeList', 'relList', 'peakList');
        posAngList = posData.angList;
        posTimeList = posData.timeList;
        posRelList = posData.relList;
        posPeakList = posData.peakList;
    end
    fprintf('- Creating PosFlowDistributionsData with current parameters\n');
    [posAllAngCounts, posRelMaskAngCounts, posPeakMaskAngCounts, posRelAndPeakMaskAngCounts] = FlowDistributions(flowExportFolder, fileName5(1:(end - 4)), posAngList, posTimeList, posRelList, posPeakList, relThresh, peakImThresh, thetaBinSize);
end

%   Negative data
if exist([flowExportFolder, fileName6], 'file')
    fprintf('- NegFlowDistributions Located\n');
    oldThetaBinSize = load([flowExportFolder, fileName6], 'thetaBinSize');
    oldThetaBinSize = oldThetaBinSize.thetaBinSize;
else
    oldThetaBinSize = 360;
end
if oldThetaBinSize ~= thetaBinSize
    if ~exist('negAngList', 'var')
        fprintf('- Loading NegFlowDistributionsData to Create Positive Flow Distributions\n');
        negData = load([flowExportFolder, fileName3], 'angList', 'timeList', 'relList', 'peakList');
        negAngList = negData.angList;
        negTimeList = negData.timeList;
        negRelList = negData.relList;
        negPeakList = negData.peakList;
    end
    fprintf('- Creating NegFlowDistributionsData with current parameters\n');
    [negAllAngCounts, negRelMaskAngCounts, negPeakMaskAngCounts, negRelAndPeakMaskAngCounts] = FlowDistributions(flowExportFolder, fileName6(1:(end - 4)), negAngList, negTimeList, negRelList, negPeakList, relThresh, peakImThresh, thetaBinSize);
end

%%  Fit optical flow distributions to model

%   Process file names
fileName7 = 'FlowModels.mat';
fileName8 = 'PosFlowModels.mat';
fileName9 = 'NegFlowModels.mat';

%   All data
if exist([flowExportFolder, fileName7], 'file')
    fprintf('- FlowModels Located\n');
else
    if ~exist('angList', 'var')
        fprintf('- Loading FlowDistributionsData to Create Flow Models\n');
        load([flowExportFolder, fileName1], 'angList', 'timeList', 'relList', 'peakList');
    end
    fprintf('- Creating FlowModels\n');
    [allBasicModel, allMixedModel] = FitFlowDistributions(flowExportFolder, fileName7(1:(end - 4)), angList, timeList, relList, peakList, relThresh, peakImThresh);
end

%   Positive data
if exist([flowExportFolder, fileName8], 'file')
    fprintf('- PosFlowModels Located\n');
else
    if ~exist('posAngList', 'var')
        fprintf('- Loading PosFlowDistributionsData to Create Positive Flow Models\n');
        posData = load([flowExportFolder, fileName2], 'angList', 'timeList', 'relList', 'peakList');
        posAngList = posData.angList;
        posTimeList = posData.timeList;
        posRelList = posData.relList;
        posPeakList = posData.peakList;
    end
    fprintf('- Creating Positive Flow Models\n');
    [posBasicModel, posMixedModel] = FitFlowDistributions(flowExportFolder, fileName8(1:(end - 4)), posAngList, posTimeList, posRelList, posPeakList, relThresh, peakImThresh);
end

%   Negative data
if exist([flowExportFolder, fileName9], 'file')
    fprintf('- NegFlowModels Located\n');
else
    if ~exist('negAngList', 'var')
        fprintf('- Loading NegFlowDistributionsData to Create Negative Flow Models\n');
        negData = load([flowExportFolder, fileName3], 'angList', 'timeList', 'relList', 'peakList');
        negAngList = negData.angList;
        negTimeList = negData.timeList;
        negRelList = negData.relList;
        negPeakList = negData.peakList;
    end
    fprintf('- Creating Negative Flow Models\n');
    [negBasicModel, negMixedModel] = FitFlowDistributions(flowExportFolder, fileName9(1:(end - 4)), negAngList, negTimeList, negRelList, negPeakList, relThresh, peakImThresh);
end

%%  Plot flow distributions

if ~exist('allAllAngCounts', 'var')
    fprintf('- Loading FlowDistributions to Create Plots\n');
    allCountData = load([flowExportFolder, fileName4], 'allAngCounts', 'relMaskAngCounts', 'peakMaskAngCounts', 'relAndPeakMaskAngCounts');
    allAllAngCounts = allCountData.allAngCounts;
    allRelMaskAngCounts = allCountData.relMaskAngCounts;
    allPeakMaskAngCounts = allCountData.peakMaskAngCounts;
    allRelAndPeakMaskAngCounts = allCountData.relAndPeakMaskAngCounts;
end
if ~exist('allBasicModel', 'var')
    fprintf('- Loading FlowModels to Create Plots\n');
    allData = load([flowExportFolder, fileName7], 'basicModel', 'mixedModel');
    allBasicModel = allData.basicModel;
    allMixedModel = allData.mixedModel;
end
PlotFlowDistributions(flowExportFolder, fileName4(1:(end - 4)), allAllAngCounts, allRelMaskAngCounts, allPeakMaskAngCounts, thetaBinSize, allBasicModel, allMixedModel);

if ~exist('posAllAngCounts', 'var')
    fprintf('- Loading PosFlowDistributions to Create Plots\n');
    posCountData = load([flowExportFolder, fileName5], 'allAngCounts', 'relMaskAngCounts', 'peakMaskAngCounts', 'relAndPeakMaskAngCounts');
    posAllAngCounts = posCountData.allAngCounts;
    posRelMaskAngCounts = posCountData.relMaskAngCounts;
    posPeakMaskAngCounts = posCountData.peakMaskAngCounts;
    posRelAndPeakMaskAngCounts = posCountData.relAndPeakMaskAngCounts;
end
if ~exist('posBasicModel', 'var')
    fprintf('- Loading PosFlowModels to Create Plots\n');
    posData = load([flowExportFolder, fileName8], 'basicModel', 'mixedModel');
    posBasicModel = posData.basicModel;
    posMixedModel = posData.mixedModel;
end
PlotFlowDistributions(flowExportFolder, fileName5(1:(end - 4)), posAllAngCounts, posRelMaskAngCounts, posPeakMaskAngCounts, thetaBinSize, posBasicModel, posMixedModel);

if ~exist('negAllAngCounts', 'var')
    fprintf('- Loading NegFlowDistributions to Create Plots\n');
    negCountData = load([flowExportFolder, fileName6], 'allAngCounts', 'relMaskAngCounts', 'peakMaskAngCounts', 'relAndPeakMaskAngCounts');
    negAllAngCounts = negCountData.allAngCounts;
    negRelMaskAngCounts = negCountData.relMaskAngCounts;
    negPeakMaskAngCounts = negCountData.peakMaskAngCounts;
    negRelAndPeakMaskAngCounts = negCountData.relAndPeakMaskAngCounts;
end
if ~exist('negBasicModel', 'var')
    fprintf('- Loading NegFlowModels to Create Plots\n');
    negData = load([flowExportFolder, fileName9], 'basicModel', 'mixedModel');
    negBasicModel = negData.basicModel;
    negMixedModel = negData.mixedModel;
end
PlotFlowDistributions(flowExportFolder, fileName6(1:(end - 4)), negAllAngCounts, negRelMaskAngCounts, negPeakMaskAngCounts, thetaBinSize, negBasicModel, negMixedModel);


%%  End ParameterMoviesScript
fprintf('\n- - - FlowProcessingScript Complete! - - -\n\n')
end