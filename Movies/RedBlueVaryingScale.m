%%  Construct a Positive-Negative Red-Blue Colormap around [minVal, maxVal]
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
%   This function is called by CreateMovies.m
%
function cmap = RedBlueVaryingScale(numColors, minVal, maxVal)
ss = (maxVal - minVal)/numColors;
numR = ceil(abs(minVal)/ss) - 1;
numB = ceil(abs(maxVal)/ss) - 1;
bluSeg = 1 - linspace(numB/max(numB, numR), 0, numB);
redSeg = 1 - linspace(numR/max(numB, numR), 0, numR);
redLine = [ones(length(redSeg), 1); 1; flipud(bluSeg(:))];
grnLine = [redSeg(:); 1; flipud(bluSeg(:))];
bluLine = [redSeg(:); 1; ones(length(bluSeg), 1)];
cmap = [redLine, grnLine, bluLine];
end