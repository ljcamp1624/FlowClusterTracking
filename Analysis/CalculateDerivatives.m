%%  Track Optical-Flow Clusters
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
%   This function is called by ClusterTrack.m
%
function [grad, jac] = CalculateDerivatives(im, sig)
%% Create filters
sig1 = sig;
sig2 = sig/2;

%   x-gradient filter (along 1st dimension of the image)
[iy, ix] = meshgrid(-ceil(3*sig2):ceil(3*sig2), -ceil(3*sig1):ceil(3*sig1));
fx = exp(-ix.*ix/2/sig1/sig1)/sqrt(2*pi)/sig1;
fy = exp(-iy.*iy/2/sig2/sig2)/sqrt(2*pi)/sig2;
gx = ix.*fx.*fy/sig1/sig1/sig2/sig2;

%   y-gradient filter (along 2nd dimension of the image)
[iy, ix] = meshgrid(-ceil(3*sig1):ceil(3*sig1), -ceil(3*sig2):ceil(3*sig2));
fx = exp(-ix.*ix/2/sig2/sig2)/sqrt(2*pi)/sig2;
fy = exp(-iy.*iy/2/sig1/sig1)/sqrt(2*pi)/sig1;
gy = iy.*fx.*fy/sig1/sig1/sig2/sig2;

%   pixel-scale x-gradient filter
gx2 = -fspecial('sobel');

%   pixel-scale y-gradient filter
gy2 = -fspecial('sobel')';

%% Compute Derivates

%   first derivatives on the scale of "sig"
grad_x = imfilter(im, gx, 'replicate');
grad_y = imfilter(im, gy, 'replicate');

%   second derivatives on the scale of "sig"
% grad_xx = imfilter(grad_x, gx, 'replicate');
% grad_xy = imfilter(grad_x, gy, 'replicate');
% grad_yx = imfilter(grad_y, gx, 'replicate');
% grad_yy = imfilter(grad_y, gy, 'replicate');

%   second derivatives on the pixel scale (LC thinks this is probably better)
grad_xx = imfilter(grad_x, gx2, 'replicate');
grad_xy = imfilter(grad_x, gy2, 'replicate');
grad_yx = imfilter(grad_y, gx2, 'replicate');
grad_yy = imfilter(grad_y, gy2, 'replicate');

%% Compute Gradient and Jacobian
grad = sqrt(grad_x.^2 + grad_y.^2);
jac = grad_xx.*grad_yy - grad_xy.*grad_yx;
end