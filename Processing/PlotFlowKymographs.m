function PlotFlowKymographs(folderName, fileName, angCounts, relMaskCounts, peakMaskCounts, relAndPeakMaskCounts, thetaBinSize, basicModel, mixedModel)

if sum(angCounts(:)) > 0
    PlotKymograph(folderName, [fileName, '_allAngles_kymograph'], angCounts, basicModel.noMask.overTime, mixedModel.noMask.overTime, thetaBinSize);
end
if sum(relMaskCounts(:)) > 0
    PlotKymograph(folderName, [fileName, '_relMaskAngles_kymograph'], relMaskCounts, basicModel.relMask.overTime, mixedModel.relMask.overTime, thetaBinSize);
end
if sum(peakMaskCounts(:)) > 0
    PlotKymograph(folderName, [fileName, '_peakMaskAngles_kymograph'], peakMaskCounts, basicModel.peakMask.overTime, mixedModel.peakMask.overTime, thetaBinSize);
end
if sum(relAndPeakMaskCounts(:)) > 0
    PlotKymograph(folderName, [fileName, '_relAndPeakMaskAngles_kymograph'], relAndPeakMaskCounts, basicModel.relAndPeakMask.overTime, mixedModel.relAndPeakMask.overTime, thetaBinSize);
end
close all;

end