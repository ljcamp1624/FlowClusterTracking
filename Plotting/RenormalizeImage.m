%%  Renormalize an Image from [0 1] with optional percentile cutoff
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
function out = RenormalizeImage(input, varargin)
input = double(input);
if isempty(varargin)
    out = (input - min(input(:)))/(max(input(:)) - min(input(:)));
else
    out = (input - prctile(input(:), varargin{1}))/(prctile(input(:), 100 - varargin{1}) - prctile(input(:), varargin{1}));
    out(out(:) > 1) = 1;
    out(out(:) < 0) = 0;
end
end