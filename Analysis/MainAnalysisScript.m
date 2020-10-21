%%  Main Flow Tracking Analysis Script
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
function MainAnalysisScript(fileParams, analysisParams)
%% Start MainAnalysisScript
fprintf('\n- - - Starting MainAnalysisScript - - -\n\n')

%%  Import Images
if exist([fileParams.exportFolder, 'OriginalImages.mat'], 'file')
    fprintf('- Original Images Located\n');
else
    fprintf('- Importing Original Images\n');
    ImportImage(fileParams);
end

%% Calculate Optical Flow
if exist([fileParams.exportFolder, 'OpticalFlow.mat'], 'file')
    fprintf('- Optical Flow Images Located\n');
else
    % Load Dependencies
    fprintf('- Loading Original Images for Optical Flow Calculations\n');
    load([fileParams.exportFolder, 'OriginalImages.mat'], 'originalImages');
    % Calculate Optical Flow
    fprintf('  Calculating Optical Flow\n');
    CalculateOpticalFlow(fileParams, analysisParams.flowParams, originalImages);
end

%% Smooth Original Images
if exist([fileParams.exportFolder, 'SmoothImages.mat'], 'file')
    fprintf('- Smooth Images Located\n');
else
    % Load Dependencies
    fprintf('- Loading Original Images for Smoothing\n');
    load([fileParams.exportFolder, 'OriginalImages.mat'], 'originalImages');
    % Perform Smoothing
    fprintf('  Creating Smooth Images\n');
    SmoothImages(fileParams, analysisParams.smoothParams, originalImages);
end

%% Calculate Difference Images
if exist([fileParams.exportFolder, 'DifferenceImages.mat'], 'file')
    fprintf('- Difference Images Located\n');
else
    % Load dependencies
    if ~exist('originalImages', 'var')
        fprintf('- Loading Original Images for Difference Images Calculation\n');
        load([fileParams.exportFolder, 'originalImages.mat'], 'originalImages');
    end
    if ~exist('smoothImage', 'var')
        fprintf('  Loading Smooth Images for Difference Images Calculation\n');
        load([fileParams.exportFolder, 'SmoothImages.mat'], 'smoothImages');
    end
    % Create Difference Image
    fprintf('  Calculating Difference Images\n');
    CalculateDifferenceImages(fileParams, analysisParams.clusterParams, originalImages, smoothImages);
end

%% Track Flow Clusters
if exist([fileParams.exportFolder, 'FlowClusterTracks.mat'], 'file')
    fprintf('- Flow Cluster Tracks Located\n');
else
    % Load dependencies
    fprintf('- Loading Difference Image for Flow Cluster Tracking\n');
    load([fileParams.exportFolder, 'DifferenceImages.mat'], 'smoothDiffImages');
    fprintf('  Loading Optical Flow for Flow Cluster Tracking\n');
    load([fileParams.exportFolder, 'OpticalFlow.mat'], 'vxMat', 'vyMat', 'relMat');
    fprintf('  Tracking Flow Clusters\n');
    TrackFlowClusters(fileParams, analysisParams.clusterParams, vxMat, vyMat, relMat, smoothDiffImages);
end

%% End MainAnalysisScript
fprintf('\n- - - MainAnalysisScript Complete! - - -\n\n')
end