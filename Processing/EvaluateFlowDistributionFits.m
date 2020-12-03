%%  Evaluate flow distribution fits
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
function [modelEvals] = EvaluateFlowDistributionFits(exportFolder, fileName, angList, timeList, relList, peakList, relThresh, peakThresh, basicModel, mixedModel)
%%  Params
nPoints = 1000;
thetaList = linspace(0, 2*pi, nPoints);

%%  All angles
if ~isempty(basicModel.noMask.allTimes)
    
    tempAngList = mod(angList, 2*pi);
    angBins = movmean(thetaList, 2, 'Endpoints', 'discard');
    counts = histcounts(tempAngList, [-inf, angBins, inf], 'Normalization', 'probability');
    realCDF = cumsum(counts);
    basicCDF = cumsum(VMMix_f_proportions(thetaList, basicModel.noMask.allTimes));
    mixedCDF = cumsum(VMMix_f_proportions(thetaList, mixedModel.noMask.allTimes));
    
    figure('position', [1 1 900 900]);
    plot(thetaList, basicCDF, 'linewidth', 3); hold on;
    plot(thetaList, mixedCDF, 'linewidth', 3)
    plot(thetaList, realCDF, '--', 'linewidth', 3)
    xlim([0, 2*pi]);
    ylim([0 1])
    legend({'Analytical von Mises model', 'Mixed von Mises model', 'Real CDF'});
    set(gca, 'fontsize', 16);
    xlabel('Angle');
    ylabel('Cumulative Probability');
    print([exportFolder, fileName, '_all'], '-dpng', '-r150');
    
end

%%  Rel mask
if ~isempty(basicModel.relMask.allTimes)
    
    mask = relList > relThresh;
    tempAngList = mod(angList(mask), 2*pi);
    angBins = movmean(thetaList, 2, 'Endpoints', 'discard');
    counts = histcounts(tempAngList, [-inf, angBins, inf], 'Normalization', 'probability');
    realCDF = cumsum(counts);
    basicCDF = cumsum(VMMix_f_proportions(thetaList, basicModel.relMask.allTimes));
    mixedCDF = cumsum(VMMix_f_proportions(thetaList, mixedModel.relMask.allTimes));
    
    figure('position', [1 1 900 900]);
    plot(thetaList, basicCDF, 'linewidth', 3); hold on;
    plot(thetaList, mixedCDF, 'linewidth', 3)
    plot(thetaList, realCDF, '--', 'linewidth', 3)
    xlim([0, 2*pi]);
    ylim([0 1])
    legend({'Analytical von Mises model', 'Mixed von Mises model', 'Real CDF'});
    set(gca, 'fontsize', 16);
    xlabel('Angle');
    ylabel('Cumulative Probability');
    print([exportFolder, fileName, '_relMask'], '-dpng', '-r150');
    
end

%%
modelEvals = 1;
end