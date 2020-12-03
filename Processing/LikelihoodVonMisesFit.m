%%  Fit angList to a mixture of two VM distributions + constant
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
%   Likelihood VonMisesFitOverTime.m
%
function newFitParams = LikelihoodVonMisesFit(angList, fitParams)
%%  Early exit
if isempty(angList) || isempty(fitParams)
    newFitParams = [];
    return;
end

%%  choose initial parameters
b = fitParams(:); % Should be in the form  b = [mu; k; p1; p2; p3];

%   These lines assume that fitParams are initialized by
%   AnalyticalVonMisesFit*.m to "invert" the normalization to prepare for
%   maximum likelihood fitting.
z1 = fitParams(3);
z2 = fitParams(4);
x1 = log(min(1, max(0.01, z1)));
x2 = log(min(1, max(0.01, z2)));
newFitParams(1) = fitParams(1);
newFitParams(2) = fitParams(2);
newFitParams(3) = x1;
newFitParams(4) = x2;
newFitParams(5) = min(x1, x2) + log(.01);

%%  fit data
options = optimoptions('fmincon', 'GradObj', 'on', 'display', 'none');
% lowerBound = [-inf; 2; -inf; -inf; -inf];
lowerBound = [-inf; -inf; -inf; -inf; -inf];
newFitParams = fmincon(@(b) VMMix_logF(angList, b), newFitParams, [], [], [], [], lowerBound, [], [], options);

%%  process output
z = sum(exp(newFitParams(3:5)));
newFitParams(3:5) = exp(newFitParams(3:5))/z;
newFitParams = newFitParams(:)';
end