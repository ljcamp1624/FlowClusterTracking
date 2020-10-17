%%  Parameter Movies Function
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
function CreateMovies(exportFolder, fileName, movieCell, formatCell)
%%  Parse MovieCell
movieCell = ParseMovieCell(movieCell, formatCell);

%%  Construct Image
vpadSize = 5;
hpadSize = 5;
im = ConstructMovieCellImage(movieCell, vpadSize, hpadSize);

%%  Write Movie File
v = VideoWriter([exportFolder, fileName], 'MPEG-4');
v.FrameRate = 12;
open(v);
for frameNum = 1:size(im, 3)
    writeVideo(v, squeeze(im(:, :, frameNum, :)));
end
close(v);

end