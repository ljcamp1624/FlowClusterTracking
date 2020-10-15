function cmap = PinkGreenColormap(numColors)
vec = linspace(0, 1-(1/numColors), floor(numColors/2))';
cmap = [vec, ones(size(vec)), vec; ...
    ones(mod(numColors, 2), 3); ...
    ones(size(vec)), flipud(vec), ones(size(vec))];