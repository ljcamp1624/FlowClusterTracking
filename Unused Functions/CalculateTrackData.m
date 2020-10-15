function [vels, angs] = CalculateTrackData(tracks, pxPerMicron, timeBtwFrames)
%% Identify track indices
idxList = unique(tracks(:, 4));

%% Define lists
velList = cell(size(idxList));
avgInstVel = zeros(size(idxList));
avgVel = zeros(size(idxList));
angList = cell(size(idxList));
trackAngs = zeros(size(idxList));

%%
for i = 1:length(idxList)
    currTrack = tracks(tracks(:,4) == idxList(i), 1:3);
    
    r1 = currTrack(1:(end - 1), 1:2);
    r2 = currTrack(2:end, 1:2);
    dt1 = currTrack(2:end, 3) - currTrack(1:(end - 1), 3);
    dist1 = sqrt(sum((r2 - r1).^2, 2));
    vel1 = dist1./dt1;
    
    velList{i} = vel1/pxPerMicron/timeBtwFrames;
    avgInstVel(i) = mean(vel1)/pxPerMicron/timeBtwFrames;
    angList{i} = atan2(r2(:, 2) - r1(:, 2), r2(:, 1) - r1(:, 1))*180/pi;
    
    r1 = currTrack(1, 1:2);
    r2 = currTrack(end, 1:2);
    dt2 = currTrack(end, 3) - currTrack(1, 3);
    dist2 = sqrt(sum((r2 - r1).^2));
    vel2 = dist2./dt2;
    
    avgVel(i) = vel2/pxPerMicron/timeBtwFrames;
    trackAngs(i) = atan2(r2(2) - r1(2), r2(1) - r1(1))*180/pi;
end
vels.IDs = idxList;
vels.Velocities = velList;
vels.AvgInstVelocity = avgInstVel;
vels.AvgVelocity = avgVel;
angs.IDs = idxList;
angs.Angles = angList;
angs.AvgAngle = trackAngs;
% pers.IDs = idxList;
