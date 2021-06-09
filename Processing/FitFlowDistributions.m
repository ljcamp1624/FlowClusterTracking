%%  Fitting Data to Mixed von Mises Model Function
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
%   This function is called by FlowProcessingScript.m
%
function [basicModel, mixedModel] = FitFlowDistributions(exportFolder, fileName, angList, timeList, relList, peakList, relThresh, peakImThresh)
%%  Calculate basic von-Mises-model parameters

basicModel.noMask.allTimes = AnalyticalVonMisesFit(angList);
basicModel.noMask.overTime = AnalyticalVonMisesFitOverTime(angList, timeList);

mask = relList > relThresh;
basicModel.relMask.allTimes = AnalyticalVonMisesFit(angList(mask));
basicModel.relMask.overTime = AnalyticalVonMisesFitOverTime(angList(mask), timeList(mask));

mask = peakList > peakImThresh;
basicModel.peakMask.allTimes = AnalyticalVonMisesFit(angList(mask));
basicModel.peakMask.overTime = AnalyticalVonMisesFitOverTime(angList(mask), timeList(mask));

mask = (relList > relThresh) & (peakList > peakImThresh);
basicModel.relAndPeakMask.allTimes = AnalyticalVonMisesFit(angList(mask));
basicModel.relAndPeakMask.overTime = AnalyticalVonMisesFitOverTime(angList(mask), timeList(mask));

%%  Fit distribution to von-Mises-model-plus-constant model

mixedModel.noMask.allTimes = LikelihoodVonMisesFit(angList, basicModel.noMask.allTimes);
mixedModel.noMask.overTime = LikelihoodVonMisesFitOverTime(angList, timeList, basicModel.noMask.overTime);

mask = relList > relThresh;
mixedModel.relMask.allTimes = LikelihoodVonMisesFit(angList(mask), basicModel.relMask.allTimes);
mixedModel.relMask.overTime = LikelihoodVonMisesFitOverTime(angList(mask), timeList(mask), basicModel.relMask.overTime);

mask = peakList > peakImThresh;
mixedModel.peakMask.allTimes = LikelihoodVonMisesFit(angList(mask), basicModel.peakMask.allTimes);
mixedModel.peakMask.overTime = LikelihoodVonMisesFitOverTime(angList(mask), timeList(mask), basicModel.peakMask.overTime);

mask = (relList > relThresh) & (peakList > peakImThresh);
mixedModel.relAndPeakMask.allTimes = LikelihoodVonMisesFit(angList(mask), basicModel.relAndPeakMask.allTimes);
mixedModel.relAndPeakMask.overTime = LikelihoodVonMisesFitOverTime(angList(mask), timeList(mask), basicModel.relAndPeakMask.overTime);

%%  Save output
save([exportFolder, fileName], 'basicModel', 'mixedModel', 'relThresh', 'peakImThresh');

end