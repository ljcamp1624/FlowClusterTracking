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
function CreateMovies_withFlow(exportFolder, fileName, movieCell, formatCell, vxMat, vyMat, magMat, magMat2, relMat, relThresh)
%%  Parse movieCell
movieCell = ParseMovieCell(movieCell, formatCell);

%%  Construct image
vpadSize = 5;
hpadSize = 5;
image = ConstructMovieCellImage(movieCell, vpadSize, hpadSize);

%%  Define optical flow
flowSpacing = 5;
[vxMatShow, vyMatShow, relMatShow] = DeclutterQuiver(flowSpacing*vxMat.*magMat2./magMat, flowSpacing*vyMat.*magMat2./magMat, relMat, flowSpacing);
flowMask = relMatShow > relThresh;

%%  Initialize figure
figure('WindowState', 'maximized');
imageAxis = imagesc(squeeze(image(:, :, 1, :)));
axis equal tight off;
set(gcf, 'position', [1 1 1500 900]);
hold on;
quiverObject = quiver(-100, -100, 0, 0, 0, 'g', 'LineWidth', 1);
hold off;
drawnow;

%% Record movie
v = VideoWriter([exportFolder, fileName], 'MPEG-4');
v.FrameRate = 12;
open(v);

for frameNum = 1:size(image, 3)
    %% Update image
    set(imageAxis, 'CData', squeeze(image(:, :, frameNum, :)));
    mask = flowMask(:, :, frameNum);
    [ix, iy] = find(mask);
    uVec = vxMatShow(:, :, frameNum);
    vVec = vyMatShow(:, :, frameNum);
    [vVec, uVec] = CutQuiver(vVec, uVec);
    set(quiverObject, 'XData', iy, 'YData', ix, 'UData', vVec(mask(:)), 'VData', uVec(mask(:)));
    drawnow;
    
    %%  Record frame
    currFrame = getframe(gca);
    writeVideo(v, currFrame);
    
end
%% End recording
close(v);
close(gcf);

end