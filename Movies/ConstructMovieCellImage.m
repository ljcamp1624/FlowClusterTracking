%%  Construct "MovieCell" Image
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
%   This function is called by CreateMovies*.m
%
function im = ConstructMovieCellImage(movieCell, vpadSize, hpadSize)
sz = size(movieCell{1});
if length(movieCell) == 1
    im = movieCell{1};
elseif length(movieCell) == 2
    im = cat(2, movieCell{1}, zeros(sz(1), 5, sz(3), 3), movieCell{2});
elseif length(movieCell) == 3
    hpad = zeros(vpadSize, sz(2), sz(3), 3);
    im = cat(1, movieCell{1}, hpad, movieCell{2}, hpad, movieCell{3});
elseif length(movieCell) == 4
    vpad = zeros(sz(1), vpadSize, sz(3), 3);
    im = cat(2, movieCell{1}, vpad, movieCell{2});
    sz2 = size(im);
    hpad = zeros(hpadSize, sz2(2), sz(3), 3);
    im = cat(1, im, hpad, cat(2, movieCell{3}, vpad, movieCell{4}));
end
end