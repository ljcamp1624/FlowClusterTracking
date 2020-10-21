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
function TrackProcessingScript(fileParams, processingParams, plotResults)
%%  Start ParameterMoviesScript
fprintf('\n- - - Starting TrackProcessingScript - - -\n\n')

%% Process folders
exportFolder = fileParams.exportFolder;
flowExportFolder = [fileParams.exportFolder, 'TrackProcessingFolder', filesep];
if ~exist(flowExportFolder, 'dir')
    mkdir(flowExportFolder);
end

%%  Process file names
dataFileNames = {...,
    'TracksData.mat', ...
    'PosTracksData.mat', ...
    'NegTracksData.mat'};

%%  Process parameters
relThresh = processingParams.relThresh;
peakImThresh = 3; % Hard coded.
thetaBinSize = processingParams.thetaBinSize;

%%  Load flow cluster tracks
if exist([flowExportFolder, dataFileNames{1}], 'file') && exist([flowExportFolder, dataFileNames{2}], 'file') && exist([flowExportFolder, dataFileNames{3}], 'file')
    fprintf('- Tracks Data Located\n');
    allocateData = 0;
else
    fprintf('  Loading Cluster Images to Create Tracks Data\n');
    load([exportFolder, 'FlowClusterTracks.mat'], 'tracks', 'tracksPos', 'tracksNeg');
    allocateData = 1;
end

%%  Run script
for runIdx = 1:3
    %%  Messages
    if runIdx == 1
        fprintf('\n- All Tracks\n');
    elseif runIdx == 2
        fprintf('\n- Positive Tracks\n');
    elseif runIdx == 3
        fprintf('\n- Negative Tracks\n');
    end
    
    %%  Select data
    if allocateData == 1
        if runIdx == 1
            currTracks = tracks;
        elseif runIdx == 2
            currTracks = tracksPos;
        elseif runIdx == 3
            currTracks = tracksNeg;
        end
    end
    
    %%  Run parameters
    
    %  Accumulate distribution data
    if exist([flowExportFolder, dataFileNames{runIdx}], 'file')
        fprintf('  TracksData Located\n');
        createTracksData = 0;
    else
        createTracksData = 1;
    end
    
    %%  Plotting distributions and fits
    
    if createTracksData == 1
        
    end
 
end
%%  End ParameterMoviesScript
fprintf('\n- - - TrackProcessingScript Complete! - - -\n\n')
end