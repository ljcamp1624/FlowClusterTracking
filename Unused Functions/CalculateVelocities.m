function vels = CalculateVelocities(tracks, pxPerMicron, timeBtwFrames)
    idxList = unique(tracks(:, 4));
    numTracks = cell(size(idxList));
    avgTrackVel = zeros(size(idxList));
    avgInstVel = zeros(size(idxList));
    for i = 1:length(idxList)
        currTracks = tracks(tracks(:,4) == idxList(i), 1:3); 
        velList = [];
        for j = 1:(size(currTracks, 1) - 1)
            p1 = currTracks(j, :); 
            p2 = currTracks(j + 1, :); 
            dist = norm(p2(1:2) - p1(1:2));
            time = p2(3) - p1(3);
            velList = [velList, dist/time];
        end
        numTracks{i} = velList/pxPerMicron/timeBtwFrames; 
        p1 = currTracks(1, :); 
        p2 = currTracks(end, :);
        dist = norm(p2(1:2) - p1(1:2));
        time = p2(3) - p1(3);
        avgTrackVel(i) = dist/time/pxPerMicron/timeBtwFrames;
        avgInstVel(i) = mean(velList)/pxPerMicron/timeBtwFrames;
    end
    vels.IDs = idxList; 
    vels.Velocities = numTracks; 
    vels.AvgVelocity = avgTrackVel';
    vels.AvgInstVelocity = avgInstVel';
end