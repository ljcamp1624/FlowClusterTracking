%%  Declutter quiver and reliability matrices (can be used generally)
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
%   This function is called by CreateMovies_withFlow.m
%
function [vx, vy, rel] = DeclutterQuiver(vx, vy, rel, s)
vx(mod(1:size(vx, 1), s) ~= 0, :, :) = 0;
vx(:, mod(1:size(vx, 2), s) ~= 0, :) = 0;
vy(mod(1:size(vy, 1), s) ~= 0, :, :) = 0;
vy(:, mod(1:size(vy, 2), s) ~= 0, :) = 0;
rel(mod(1:size(rel, 1), s) ~= 0, :, :) = 0;
rel(:, mod(1:size(rel, 2), s) ~= 0, :) = 0;