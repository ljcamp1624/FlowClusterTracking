%%  Convert images to RGB given a colormap
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
function RGBimage = im2RGB(image, cmap, I_low, I_high)
image = double(image);
numColors = size(cmap, 1);
intIm = (image - I_low)/(I_high - I_low);
intIm(intIm(:) < 0) = 0;
intIm(intIm(:) > 1) = 1;
intIm = ceil(intIm*numColors);
intIm(intIm(:) == 0) = 1;
rIm = zeros(size(image));
gIm = zeros(size(image));
bIm = zeros(size(image));
nanIdx = isnan(intIm);
intIm(nanIdx) = 1;
rIm(:) = cmap(intIm, 1);
gIm(:) = cmap(intIm, 2);
bIm(:) = cmap(intIm, 3);
rIm(nanIdx) = 1;
gIm(nanIdx) = 1;
bIm(nanIdx) = 1;
RGBimage = cat(ndims(image) + 1, rIm, gIm, bIm);
end