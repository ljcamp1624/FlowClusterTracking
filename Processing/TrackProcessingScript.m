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
trackExportFolder = [fileParams.exportFolder, 'TrackProcessingFolder', filesep];
if ~exist(trackExportFolder, 'dir')
    mkdir(trackExportFolder);
end

%%  Process file names
dataFileNames = {...,
    'TracksData.mat', ...
    'PosTracksData.mat', ...
    'NegTracksData.mat'};

listsFileNames = {...,
    'TracksLists.mat', ...
    'PosTracksLists.mat', ...
    'NegTracksLists.mat'};

distributionsFileNames = {...,
    'TracksDistributions.mat', ...
    'PosTracksDistributions.mat', ...
    'NegTracksDistributions.mat'};

velDistFileNames = {...,
    'TrackVels.mat', ...
    'PosTrackVels.mat', ...
    'NegTrackVels.mat'};

angDistFileNames = {...,
    'TrackAngs.mat', ...
    'PosTrackAngs.mat', ...
    'NegTrackAngs.mat'};

%%  Process parameters
minTrackLength = processingParams.minTrackLength;
trackSmoothNumNNs = processingParams.trackSmoothNumNNs;
thetaBinSize = processingParams.thetaBinSizeTracks;
velBinSize = processingParams.velBinSize;
velMax = processingParams.velMax;

%%  Load flow cluster tracks
fprintf('  Loading Cluster Images to Create Tracks Data\n');
load([exportFolder, 'FlowClusterTracks.mat'], 'tracks', 'tracksPos', 'tracksNeg');

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
    if runIdx == 1
        currTracks = tracks;
    elseif runIdx == 2
        currTracks = tracksPos;
    elseif runIdx == 3
        currTracks = tracksNeg;
    end
    
    %%  Run parameters
    
    %  Accumulate distribution data
    if exist([trackExportFolder, dataFileNames{runIdx}], 'file')
        oldParams = load([trackExportFolder, dataFileNames{runIdx}], 'minTrackLength', 'trackSmoothNumNNs');
        oldMinTrackLength = oldParams.minTrackLength;
        oldNumNNs = oldParams.trackSmoothNumNNs;
        if (oldMinTrackLength ~= minTrackLength) || (oldNumNNs ~= trackSmoothNumNNs)
            createTracksData = 1;
        else
            fprintf('  TracksData Located\n');
            createTracksData = 0;
        end
    else
        createTracksData = 1;
    end
    
    %  Calculate flow distributions
    if createTracksData == 1
        createTrackDistributions = 1;
    elseif exist([trackExportFolder, listsFileNames{runIdx}], 'file')
        fprintf('  TracksDistributions Located\n');
        oldData = load([trackExportFolder, distributionsFileNames{runIdx}], 'thetaBinSize', 'velBinSize', 'velMax');
        oldThetaBinSize = oldData.thetaBinSize;
        oldVelBinSize = oldData.velBinSize;
        oldVelMax = oldData.velMax;
        if (oldThetaBinSize ~= thetaBinSize) || (oldVelBinSize ~= velBinSize) || (oldVelMax ~= velMax)
            createTrackDistributions = 1;
        else
            createTrackDistributions = 0;
        end
    else
        createTrackDistributions = 1;
    end
    
    %%  Plotting distributions and fits
    
    if createTracksData == 1
        fprintf('  Creating Track Distributions Data\n');
        [o1, o2, p1, p2, q1, q2] = TrackDistributionsData(trackExportFolder, dataFileNames{runIdx}(1:(end - 4)), currTracks, minTrackLength, trackSmoothNumNNs);
    end
    
    if createTrackDistributions == 1
        if ~exist('o1', 'var')
            fprintf('  Loading TrackDistributionsData to Create Track Velocity and Angle Distributions\n');
            data1 = load([trackExportFolder, dataFileNames{runIdx}], 'diffMatInst', 'longDiffMatInst', 'smoothDiffMatInst');
            data2 = load([trackExportFolder, dataFileNames{runIdx}], 'diffMatAvg', 'longDiffMatAvg', 'smoothDiffMatAvg');
            o1 = data1.diffMatInst;
            p1 = data1.longDiffMatInst;
            q1 = data1.smoothDiffMatInst;
            o2 = data2.diffMatAvg;
            p2 = data2.longDiffMatAvg;
            q2 = data2.smoothDiffMatAvg;
        end
        fprintf('  Creating TrackDistributions with current parameters\n');
        TrackDistributions(trackExportFolder, listsFileNames{runIdx}(1:(end - 4)), distributionsFileNames{runIdx}(1:(end - 4)), o1, p1, q1, o2, p2, q2, velBinSize, velMax, fileParams, thetaBinSize);
    end
    
    if plotResults == 1
        %%  Plot directory
        plotFolder = [trackExportFolder, filesep, 'Plots', filesep];
        if ~exist(plotFolder, 'dir')
            mkdir(plotFolder);
        end
        
        %%  Track Velocity distributions
        load([trackExportFolder, distributionsFileNames{runIdx}], 'instVelCounts', 'longInstVelCounts', 'smoothInstVelCounts', 'velBins', 'velUnit');
        PlotTrackVelocityDistributions(plotFolder, [velDistFileNames{runIdx}(1:(end - 4)), '_inst'], instVelCounts, longInstVelCounts, smoothInstVelCounts, velBins, velUnit);
        load([trackExportFolder, distributionsFileNames{runIdx}], 'avgVelCounts', 'longAvgVelCounts', 'smoothAvgVelCounts');
        PlotTrackVelocityDistributions(plotFolder, [velDistFileNames{runIdx}(1:(end - 4)), '_avg'], avgVelCounts, longAvgVelCounts, smoothAvgVelCounts, velBins, velUnit);
        
        %%  Track Angle distributions
        load([trackExportFolder, distributionsFileNames{runIdx}], 'instAngCounts', 'longInstAngCounts', 'smoothInstAngCounts', 'thetaBinSize');
        PlotTrackAngleDistributions(plotFolder, [angDistFileNames{runIdx}(1:(end - 4)), '_inst'], instAngCounts, longInstAngCounts, smoothInstAngCounts, thetaBinSize);
        load([trackExportFolder, distributionsFileNames{runIdx}], 'avgAngCounts', 'longAvgAngCounts', 'smoothAvgAngCounts');
        PlotTrackAngleDistributions(plotFolder, [angDistFileNames{runIdx}(1:(end - 4)), '_avg'], avgAngCounts, longAvgAngCounts, smoothAvgAngCounts, thetaBinSize);

    end
 
end
%%  End ParameterMoviesScript
fprintf('\n- - - TrackProcessingScript Complete! - - -\n\n')
end