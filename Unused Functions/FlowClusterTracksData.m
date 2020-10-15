function FlowClusterTracksData(fileParams, mainAnalysisParams)
%% File Parameters
exportFolder = fileParams.exportFolder;
pxPerMicron = fileParams.pxPerMicron;
secBtwFrames = fileParams.secBtwFrames;
thetaInDegrees = fileParams.thetaInDegrees;
thetaInRadians = fileParams.thetaInRadians;
minBtwFrame = secBtwFrames/60;

%% Main Analysis Parameters
minTrackLength = mainAnalysisParams.minTrackLength;
trackSmoothNumNNs = mainAnalysisParams.trackSmoothNumNNs;

%% Define Folders
trackExportFolder = [exportFolder, ...
    filesep, 'TrackFigure', filesep];
if exist(trackExportFolder, 'dir')
else
    mkdir(trackExportFolder);
end

%% Check exist of FlowClusterTracksData
if exist([trackExportFolder, 'FlowClusterTracksData.mat'], 'file')
    return;
end

%% Load Files
load([exportFolder, 'OriginalImage.mat']);
load([exportFolder, 'FlowFigure', filesep, 'FigureAParams.mat']);
load([exportFolder, 'FlowClusterTracks.mat'], 'tracksPos', 'tracksNeg');
sz1 = size(OriginalImage.Image);
sz2 = size(FigureAParams.Masks{1});
numCells = length(FigureAParams.Masks);

%% Create Track Variables
allPosTracks =        RotateTracks(tracksPos, thetaInRadians, sz1, sz2);
longPosTracks =       ApplyMinTrackLength(allPosTracks, minTrackLength);
allSmoothPosTracks =  SmoothTracks(ApplyMinTrackLength(allPosTracks, 1 + 2*trackSmoothNumNNs), trackSmoothNumNNs);
longSmoothPosTracks = SmoothTracks(ApplyMinTrackLength(longPosTracks, 1 + 2*trackSmoothNumNNs), trackSmoothNumNNs);
allNegTracks =        RotateTracks(tracksNeg, thetaInRadians, sz1, sz2);
longNegTracks =       ApplyMinTrackLength(allNegTracks, minTrackLength);
allSmoothNegTracks =  SmoothTracks(ApplyMinTrackLength(allNegTracks, 1 + 2*trackSmoothNumNNs), trackSmoothNumNNs);
longSmoothNegTracks = SmoothTracks(ApplyMinTrackLength(longNegTracks, 1 + 2*trackSmoothNumNNs), trackSmoothNumNNs);

%% Calculate Velocities and Angles
[allPosVels, allPosAngs] = CalculateTrackData(allPosTracks, pxPerMicron, minBtwFrame);
[allNegVels, allNegAngs] = CalculateTrackData(allNegTracks, pxPerMicron, minBtwFrame);
[longPosVels, longPosAngs] = CalculateTrackData(longPosTracks, pxPerMicron, minBtwFrame);
[longNegVels, longNegAngs] = CalculateTrackData(longNegTracks, pxPerMicron, minBtwFrame);
[allSmoothPosVels, allSmoothPosAngs] = CalculateTrackData(allSmoothPosTracks, pxPerMicron, minBtwFrame);
[allSmoothNegVels, allSmoothNegAngs] = CalculateTrackData(allSmoothNegTracks, pxPerMicron, minBtwFrame);
[longSmoothPosVels, longSmoothPosAngs] = CalculateTrackData(longSmoothPosTracks, pxPerMicron, minBtwFrame);
[longSmoothNegVels, longSmoothNegAngs] = CalculateTrackData(longSmoothNegTracks, pxPerMicron, minBtwFrame);

%% Save Results
PosTracks.all = allPosTracks;
PosTracks.long = longPosTracks;
PosTracks.allSmooth = allSmoothPosTracks;
PosTracks.longSmooth = longSmoothPosTracks;
NegTracks.all = allNegTracks;
NegTracks.long = longNegTracks;
NegTracks.allSmooth = allSmoothNegTracks;
NegTracks.longSmooth = longSmoothNegTracks;
PosTrackVels.all = allPosVels;
PosTrackVels.long = longPosVels;
PosTrackVels.allSmooth = allSmoothPosVels;
PosTrackVels.longSmooth = longSmoothPosVels;
NegTrackVels.all = allNegVels;
NegTrackVels.long = longNegVels;
NegTrackVels.allSmooth = allSmoothNegVels;
NegTrackVels.longSmooth = longSmoothNegVels;
PosTrackAngs.all = allPosAngs;
PosTrackAngs.long = longPosAngs;
PosTrackAngs.allSmooth = allSmoothPosAngs;
PosTrackAngs.longSmooth = longSmoothPosAngs;
NegTrackAngs.all = allNegAngs;
NegTrackAngs.long = longNegAngs;
NegTrackAngs.allSmooth = allSmoothNegAngs;
NegTrackAngs.longSmooth = longSmoothNegAngs;
save([trackExportFolder, 'FlowClusterTracksData.mat'], 'PosTracks', 'NegTracks', 'PosTrackVels', 'NegTrackVels', 'PosTrackAngs', 'NegTrackAngs', 'numCells', 'minTrackLength', 'trackSmoothNumNNs');

%% Save by cell data
for cellNum = 1:numCells
    %% Find cell window
    currCellxIdx = FigureAParams.xIdx{cellNum};
    currCellyIdx = FigureAParams.yIdx{cellNum};
       
    %% Run for each track type
    for j = 1:8
        %% Identify which track variable to use
        if j == 1
            currTracks = allPosTracks;
        elseif j == 2
            currTracks = longPosTracks;
        elseif j == 3
            currTracks = allSmoothPosTracks;
        elseif j == 4
            currTracks = longSmoothPosTracks;
        elseif j == 5
            currTracks = allNegTracks;
        elseif j == 6
            currTracks = longNegTracks;
        elseif j == 7
            currTracks = allSmoothNegTracks;
        elseif j == 8
            currTracks = longSmoothNegTracks;
        end
        trackList = unique(currTracks(:, 4));
        
        %% Define tracks in window
        badIdx = unique(currTracks(...
            (currTracks(:, 1) < min(currCellyIdx)) | ...
            (currTracks(:, 2) < min(currCellxIdx)) | ...
            (currTracks(:, 1) > max(currCellyIdx)) | ...
            (currTracks(:, 2) > max(currCellxIdx)), 4));
        goodIdx = find(~ismember(trackList, badIdx));
        currCellTracks = currTracks(ismember(currTracks(:, 4), goodIdx), :);
        currCellTracks(:, 1) = currCellTracks(:, 1) - min(currCellyIdx) + 1;
        currCellTracks(:, 2) = currCellTracks(:, 2) - min(currCellxIdx) + 1;
        
        %% Calculate Velocities and Angles
        [currVels, currAngs] = CalculateTrackData(currCellTracks, pxPerMicron, minBtwFrame);
        
        %% Store Results
        if j == 1
            PosTracks.all = currTracks;
            PosTrackVels.all = currVels;
            PosTrackAngs.all = currAngs;
        elseif j == 2
            PosTracks.long = currTracks;
            PosTrackVels.long = currVels;
            PosTrackAngs.long = currAngs;
        elseif j == 3
            PosTracks.allSmooth = currTracks;
            PosTrackVels.allSmooth = currVels;
            PosTrackAngs.allSmooth = currAngs;
        elseif j == 4
            PosTracks.longSmooth = currTracks;
            PosTrackVels.longSmooth = currVels;
            PosTrackAngs.longSmooth = currAngs;
        elseif j == 5
            NegTracks.all = currTracks;
            NegTrackVels.all = currVels;
            NegTrackAngs.all = currAngs;
        elseif j == 6
            NegTracks.long = currTracks;
            NegTrackVels.long = currVels;
            NegTrackAngs.long = currAngs;
        elseif j == 7
            NegTracks.allSmooth = currTracks;
            NegTrackVels.allSmooth = currVels;
            NegTrackAngs.allSmooth = currAngs;
        elseif j == 8
            NegTracks.longSmooth = currTracks;
            NegTrackVels.longSmooth = currVels;
            NegTrackAngs.longSmooth = currAngs;
        end
    end
    %% Save Results
    save([trackExportFolder, 'FlowClusterTracksData_Cell', num2str(cellNum), 'of', num2str(numCells), '.mat'], 'PosTracks', 'NegTracks', 'PosTrackVels', 'NegTrackVels', 'PosTrackAngs', 'NegTrackAngs', 'minTrackLength', 'trackSmoothNumNNs');
    
end