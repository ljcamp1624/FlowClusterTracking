function PlotAngleDistribution(xVec, yVec1, yVec2, angRange, filename)
%% Create xData
xData = xVec;
xData = [xData; xData];
xData = xData(2:(end - 1));

%% Create yData
yData1 = yVec1;
yData1 = [yData1; yData1];
yData1 = yData1(:)/sum(yData1(:)/2);
if ~isempty(yVec2)
    yData2 = yVec2;
    yData2 = [yData2; yData2];
    yData2 = yData2(:)/sum(yData2(:)/2);
end

%% Plot data
figure;
if ~isempty(yVec2)
    polarplot(xData*pi/180, yData1, 'linewidth', 2, 'Color', [3 0 2]/4);
    hold on;
    polarplot(xData*pi/180, yData2, 'linewidth', 2, 'Color', [0 2 3]/4);
    hold off;
else
    polarplot(xData*pi/180, yData1, 'linewidth', 2, 'Color', [2 2 2]/4);
end
if strcmp(angRange, '90') == 1
    set(gca, 'XTick', 0:10:max(xData));
    set(gca, 'XTickLabel', {'0', '', '', '30', '', '', '60', '', '', '90'});
elseif strcmp(angRange, '360') == 1
    rlim([0 0.06]);
    set(gca, 'RTick', 0:.02:0.1);
end
set(gca, 'FontSize', 20);
rlim([0 0.1]);
drawnow;
saveas(gcf, filename, 'svg');