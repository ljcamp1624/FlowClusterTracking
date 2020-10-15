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
function [vx, vy, rel, coh, dxI, dyI, dtI] = LKxOptFlowT(I, xySig, tSig, wSig)

I = double(I);
[ix, iy] = meshgrid(-3*xySig:3*xySig, -3*xySig:3*xySig);



dxI = [I(:, 2, :) - I(:, 1, :), (I(:, 3:end, :) - I(:, 1:(end - 2), :))/2, I(:, end, :) - I(:, end - 1, :)];
dyI = [I(2, :, :) - I(1, :, :); (I(3:end, :, :) - I(1:(end - 2), :, :))/2; I(end, :, :) - I(end - 1, :, :)];
dtI = cat(3, I(:, :, 2) - I(:, :, 1), (I(:, :, 3:end) - I(:, :, 1:(end - 2)))/2, I(:, :, end) - I(:, :, end - 1));

wdx2 = imfilter((dxI.^2), w, 'replicate');
wdxy = imfilter((dxI.*dyI), w, 'replicate');
wdy2 = imfilter((dyI.^2), w, 'replicate');
wdtx = imfilter((dxI.*dtI), w, 'replicate');
wdty = imfilter((dyI.*dtI), w, 'replicate');

trace = wdx2 + wdy2;
determinant = (wdx2.*wdy2) - (wdxy.^2);

e1 = (trace + sqrt(trace.^2 - 4*determinant))/2;
e2 = (trace - sqrt(trace.^2 - 4*determinant))/2;
rel = min(e1, e2);
coh = abs(e1 - e2)./(e1 + e2 + eps);

vx = ((determinant + eps).^-1).*((wdy2.*-wdtx)+(-wdxy.*-wdty));
vy = ((determinant + eps).^-1).*((-wdxy.*-wdtx)+(wdx2.*-wdty));