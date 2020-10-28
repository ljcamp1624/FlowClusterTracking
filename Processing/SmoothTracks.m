%%  Smooth Tracks in [x, y, t, ID] using nearest neighbor averaging
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
%   This function is called by CreateMovies_withTracks.m
%
function smoothedTracks = SmoothTracks(tracks, numNearestNeighbors)
idxArray = unique(tracks(:, 4)); 
smoothedTracks = zeros(size(tracks));
for i = 1:length(idxArray)
    idx = idxArray(i);
    currIdx = tracks(:, 4) == idx;
    currTrack = tracks(currIdx, 1:3);
    newTrack_x = [];
    newTrack_y = [];
    for j = 0:numNearestNeighbors
        fil = ones(2*j + 1, 1); fil = fil/sum(fil);
        newTrack_x(:, j + 1) = imfilter(currTrack(:, 1), fil, 'replicate');
        newTrack_y(:, j + 1) = imfilter(currTrack(:, 2), fil, 'replicate');
    end
    mask = eye(size(newTrack_x, 1)) + flipud(eye(size(newTrack_x, 1)));
    mask(:, (numNearestNeighbors + 1)) = sum(mask(:, (numNearestNeighbors + 1):end), 2);
    mask = mask(:, 1:(numNearestNeighbors + 1));
    mask(:, end) = (mask(:, end) == max(mask(:, end)));
    newTrack_x = max(newTrack_x.*mask, [], 2);
    newTrack_y = max(newTrack_y.*mask, [], 2);
    smoothedTracks(currIdx, :) = [newTrack_x, newTrack_y, tracks(currIdx, 3), ones(size(newTrack_x))*idx];
end