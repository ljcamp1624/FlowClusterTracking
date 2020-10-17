%%  Parameter Movies Script
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
function TrackProcessingScript(fileParams, processingParams)
%%  Start ParameterMoviesScript
fprintf('\n- - - Starting TrackProcessingScript - - -\n\n')

%% Process folders
exportFolder = fileParams.exportFolder;
movieExportFolder = [fileParams.exportFolder, 'FlowProcessingFolder', filesep];
if ~exist(movieExportFolder, 'dir')
    mkdir(movieExportFolder);
end

%%  End ParameterMoviesScript
fprintf('\n- - - TrackProcessingScript Complete! - - -\n\n')
end