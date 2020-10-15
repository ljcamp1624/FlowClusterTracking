function FlowClusterTracksMovies(fileParams)
%% File Parameters
exportFolder = fileParams.exportFolder;
pxPerMicron = fileParams.pxPerMicron;
secBtwFrames = fileParams.secBtwFrames;

%% Define folders
flowExportFolder = [exportFolder, ...
    filesep, 'FlowFigure', ...
    filesep];
trackExportFolder = [exportFolder, ...
    filesep, 'TrackFigure', ...
    filesep];

%% Check if movie exists
fileName = 'ClusterTrackMovie';
if exist([trackExportFolder, fileName, '.mp4'], 'file')
    return;
end

%% Load Files

% Flow Figure Data
load([flowExportFolder, 'ImageA.mat'], 'imageA');
load([flowExportFolder, 'FigureAParams.mat'], 'FigureAParams');
load([flowExportFolder, 'FigureAImages.mat'], 'FigureAImages');
numCells = length(FigureAParams.Masks);

% Cluster Track Data
load([trackExportFolder, 'FlowClusterTracksData.mat'], 'PosTracks');

%% Plot cell tracks
clusterTrackImage = uint8(255*RenormalizeImage(imageA, 0.25));
PlotClusterTrackMovie(trackExportFolder, fileName, clusterTrackImage, PosTracks.longSmooth, pxPerMicron, secBtwFrames);

for cellNum = 1:numCells
    %% Define tracks in window
    currCellImage = FigureAImages.ImageA{cellNum};
    load([trackExportFolder, 'FlowClusterTracksData_Cell', num2str(cellNum), 'of', num2str(numCells), '.mat'], 'PosTracks');
    currCellTracks = PosTracks.longSmooth;
    currCellTracks(:, 1) = currCellTracks(:, 1) - min(FigureAParams.yIdx{cellNum}) + 1;
    currCellTracks(:, 2) = currCellTracks(:, 2) - min(FigureAParams.xIdx{cellNum}) + 1;
    
    %% Plot Tracks
    fileName = ['ClusterTrackMovie - PosClusters - Cell ', num2str(cellNum), 'of', num2str(numCells)];
    if ~exist([trackExportFolder, fileName, '.mp4'], 'file')
        continue;
    end
    clusterTrackImage = uint8(255*RenormalizeImage(currCellImage, 0.25));
    PlotClusterTrackMovie(trackExportFolder, fileName, clusterTrackImage, currCellTracks, pxPerMicron, secBtwFrames);
    
end