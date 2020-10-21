%%  Parse "MovieCell" Parameter
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
%   This function is called by CreateMovies*.m
%
function movieCell = ParseMovieCell(movieCell, formatCell)
for movieNum = 1:length(movieCell)
    if strcmp('BW', formatCell{movieNum})
        t = RenormalizeImage(movieCell{movieNum}, 1);
        movieCell{movieNum} = cat(4, t, t, t);
    elseif strcmp('R', formatCell{movieNum})
        t = RenormalizeImage(movieCell{movieNum}, 1);
        movieCell{movieNum} = cat(4, t, 0*t, 0*t);
    elseif strcmp('G', formatCell{movieNum})
        t = RenormalizeImage(movieCell{movieNum}, 1);
        movieCell{movieNum} = cat(4, 0*t, t, 0*t);
    elseif strcmp('B', formatCell{movieNum})
        t = RenormalizeImage(movieCell{movieNum}, 1);
        movieCell{movieNum} = cat(4, 0*t, 0*t, t);
    elseif strcmp('C', formatCell{movieNum})
        t = RenormalizeImage(movieCell{movieNum}, 1);
        movieCell{movieNum} = cat(4, 0*t, t, t);
    elseif strcmp('M', formatCell{movieNum})
        t = RenormalizeImage(movieCell{movieNum}, 1);
        movieCell{movieNum} = cat(4, t, 0*t, t);
    elseif strcmp('Y', formatCell{movieNum})
        t = RenormalizeImage(movieCell{movieNum}, 1);
        movieCell{movieNum} = cat(4, t, t, 0*t);
    elseif strcmp('RedBlue', formatCell{movieNum})
        t = double(movieCell{movieNum});
        cmap = RedBlueVaryingScale(256, min(t(:)), max(t(:)));
        t = im2RGB(t, cmap, min(t(:)), max(t(:)));
        movieCell{movieNum} = t;
    elseif strcmp('HSV', formatCell{movieNum})
        rot = pi;
        t1 = mod(movieCell{movieNum}{1} + rot, 2*pi)/2/pi;
        t2 = movieCell{movieNum}{2}/max(movieCell{movieNum}{2}(:));
        cmap = flipud(hsv(256));
        t1 = im2RGB(t1, cmap, 0, 1);
        movieCell{movieNum} = 1 - t2.*(1 - t1);
    end
end
end