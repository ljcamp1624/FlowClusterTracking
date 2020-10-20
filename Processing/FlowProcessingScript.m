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
function FlowProcessingScript(fileParams, processingParams, plotResults)
%%  Start ParameterMoviesScript
fprintf('\n- - - Starting FlowProcessingScript - - -\n\n')

%% Process folders
exportFolder = fileParams.exportFolder;
flowExportFolder = [fileParams.exportFolder, 'FlowProcessingFolder', filesep];
if ~exist(flowExportFolder, 'dir')
    mkdir(flowExportFolder);
end

%%  Process file names
dataFileNames = {...,
    'FlowDistributionsData.mat', ...
    'PosFlowDistributionsData.mat', ...
    'NegFlowDistributionsData.mat'};

distributionsFileNames = {...,
    'FlowDistributions.mat', ...
    'PosFlowDistributions.mat', ...
    'NegFlowDistributions.mat'};

modelsFileNames = {...,
    'FlowModels.mat', ...
    'PosFlowModels.mat', ...
    'NegFlowModels.mat'};

%%  Process parameters
relThresh = processingParams.relThresh;
peakImThresh = 3; % Hard coded.
thetaBinSize = processingParams.thetaBinSize;

%%  Load optical flow
if exist([flowExportFolder, dataFileNames{1}], 'file') && exist([flowExportFolder, dataFileNames{2}], 'file') && exist([flowExportFolder, dataFileNames{3}], 'file')
    fprintf('- Optical Flow Distributions Data Located\n');
    allocateData = 0;
else
    fprintf('- Loading Optical Flow to Create Distributions Data\n');
    load([exportFolder, 'OpticalFlow.mat'], 'vxMat', 'vyMat', 'relMat');
    fprintf('  Loading Difference Images to Create Distributions Data\n');
    load([exportFolder, 'DifferenceImages.mat'], 'smoothDiffImages');
    fprintf('  Loading Cluster Images to Create Distributions Data\n');
    load([exportFolder, 'FlowClusterTracks.mat'], 'peakIm', 'peakImPos', 'peakImNeg', 'clusterIm', 'clusterImPos', 'clusterImNeg');
    allocateData = 1;
end

%%  Run script
for runIdx = 1:3
    %%  Messages
    if runIdx == 1
        fprintf('\n- All Optical Flow\n');
    elseif runIdx == 2
        fprintf('\n- Positive Optical Flow\n');
    elseif runIdx == 3
        fprintf('\n- Negative Optical Flow\n');
    end
    
    %%  Select data
    if allocateData == 1
        if runIdx == 1
            currPeakIm = peakIm;
            currClusterIm = clusterIm;
        elseif runIdx == 2
            currPeakIm = peakImPos;
            currClusterIm = clusterImPos;
        elseif runIdx == 3
            currPeakIm = peakImNeg;
            currClusterIm = clusterImNeg;
        end
    end
    
    %%  Run parameters
    
    %  Accumulate distribution data
    if exist([flowExportFolder, dataFileNames{runIdx}], 'file')
        fprintf('  FlowDistributionsData Located\n');
        createDistributionData = 0;
    else
        createDistributionData = 1;
    end
    
    %  Calculate flow distributions
    if exist([flowExportFolder, distributionsFileNames{runIdx}], 'file')
        fprintf('  FlowDistributions Located\n');
        oldThetaBinSize = load([flowExportFolder, distributionsFileNames{1}], 'thetaBinSize');
        oldThetaBinSize = oldThetaBinSize.thetaBinSize;
        if oldThetaBinSize ~= thetaBinSize
            createFlowDistributions = 1;
        else
            createFlowDistributions = 0;
        end
    else
        createFlowDistributions = 1;
    end
    
    %  Fitting distributions to models
    if exist([flowExportFolder, modelsFileNames{runIdx}], 'file')
        fprintf('  FlowModels Located\n');
        fitDataToModels = 0;
    else
        fitDataToModels = 1;
    end
    
    %%  Plotting distributions and fits
    
    if createDistributionData == 1
        fprintf('  Creating Distributions Data\n');
        [angList, timeList, relList, peakList] = FlowDistributionsData(flowExportFolder, dataFileNames{runIdx}(1:(end - 4)), vxMat, vyMat, relMat, smoothDiffImages, currPeakIm, currClusterIm);
    end
    
    if createFlowDistributions == 1
        if ~exist('angList', 'var')
            fprintf('  Loading FlowDistributionsData to Create Flow Distributions\n');
            load([flowExportFolder, dataFileNames{runIdx}], 'angList', 'timeList', 'relList', 'peakList');
        end
        fprintf('  Creating FlowDistributionsData with current parameters\n');
        [allAngCounts, relMaskAngCounts, peakMaskAngCounts, relAndPeakMaskAngCounts] = FlowDistributions(flowExportFolder, distributionsFileNames{runIdx}(1:(end - 4)), angList, timeList, relList, peakList, relThresh, peakImThresh, thetaBinSize);
    end
    
    if fitDataToModels == 1
        if ~exist('angList', 'var')
            fprintf('  Loading FlowDistributionsData to Create Flow Models\n');
            load([flowExportFolder, dataFileNames{runIdx}], 'angList', 'timeList', 'relList', 'peakList');
        end
        fprintf('  Creating FlowModels\n');
        [basicModel, mixedModel] = FitFlowDistributions(flowExportFolder, modelsFileNames{runIdx}(1:(end - 4)), angList, timeList, relList, peakList, relThresh, peakImThresh);
    end
    
    if plotResults == 1
        plotFolder = [flowExportFolder, filesep, 'Plots', filesep];
        if ~exist(plotFolder, 'dir')
            mkdir(plotFolder);
        end
        if ~exist('allAngCounts', 'var')
            fprintf('  Loading FlowDistributions to Create Plots\n');
            load([flowExportFolder, distributionsFileNames{runIdx}], 'allAngCounts', 'relMaskAngCounts', 'peakMaskAngCounts', 'relAndPeakMaskAngCounts');
        end
        if ~exist('basicModel', 'var')
            fprintf('  Loading FlowModels to Create Plots\n');
            load([flowExportFolder, modelsFileNames{runIdx}], 'basicModel', 'mixedModel');
        end
        PlotFlowDistributions(plotFolder, distributionsFileNames{runIdx}(1:(end - 4)), allAngCounts, relMaskAngCounts, peakMaskAngCounts, relAndPeakMaskAngCounts, thetaBinSize, basicModel, mixedModel);
        PlotFlowKymographs(plotFolder, distributionsFileNames{runIdx}(1:(end - 4)), allAngCounts, relMaskAngCounts, peakMaskAngCounts, relAndPeakMaskAngCounts, thetaBinSize, basicModel, mixedModel);
    end
    
end
%%  End ParameterMoviesScript
fprintf('\n- - - FlowProcessingScript Complete! - - -\n\n')
end