function [velList, angList, velCounts, angCounts] = CalculateVelocityCounts(velFac, velBins, angBinSize, angBins, diffMat)

if isempty(diffMat)
    velList = [];
    angList = [];
    velCounts = [];
    angCounts = [];
    return;
end

velList = [velFac*sqrt(diffMat(:, 1).^2 + diffMat(:, 2).^2)./diffMat(:, 3), diffMat(:, 5:6)];
angList = [mod(diffMat(:, 4)*180/pi + angBinSize/2, 360) - angBinSize/2, diffMat(:, 5:6)];

timeArray = unique(diffMat(:, 5));
velCounts = [];
angCounts = [];
for tIdx = 1:length(timeArray)
    currTime = timeArray(tIdx);
    velCounts = [velCounts; [currTime, histcounts(velList(velList(:, 2) == currTime, 1), velBins)]];
    angCounts = [angCounts; [currTime, histcounts(angList(angList(:, 2) == currTime, 1), angBins)]];
end

end