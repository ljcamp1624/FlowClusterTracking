function PlotFlowDistributions(folderName, fileName, angCounts, relMaskCounts, peakMaskCounts, relAndPeakMaskCounts, thetaBinSize, basicModel, mixedModel)

PlotPolarDistribution(folderName, [fileName, '_allAngles'], sum(angCounts, 1), thetaBinSize);
PlotPolarDistribution(folderName, [fileName, '_allAngles_basicModel'], sum(angCounts, 1), thetaBinSize, basicModel.noMask.allTimes);
PlotPolarDistribution(folderName, [fileName, '_allAngles_mixedModel'], sum(angCounts, 1), thetaBinSize, mixedModel.noMask.allTimes);
PlotPolarDistributionOverTime(folderName, [fileName, '_allAngles_overTime'], angCounts, thetaBinSize);
PlotPolarDistributionOverTime(folderName, [fileName, '_allAngles_basicModel_overTime'], angCounts, thetaBinSize, basicModel.noMask.overTime);
PlotPolarDistributionOverTime(folderName, [fileName, '_allAngles_mixedModel_overTime'], angCounts, thetaBinSize, mixedModel.noMask.overTime);

PlotPolarDistribution(folderName, [fileName, '_relMaskAngles'], sum(relMaskCounts, 1), thetaBinSize);
PlotPolarDistribution(folderName, [fileName, '_relMaskAngles_basicModel'], sum(relMaskCounts, 1), thetaBinSize, basicModel.relMask.allTimes);
PlotPolarDistribution(folderName, [fileName, '_relMaskAngles_mixedModel'], sum(relMaskCounts, 1), thetaBinSize, mixedModel.relMask.allTimes);
PlotPolarDistributionOverTime(folderName, [fileName, '_relMaskAngles_overTime'], relMaskCounts, thetaBinSize);
PlotPolarDistributionOverTime(folderName, [fileName, '_relMaskAngles_basicModel_overTime'], relMaskCounts, thetaBinSize, basicModel.relMask.overTime);
PlotPolarDistributionOverTime(folderName, [fileName, '_relMaskAngles_mixedModel_overTime'], relMaskCounts, thetaBinSize, mixedModel.relMask.overTime);

PlotPolarDistribution(folderName, [fileName, '_peakMaskAngles'], sum(peakMaskCounts, 1), thetaBinSize);
PlotPolarDistribution(folderName, [fileName, '_peakMaskAngles_basicModel'], sum(peakMaskCounts, 1), thetaBinSize, basicModel.peakMask.allTimes);
PlotPolarDistribution(folderName, [fileName, '_peakMaskAngles_mixedModel'], sum(peakMaskCounts, 1), thetaBinSize, mixedModel.peakMask.allTimes);
PlotPolarDistributionOverTime(folderName, [fileName, '_peakMaskAngles_overTime'], peakMaskCounts, thetaBinSize);
PlotPolarDistributionOverTime(folderName, [fileName, '_peakMaskAngles_basicModel_overTime'], peakMaskCounts, thetaBinSize, basicModel.peakMask.overTime);
PlotPolarDistributionOverTime(folderName, [fileName, '_peakMaskAngles_mixedModel_overTime'], peakMaskCounts, thetaBinSize, mixedModel.peakMask.overTime);

PlotPolarDistribution(folderName, [fileName, '_relAndPeakMaskAngles'], sum(relAndPeakMaskCounts, 1), thetaBinSize);
PlotPolarDistribution(folderName, [fileName, '_relAndPeakMaskAngles_basicModel'], sum(relAndPeakMaskCounts, 1), thetaBinSize, basicModel.relAndPeakMask.allTimes);
PlotPolarDistribution(folderName, [fileName, '_relAndPeakMaskAngles_mixedModel'], sum(relAndPeakMaskCounts, 1), thetaBinSize, mixedModel.relAndPeakMask.allTimes);
PlotPolarDistributionOverTime(folderName, [fileName, '_relAndPeakMaskAngles_overTime'], relAndPeakMaskCounts, thetaBinSize);
PlotPolarDistributionOverTime(folderName, [fileName, '_relAndPeakMaskAngles_basicModel_overTime'], relAndPeakMaskCounts, thetaBinSize, basicModel.relAndPeakMask.overTime);
PlotPolarDistributionOverTime(folderName, [fileName, '_relAndPeakMaskAngles_mixedModel_overTime'], relAndPeakMaskCounts, thetaBinSize, mixedModel.relAndPeakMask.overTime);

close all;

end