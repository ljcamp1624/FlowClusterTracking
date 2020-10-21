%%  Parameter Movies with Tracks Function
%
%   Copyright (C) 2020 Leonard Campanello - All Rights Reserved
%   You may use, distribute, and modify this code under the terms of a
%   CC BY 4.0 License.
%
%   If you use, distribute, or modify this code, please cite
%   Lee*, Campanello*, et al. MBoC 2020
%   https://doi.org/10.1091/mbc.E19-11-0614
%
%   Written by Leonard Campanello
%   Available on https://github.com/ljcamp1624/OpticalFlowAnalysis
%
%   Direct all questions and correspondence to Leonard Campanello and
%   Wolfgang Losert at the University of Maryland:
%   ljcamp (at) umd (dot) edu
%   wlosert (at) umd (dot) edu
%
%%  Begin function
%
%   This function is called by ParameterMoviesScript.m
%
function CreateMovies_withTracks(exportFolder, fileName, movieCell, formatCell, tracks)
%%  Parse movieCell
movieCell = ParseMovieCell(movieCell, formatCell);

%%  Construct image
vpadSize = 5;
hpadSize = 5;
image = ConstructMovieCellImage(movieCell, vpadSize, hpadSize);
numImages = length(movieCell);

%%  Define tracking parameters
trackIDs = unique(tracks(:, 4));
numTracks = length(trackIDs);
cmapList = lines(length(trackIDs));

%%  Initialize figure
figure('WindowState', 'maximized');
imageAxis = imagesc(squeeze(image(:, :, 1, :)));
axis equal tight off;
trajectoryPoint = gobjects(numTracks, numImages);
trajectoryPath = gobjects(numTracks, numImages);
drawnow; 

%% Record movie
v = VideoWriter([exportFolder, fileName], 'MPEG-4');
v.FrameRate = 12;
open(v);

for frameNum = 1:size(image, 3)
    %% Update image
    set(imageAxis, 'CData', squeeze(image(:, :, frameNum, :)));
    
    %% Add or update current tracks
    currIDs = unique(tracks(tracks(:,3) == frameNum, 4));
    for idx = 1:length(currIDs)
        currID = currIDs(idx);
        currPath = tracks(tracks(:,4) == currID & tracks(:,3) <= frameNum, [1, 2]);
        if size(currPath, 1) == 1
            hold on;
            trajectoryPoint(trackIDs == currID) = scatter(currPath(:, 1), currPath(:, 2), 50, cmapList(trackIDs == currID, :), 'filled');
            trajectoryPath(trackIDs == currID) = plot(currPath(:, 1), currPath(:, 2), 'Color', cmapList(trackIDs == currID, :), 'LineWidth', 2);
            hold off;
        else
            set(trajectoryPoint(trackIDs == currID), 'XData', currPath(end, 1), 'YData', currPath(end, 2));
            set(trajectoryPath(trackIDs == currID), 'XData', currPath(:, 1), 'YData', currPath(:, 2));
        end
    end
    drawnow;
    
    %%  Record frame
    currFrame = getframe(gca);
    writeVideo(v, currFrame);

end
%% End recording
close(v);
close(gcf);

end