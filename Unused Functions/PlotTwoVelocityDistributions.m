function PlotTwoVelocityDistributions(xVec, yVec1, yVec2, fileName, xTick, xTickLabel)
figure;
xData = xVec(2:(end - 1));
xData = [xData; xData];
xData = [0; xData(:); max(xVec)];
yData1 = [yVec1; yVec1];
yData2 = [yVec2; yVec2];
yData1 = yData1(:)/sum(yData1(:)/2);
yData2 = yData2(:)/sum(yData2(:)/2);
plot(xData, yData1, 'linewidth', 2, 'Color', [3 0 2]/4);
set(gca, 'FontName', 'Arial');
hold on;
plot(xData, yData2, 'linewidth', 2, 'Color', [0 2 3]/4);
hold off;
xlabel(['Speed (', char(181), 'm/min)']);
ylabel('Fractional Count');
xlim([0 max(xVec)]);
set(gca, 'FontSize', 20);
ylim([0 0.4]);
set(gcf, 'position', get(gcf, 'position').*[1, 1, 0, 1] + [0, 0, 400, 0]);
set(gca, 'xTick', xTick, 'XTickLabel', xTickLabel);
drawnow;
saveas(gcf, fileName, 'svg');