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
function [vx, vy, rel] = LKxOptFlow_allFrames(images, xySig1, tSig, wSig)
%%  Convert images
images = double(images);

%%  Create filters for calculating gradients

%   Process parameters
xyRange1 = -ceil(3*xySig1):ceil(3*xySig1);
xySig2 = xySig1/4;
xyRange2 = -ceil(3*xySig2):ceil(3*xySig2);
tRange = -ceil(3*tSig):ceil(3*tSig);

%   Build x-gradient filter kernels (along first dimension)
x = xyRange1;
y = xyRange2;
fx1 = exp(-x.*x/2/xySig1/xySig1)/sqrt(2*pi)/xySig1;
fy1 = exp(-y.*y/2/xySig2/xySig2)/sqrt(2*pi)/xySig2;
gx1 = x/xySig1/xySig1;
gy1 = 1;
xFil1 = (fx1.*gx1)';
yFil1 = (fy1.*gy1);

%   Build y-gradient filter kernels (along first dimension)
x = xyRange2;
y = xyRange1;
fx2 = exp(-x.*x/2/xySig2/xySig2)/sqrt(2*pi)/xySig2;
fy2 = exp(-y.*y/2/xySig1/xySig1)/sqrt(2*pi)/xySig1;
gx2 = 1;
gy2 = y/xySig1/xySig1;
xFil2 = (fx2.*gx2)';
yFil2 = (fy2.*gy2);

%   Build t-gradient filter kernels (along first dimension)
x = xyRange1;
y = xyRange1;
t = tRange;
fx3 = exp(-x.*x/2/xySig1/xySig1)/sqrt(2*pi)/xySig1;
fy3 = exp(-y.*y/2/xySig1/xySig1)/sqrt(2*pi)/xySig1;
ft3 = exp(-t.*t/2/tSig/tSig)/sqrt(2*pi)/tSig;
gx3 = 1;
gy3 = 1;
gt3 = t/tSig/tSig;
xFil3 = (fx3.*gx3)';
yFil3 = (fy3.*gy3);
tFil3 = permute(ft3.*gt3, [3, 1, 2]);

% %   x-gradient filter (along 1st dimension of the image)
% [iy, ix] = meshgrid(xyRange2, xyRange1);
% fx = exp(-ix.*ix/2/xySig1/xySig1)/sqrt(2*pi)/xySig1;
% fy = exp(-iy.*iy/2/xySig2/xySig2)/sqrt(2*pi)/xySig2;
% gx = ix.*fx.*fy/xySig1/xySig1;
% 
% %   y-gradient filter (along 2nd dimension of the image)
% [iy, ix] = meshgrid(xyRange1, xyRange2);
% fx = exp(-ix.*ix/2/xySig2/xySig2)/sqrt(2*pi)/xySig2;
% fy = exp(-iy.*iy/2/xySig1/xySig1)/sqrt(2*pi)/xySig1;
% gy = iy.*fx.*fy/xySig1/xySig1;
% 
% %   t-gradient filter (along 3rd dimension of the image)
% [iy, ix, it] = meshgrid(-3:3, -3:3, -3*tSig:3*tSig);
% fx = exp(-ix.*ix/2)/sqrt(2*pi);
% fy = exp(-iy.*iy/2)/sqrt(2*pi);
% ft = exp(-it.*it/2/tSig/tSig)/sqrt(2*pi)/tSig;
% gt = it.*fx.*fy.*ft/tSig/tSig;

%% Calculate gradients
% dxI = imfilter(images, gx, 'replicate');
% dyI = imfilter(images, gy, 'replicate');
% dtI = imfilter(images, gt, 'replicate');
dxI = imfilter(imfilter(images, xFil1, 'replicate'), yFil1, 'replicate');
dyI = imfilter(imfilter(images, xFil2, 'replicate'), yFil2, 'replicate');
dtI = imfilter(imfilter(imfilter(images, xFil3, 'replicate'), yFil3, 'replicate'), tFil3, 'replicate');
clear images

%% Calculate structure tensor inputs
% wdx2 = imgaussfilt(dxI.^2, wSig, 'padding', 'replicate');
% wdxy = imgaussfilt(dxI.*dyI, wSig, 'padding', 'replicate');
% wdy2 = imgaussfilt(dyI.^2, wSig, 'padding', 'replicate');
% wdtx = imgaussfilt(dxI.*dtI, wSig, 'padding', 'replicate');
% wdty = imgaussfilt(dyI.*dtI, wSig, 'padding', 'replicate');
wRange = -ceil(3*wSig):ceil(3*wSig);
x = wRange;
y = wRange;
gx = exp(-x.*x/2/wSig/wSig)/sqrt(2*pi)/wSig;
gy = exp(-y.*y/2/wSig/wSig)/sqrt(2*pi)/wSig;
xFil4 = (gx)';
yFil4 = (gy);

wdx2 = imfilter(imfilter(dxI.*dxI, xFil4, 'replicate'), yFil4, 'replicate');
wdxy = imfilter(imfilter(dxI.*dyI, xFil4, 'replicate'), yFil4, 'replicate');
wdy2 = imfilter(imfilter(dyI.*dyI, xFil4, 'replicate'), yFil4, 'replicate');
wdtx = imfilter(imfilter(dxI.*dtI, xFil4, 'replicate'), yFil4, 'replicate');
wdty = imfilter(imfilter(dyI.*dtI, xFil4, 'replicate'), yFil4, 'replicate');
clear dxI dyI dtI

%% Calculate Optical Flow
determinant = (wdx2.*wdy2) - (wdxy.^2);
vx = ((determinant + eps).^-1).*((wdy2.*-wdtx)+(-wdxy.*-wdty));
vy = ((determinant + eps).^-1).*((-wdxy.*-wdtx)+(wdx2.*-wdty));
clear wdtx wdty

trace = wdx2 + wdy2;
clear wdx2 wdy2 wdxy

e1 = (trace + sqrt(trace.^2 - 4*determinant))/2;
e2 = (trace - sqrt(trace.^2 - 4*determinant))/2;
rel = real(min(e1, e2));

end