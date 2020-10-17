function PlotAngleDistribution(xVec, yVec1, angRange, filename)
%% Create xData
xData = xVec;
xData = [xData; xData];
xData = xData(2:(end - 1));

%% Create yData
yData1 = yVec1;
yData1 = [yData1; yData1];
yData1 = yData1(:)/sum(yData1(:)/2);

%% Plot data
figure;
    polarplot(xData*pi/180, yData1, 'linewidth', 2, 'Color', [2 2 2]/4);
    rlim([0 0.06]);
    set(gca, 'RTick', 0:.02:0.1);
set(gca, 'FontSize', 20);
rlim([0 0.1]);
drawnow;
saveas(gcf, filename, 'svg');