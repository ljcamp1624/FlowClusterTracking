%%  Remove quiver arrows that fall outside of the figure axis
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
function [vx, vy] = CutQuiver(vx, vy)
buffer = 1;
[x, y, ~] = meshgrid(1:size(vx, 2), 1:size(vx, 1), 1:size(vx, 3));
xNew = x + vx;
yNew = y + vy;
xNew = double(xNew > (size(x, 2) - buffer)) + double(xNew < 1 + buffer) > 0;
yNew = double(yNew > (size(x, 1) - buffer)) + double(yNew < 1 + buffer) > 0;
vx = vx.*double(~xNew).*double(~yNew);
vy = vy.*double(~xNew).*double(~yNew);