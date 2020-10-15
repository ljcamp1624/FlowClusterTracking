%%  Calculate Optical Flow - all frames at once
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
%   This function is called by CalculateOpticalFlow.m
%
function [vx, vy, rel, coh, dxI, dyI, dtI] = LKxOptFlow_allFrames(images, xySig, tSig, wSig)
%%  Convert images
images = double(images);

%%  Create filters for calculating gradients

%   x-gradient filter (along 1st dimension of the image)
[iy, ix] = meshgrid(-3:3, -3*xySig:3*xySig);
fx = exp(-ix.*ix/2/xySig/xySig)/sqrt(2*pi)/xySig;
fy = exp(-iy.*iy/2)/sqrt(2*pi);
gx = ix.*fx.*fy/xySig/xySig;

%   y-gradient filter (along 2nd dimension of the image)
[iy, ix] = meshgrid(-3*xySig:3*xySig, -3:3);
fx = exp(-ix.*ix/2)/sqrt(2*pi);
fy = exp(-iy.*iy/2/xySig/xySig)/sqrt(2*pi)/xySig;
gy = iy.*fx.*fy/xySig/xySig;

%   t-gradient filter (along 3rd dimension of the image)
[iy, ix, it] = meshgrid(-3:3, -3:3, -3*tSig:3*tSig);
fx = exp(-ix.*ix/2)/sqrt(2*pi);
fy = exp(-iy.*iy/2)/sqrt(2*pi);
ft = exp(-it.*it/2/tSig/tSig)/sqrt(2*pi)/tSig;
gt = it.*fx.*fy.*ft/tSig/tSig;

%% Calculate gradients
dxI = imfilter(images, gx, 'replicate');
dyI = imfilter(images, gy, 'replicate');
dtI = imfilter(images, gt, 'replicate');

%% Calculate structure tensor inputs
wdx2 = imgaussfilt(dxI.^2, wSig, 'padding', 'replicate');
wdxy = imgaussfilt(dxI.*dyI, wSig, 'padding', 'replicate');
wdy2 = imgaussfilt(dyI.^2, wSig, 'padding', 'replicate');
wdtx = imgaussfilt(dxI.*dtI, wSig, 'padding', 'replicate');
wdty = imgaussfilt(dyI.*dtI, wSig, 'padding', 'replicate');

%% Calculate Optical Flow
trace = wdx2 + wdy2;
determinant = (wdx2.*wdy2) - (wdxy.^2);
e1 = (trace + sqrt(trace.^2 - 4*determinant))/2;
e2 = (trace - sqrt(trace.^2 - 4*determinant))/2;
rel = min(e1, e2);
coh = abs(e1 - e2)./(e1 + e2 + eps);
vx = ((determinant + eps).^-1).*((wdy2.*-wdtx)+(-wdxy.*-wdty));
vy = ((determinant + eps).^-1).*((-wdxy.*-wdtx)+(wdx2.*-wdty));