function PlotDistribution(folderName, fileName, counts, bins, binUnit)
%% Create xData
xData = bins(:);
xData = [xData(1:(end - 1)), xData(1:(end - 1)), xData(2:end)]';
xData = [xData(:); xData(end)];

%% Create yData
yData = counts/sum(counts(:));
yData = [zeros(size(yData(:))), yData(:), yData(:)]';
yData = [yData(:); 0];

%% Plot data
figure;
plot(xData, yData, 'linewidth', 2, 'Color', [2 2 2]/4);
ymax = max(ceil(yData*5)/5);
ylim([0 ymax]);
drawnow;
title(fileName, 'Interpreter', 'none');
xlabel(binUnit);
ylabel('Probability');
print([folderName, fileName], '-dpng', '-r150');
end