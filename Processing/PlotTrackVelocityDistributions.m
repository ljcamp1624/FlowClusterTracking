function PlotTrackVelocityDistributions(folderName, fileName, velCounts, longCounts, smoothCounts, velBins, velUnit)

PlotDistribution(folderName, fileName, sum(velCounts(:, 2:end), 1), velBins, velUnit);
PlotDistributionOverTime(folderName, [fileName, '_overTime'], velCounts, velBins, velUnit);

PlotDistribution(folderName, [fileName, '_longVels'], sum(longCounts(:, 2:end), 1), velBins, velUnit);
PlotDistributionOverTime(folderName, [fileName, '_longVels_overTime'], longCounts, velBins, velUnit);

PlotDistribution(folderName, [fileName, '_smoothVels'], sum(smoothCounts(:, 2:end), 1), velBins, velUnit);
PlotDistributionOverTime(folderName, [fileName, '_smoothVels_overTime'], smoothCounts, velBins, velUnit);

close all;

end