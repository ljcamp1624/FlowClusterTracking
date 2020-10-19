%%  Fit angList to a mixture of two VM distributions
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
%   This function is called by FitFlowDistributions.m and
%   AnalyticalVonMisesFitOverTime.m
%
function fitParams = AnalyticalVonMisesFit(angList)
%%  Calculate Modified Bessel Functions of the First Kind
xVec = 0:0.001:1000;
I0 = besseli(0, xVec); 
I1 = besseli(1, xVec);
I2 = besseli(2, xVec);
A1 = I1./I0;
A2 = I2./I0;

%%  Calculate Special Function Values
n = length(angList);
psiList = mod(angList, pi);
cosPsi = sum(cos(2*psiList))/n; 
sinPsi = sum(sin(2*psiList))/n;
radPsi = sqrt(cosPsi^2 + sinPsi^2);
cosList = cos(angList);
sinList = sin(angList);
cosAvg = mean(cosList);
sinAvg = mean(sinList);

%%  Calculate Model Parameters
mu = atan2(sinPsi, cosPsi)/2;
idx = find(abs(A2 - radPsi) == min(abs(A2 - radPsi)), 1);
kappa = xVec(idx);
p = (((cosAvg*cos(mu) + sinAvg*sin(mu))/A1(idx)) + 1)/2;

%%  Output
fitParams = [mu, kappa, p, 1 - p, 0];
end