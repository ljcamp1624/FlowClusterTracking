%%  Movies Script
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
function MoviesScript(fileParams, processingParams)
%%  Start ParameterMoviesScript
fprintf('\n- - - Starting MoviesScript - - -\n\n')

%% Process folders
exportFolder = fileParams.exportFolder;
movieExportFolder = [fileParams.exportFolder, 'MovieFolder', filesep];
if ~exist(movieExportFolder, 'dir')
    mkdir(movieExportFolder);
end

%%  Original and Difference Images

%   Load Dependencies
fprintf('- Loading Original Images\n');
load([exportFolder, 'OriginalImages.mat'], 'originalImages');
fprintf('  Loading Smooth Images\n');
load([exportFolder, 'SmoothImages.mat'], 'smoothImages');
fprintf('  Loading Difference Images\n');
load([exportFolder, 'DifferenceImages.mat'], 'originalDiffImages', 'smoothDiffImages');

%   Create Movie
fprintf('  Creating Original vs. Difference Images Movie\n');
movieCell = {originalImages, smoothImages, originalDiffImages, smoothDiffImages};
formatCell = {'BW', 'G', 'RedBlue', 'RedBlue'};
CreateMovies(movieExportFolder, 'Original and Difference Images', movieCell, formatCell);

%%  Original with Flow Overlaid, Magnitude, and Reliability

%   Load Dependencies
fprintf('- Loading Optical Flow\n');
load([exportFolder, 'OpticalFlow.mat'], 'vxMat', 'vyMat', 'relMat');

%   Create Movie
fprintf('  Creating Optical Flow Movie\n');
relThresh = processingParams.relThresh;
relMask = relMat > relThresh;
magMat = sqrt(vxMat.*vxMat + vyMat.*vyMat);
angMat = atan2(vyMat, vxMat);
movieCell = {originalImages, {angMat.*relMask, magMat.*relMask}, magMat.*relMask, relMat.*relMask};
formatCell = {'BW', 'HSV', 'M', 'G'};
CreateMovies_withFlow(movieExportFolder, 'Original Images and Optical Flow', movieCell, formatCell, vxMat, vyMat, relMat, relThresh);

%%  Original and Cluster

%   Load Dependencies
fprintf('- Loading Cluster Images\n');
load([exportFolder, 'FlowClusterTracks.mat'], 'clusterIm');

%   Create Movie
fprintf('  Creating Optical Flow Movie\n');
movieCell = {originalImages, clusterIm};
formatCell = {'BW', 'R'};
CreateMovies(movieExportFolder, 'Original and Cluster Images', movieCell, formatCell);

%%  Original with Tracks Overlaid 

%   Load Dependencies
fprintf('- Loading Cluster Images\n');
load([exportFolder, 'FlowClusterTracks.mat'], 'tracks', 'tracksPos', 'tracksNeg');

%   Process tracks
fprintf('  Processing tracks\n');
minTrackLength = processingParams.minTrackLength;
trackSmoothNumNNs = processingParams.trackSmoothNumNNs;
tracks = SmoothTracks(tracks, trackSmoothNumNNs);
tracks = ApplyMinTrackLength(tracks, minTrackLength);
tracksPos = SmoothTracks(tracksPos, trackSmoothNumNNs);
tracksPos = ApplyMinTrackLength(tracksPos, minTrackLength);

%   Create Movie
fprintf('  Creating Original vs. Cluster Images Movie with Tracks\n');
movieCell = {originalImages};
formatCell = {'BW'};
CreateMovies_withTracks(movieExportFolder, 'Original and Cluster Images with Tracks', movieCell, formatCell, tracks);
CreateMovies_withTracks(movieExportFolder, 'Original and Cluster Images with PositiveTracks', movieCell, formatCell, tracksPos);

%%  End ParameterMoviesScript
fprintf('\n- - - MoviesScript Complete! - - -\n\n')
end