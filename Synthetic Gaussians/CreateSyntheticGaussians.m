%%  Generate Artificial Moving Gaussians
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
%%  Begin script
clear all;
close all;
clc;

%%  Define parameters
steps = 80;
xy1_init = [0, 40];
xy2_init = [40, 40];
xy1_final = [0, 0];
xy2_final = [120, 40];
sig = 10;

%%  Create grid
sigFac = 3.5;
xy_min = -ceil(3.5*sig) + min([xy1_init; xy1_final; xy2_init; xy2_final], [], 1);
xy_max = ceil(3.5*sig) + max([xy1_init; xy1_final; xy2_init; xy2_final], [], 1);
[ix, iy] = meshgrid(xy_min(1):xy_max(1), xy_min(2):xy_max(2));

%%  Calculate trajectories
x1_traj = linspace(xy1_init(1), xy1_final(1), steps);
y1_traj = linspace(xy1_init(2), xy1_final(2), steps);
x2_traj = linspace(xy2_init(1), xy2_final(1), steps);
y2_traj = linspace(xy2_init(2), xy2_final(2), steps);

%%  Generate matrices
im1 = zeros([size(ix), steps]);
im2 = zeros([size(ix), steps]);
for i = 1:steps
    tx = ix - x1_traj(i);
    ty = iy - y1_traj(i);
    im1(:, :, i) = exp(-(tx.*tx + ty.*ty)/2/sig/sig);
    tx = ix - x2_traj(i);
    ty = iy - y2_traj(i);
    im2(:, :, i) = exp(-(tx.*tx + ty.*ty)/2/sig/sig);
end
im3 = im1 + im2 + 0.1*(2*rand(size(im1)) - 1);
im3(im3 > 0.25) = 0.25;
im3 = uint8(255*(im3 - min(im3(:)))/max(im3(:) - min(im3(:))));

%%  Save artificial images
imwrite(im3(:, :, 1), 'SyntheticGaussians.tif');
for i = 2:steps
    imwrite(im3(:, :, i), 'SyntheticGaussians.tif', 'WriteMode', 'append');
end