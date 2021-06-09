function PlotPolarDistribution(folderName, fileName, counts, spacing, varargin)
%% Create xData
xData = (0:spacing:360) - spacing/2;
xData = xData(:);
xData = [xData(1:(end - 1)), xData(1:(end - 1)), xData(2:end)]';
xData = [xData(:); xData(end)];

%% Create yData
yData = counts/sum(counts(:));
yData = [zeros(size(yData(:))), yData(:), yData(:)]';
yData = [yData(:); 0];

%% Plot data
figure;
polarplot(xData*pi/180, yData, 'linewidth', 2, 'Color', [2 2 2]/4);
rmax = ceil((360/spacing)*max(yData(:)))/(360/spacing);
if rmax == 0
    rmax = 1;
end
rlim([0 rmax]);
if ~isempty(varargin)
    nPoints = 1000;
    xData2 = linspace(0, 2*pi, nPoints);
    yData2 = nPoints*VMMix_f_proportions(xData2, varargin{1})/(length(0:spacing:360) - 1);
    hold on;
    polarplot(xData2, yData2, 'k', 'linewidth', 1);
    hold off;
end
drawnow;
title(fileName, 'Interpreter', 'none');
print([folderName, fileName], '-dpng', '-r150');