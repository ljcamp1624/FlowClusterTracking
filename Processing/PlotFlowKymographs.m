function PlotFlowKymographs(folderName, fileName, angCounts, relMaskCounts, peakMaskCounts, relAndPeakMaskCounts, thetaBinSize, basicModel, mixedModel)

PlotKymograph(folderName, [fileName, '_allAngles_kymograph'], angCounts, basicModel.noMask.overTime, mixedModel.noMask.overTime, thetaBinSize);
PlotKymograph(folderName, [fileName, '_relMaskAngles_kymograph'], relMaskCounts, basicModel.relMask.overTime, mixedModel.relMask.overTime, thetaBinSize);
PlotKymograph(folderName, [fileName, '_peakMaskAngles_kymograph'], peakMaskCounts, basicModel.peakMask.overTime, mixedModel.peakMask.overTime, thetaBinSize);
PlotKymograph(folderName, [fileName, '_relAndPeakMaskAngles_kymograph'], relAndPeakMaskCounts, basicModel.relAndPeakMask.overTime, mixedModel.relAndPeakMask.overTime, thetaBinSize);
close all;

end