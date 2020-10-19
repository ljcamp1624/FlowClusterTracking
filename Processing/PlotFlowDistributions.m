function PlotFlowDistributions(folderName, fileName, angCounts, relMaskCounts, peakMaskCounts, thetaBinSize, basicModel, mixedModel)

PlotDistribution(folderName, [fileName, '_allAngles'], sum(angCounts, 1), thetaBinSize);
PlotDistribution(folderName, [fileName, '_allAngles_basicModel'], sum(angCounts, 1), thetaBinSize, basicModel.noMask.allTimes);
PlotDistribution(folderName, [fileName, '_allAngles_mixedModel'], sum(angCounts, 1), thetaBinSize, mixedModel.noMask.allTimes);
PlotDistributionOverTime(folderName, [fileName, '_allAngles_overTime'], angCounts, thetaBinSize);
PlotDistributionOverTime(folderName, [fileName, '_allAngles_basicModel_overTime'], angCounts, thetaBinSize, basicModel.noMask.overTime);
PlotDistributionOverTime(folderName, [fileName, '_allAngles_mixedModel_overTime'], angCounts, thetaBinSize, mixedModel.noMask.overTime);

PlotDistribution(folderName, [fileName, '_relMaskAngles'], sum(relMaskCounts, 1), thetaBinSize);
PlotDistribution(folderName, [fileName, '_relMaskAngles_basicModel'], sum(relMaskCounts, 1), thetaBinSize, basicModel.relMask.allTimes);
PlotDistribution(folderName, [fileName, '_relMaskAngles_mixedModel'], sum(relMaskCounts, 1), thetaBinSize, mixedModel.relMask.allTimes);
PlotDistributionOverTime(folderName, [fileName, '_relMaskAngles_overTime'], relMaskCounts, thetaBinSize);
PlotDistributionOverTime(folderName, [fileName, '_relMaskAngles_basicModel_overTime'], relMaskCounts, thetaBinSize, basicModel.relMask.overTime);
PlotDistributionOverTime(folderName, [fileName, '_relMaskAngles_mixedModel_overTime'], relMaskCounts, thetaBinSize, mixedModel.relMask.overTime);

PlotDistribution(folderName, [fileName, '_peakMaskAngles'], sum(peakMaskCounts, 1), thetaBinSize);
PlotDistribution(folderName, [fileName, '_peakMaskAngles_basicModel'], sum(peakMaskCounts, 1), thetaBinSize, basicModel.peakMask.allTimes);
PlotDistribution(folderName, [fileName, '_peakMaskAngles_mixedModel'], sum(peakMaskCounts, 1), thetaBinSize, mixedModel.peakMask.allTimes);
PlotDistributionOverTime(folderName, [fileName, '_peakMaskAngles_overTime'], peakMaskCounts, thetaBinSize);
PlotDistributionOverTime(folderName, [fileName, '_peakMaskAngles_basicModel_overTime'], peakMaskCounts, thetaBinSize, basicModel.peakMask.overTime);
PlotDistributionOverTime(folderName, [fileName, '_peakMaskAngles_mixedModel_overTime'], peakMaskCounts, thetaBinSize, mixedModel.peakMask.overTime);