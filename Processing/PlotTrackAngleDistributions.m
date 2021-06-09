function PlotTrackAngleDistributions(folderName, fileName, angCounts, longAngCounts, smoothAngCounts, thetaBinSize)

PlotPolarDistribution(folderName, [fileName, '_allAngles'], sum(angCounts(:, 2:end), 1), thetaBinSize);
PlotPolarDistributionOverTime(folderName, [fileName, '_allAngles_overTime'], angCounts, thetaBinSize);

PlotPolarDistribution(folderName, [fileName, '_longAngles'], sum(longAngCounts(:, 2:end), 1), thetaBinSize);
PlotPolarDistributionOverTime(folderName, [fileName, '_longAngles_overTime'], longAngCounts, thetaBinSize);

PlotPolarDistribution(folderName, [fileName, '_smoothAngles'], sum(smoothAngCounts(:, 2:end), 1), thetaBinSize);
PlotPolarDistributionOverTime(folderName, [fileName, '_smoothAngles_overTime'], smoothAngCounts, thetaBinSize);

close all;

end