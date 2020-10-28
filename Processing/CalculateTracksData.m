%%  Calculate Tracks Data Function
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
%   This function is called by TrackDistributionsData.m
%
function [diffMatInst, diffMatAvg] = CalculateTracksData(tracks)
%%  Calculate track data
diffMatInst = [];
diffMatAvg = [];
idxList = unique(tracks(:, 4));
for i = 1:length(idxList)
    currTrack = tracks(tracks(:, 4) == idxList(i), 1:3);
    if size(currTrack, 1) > 1
        currDiffInst = [currTrack(2:end, :) - currTrack(1:(end - 1), :)];
        currDiffAvg = [currTrack(end, :) - currTrack(1, :)];
        currDiffInst = [currDiffInst, atan2(currDiffInst(:, 2), currDiffInst(:, 1)), currTrack(1:(end - 1), 3)];
        currDiffAvg = [currDiffAvg, atan2(currDiffAvg(2), currDiffAvg(1)), currTrack(1, 3)];
        diffMatInst = [diffMatInst; [currDiffInst, zeros(size(currDiffInst, 1), 1) + idxList(i)]];
        diffMatAvg = [diffMatAvg; [currDiffAvg, zeros(size(currDiffAvg, 1), 1) + idxList(i)]];
    else
        diffMatInst = [diffMatInst; [nan, nan, nan, nan, currTrack(1, 3), idxList(i)]];
        diffMatAvg = [diffMatAvg; [nan, nan, nan, nan, currTrack(1, 3), idxList(i)]];
    end
end
end