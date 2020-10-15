function [trackAngs, instTrackAngs] = AccumulateTrackAngles(tracks)
idxs = unique(tracks(:, 4));
trackAngs = [];
instTrackAngs = [];
for idx = 1:length(idxs)
    
    currIdx = idxs(idx);
    currTrack = tracks(tracks(:, 4) == currIdx, 1:3);
    allDiffs = currTrack(2:end, :) - currTrack(1:(end - 1), :);
    allAngs = atan2(allDiffs(:, 2), allDiffs(:, 1));
    trackDiff = currTrack(end, :) - currTrack(1, :);
    trackAng = atan2(trackDiff(2), trackDiff(1));
    if strcmp(angRange, '90') == 1
        allAngs = asin(sin(acos(cos(allAngs))));
        trackAng = asin(sin(acos(cos(trackAng))));
    end
    allAngList = [allAngList(:); allAngs(:)];
    trackAngList = [trackAngList(:); trackAng(:)];
    allAngs = mod(180*allAngs/pi, 360);
    trackAng = mod(180*trackAng/pi, 360);
    if strcmp(angRange, '90') == 1
        allCounts = histcounts(allAngs, 0:angStepSize:90);
        trackCount = histcounts(trackAng, 0:angStepSize:90);
    elseif strcmp(angRange, '360') == 1
        allCounts = histcounts(allAngs, 0:angStepSize:360);
        trackCount = histcounts(trackAng, 0:angStepSize:360);
    end
    allCountList = allCountList + allCounts;
    trackCountList = trackCountList + trackCount;
end