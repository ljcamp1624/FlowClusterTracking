%   Copyright (C) 2020 Leonard Campanello - All Rights Reserved
%   You may use, distribute, and modify this code under the terms of a 
%   CC BY 4.0 License. 
%
%   If you use, distribute, or modify this code, please cite
%   Lee*, Campanello*, et al. MBoC 2020
%   https://doi.org/10.1091/mbc.E19-11-0614
%
%   Written by Leonard Campanello
%   Updated 10-1-2020
%
%   Direct all questions and correspondence to Wolfgang Losert at the University of Maryland: 
%   wlosert (at) umd (dot) edu


% File Location Parameters:
fileName		% The name of the image file. This codes assumes a multistack, single-channel tif.
importFolder 	% The folder where the input file is located. "importFolder" must end in a file delimiter (i.e., / or \).
exportFolder	% The folder where the output should be saved. "exportFolder" must end in a file delimiter (i.e., / or \).

% Image Parameters:
imageUnit		% The unit used to measure length in the image (e.g., meter, micron).
pxPerUnit		% The number of pixels per the above unit in the image. Note- this is "pixels PER unit"; i.e., the number of pixels that comprise a single unit.
timeUnit		% The unit used to measure time in the image (e.g., seconds, minutes).
timeBtwFrames	% Time (in timeUnit units) between two frames.

% Analysis Parameters (Optical Flow):
flowSpatialSig  % Spatial sigma (in pixels) of the gaussian derivative used to calculate spatial gradients in the image for calculating optical flow.
flowTimeSig     % Temporal sigma (in frames) of the gaussian derivative used to calculate time gradients in the image for calculating optical flow.
windowSig		% Spatial sigma (in pixels) of the gaussian weight matrix used for calculating optical flow.

% Analysis Parameters (Clustering)
smoothSpatialSig	% Spatial sigma (in pixels) of the gaussian used to smooth the image before calculating optical flow.
smoothTimeSig		% Temporal sigma (in frames) of the gaussian used to smooth the image before calculating optical flow.
diffTimeSig         % Temporal sigma (in frames) of the gaussian derivative used to calculate the difference image for flow clustering.

% Analysis Parameters (Tracking)
clusterRad		% Spatial sigma (in pixels) of the gaussian weight matrix used to quantify how "similarly oriented" vectors are.
peakThresh		% (*Crocker-Grier Tracking input) The threshold of the cluster image which is used to identify where peaks that should be tracked.
peakSize		% (*Crocker-Grier Tracking input) The input to "pkfnd.m" to define the diameter of a tracked particle. Should be chosen carefully.
maxDisp			% (*Crocker-Grier Tracking input) The input to "track.m" to determine the maximum displacement that a particle can travel while still being tracked.

% Processing Parameters (Postprocessing)
minTrackLength		% Remove tracks that are not long enough (in frames) to be considered "real tracks". Note- both the original and "long" tracks are both stored separately.
trackSmoothNumNNs	% The number of one-way nearest neighbors that should be averaged together during track smoothing.



*The Crocker-Grier Tracking code can be found here: http://site.physics.georgetown.edu/matlab/