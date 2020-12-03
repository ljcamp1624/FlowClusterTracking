%%  Fit angList to a mixture of two VM distributions + constant over time
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
%   This function is called by FitFlowDistributions.m
%
function newFitParams = LikelihoodVonMisesFitOverTime(angList, timeList, fitParams)
%%  Early exit 
if isempty(angList)
    newFitParams = [];
    return;
end
%%  Calculate new fit parameters
timeArray = unique(timeList);
newFitParams = [];
for t = 1:length(timeArray)
    currTime = timeArray(t);
    currAngList = angList(timeList == currTime);
    currParams = fitParams(fitParams(:, 1) == currTime, 2:6);
    currParams = LikelihoodVonMisesFit(currAngList, currParams);
    newFitParams = [newFitParams; [currTime, currParams]];
end
end