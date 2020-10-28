function PlotDistributionOverTime(folderName, fileName, counts, bins, binUnit)
%% Create xData
xData = bins(:);
xData = [xData(1:(end - 1)), xData(1:(end - 1)), xData(2:end)]';
xData = [xData(:); xData(end)];

%% Create yData
weightArray = sum(counts, 2)/sum(counts(:))*size(counts, 1);
counts = counts/sum(counts(:))*size(counts, 1);

%% Plot data
figure;
ymax = max(ceil(max(counts, [], 2)*5)/5);
v = VideoWriter([folderName, fileName], 'MPEG-4');
v.FrameRate = 12;
open(v);
for frameNum = 1:size(counts, 1)
    yData = counts(frameNum, :);
    yData = [zeros(size(yData(:))), yData(:), yData(:)]';
    yData = [yData(:); 0];
    plot(xData, yData, 'linewidth', 2, 'Color', [2 2 2]/4);
    ylim([0 ymax]);
    title(fileName, 'Interpreter', 'none');
    xlabel(binUnit);
    ylabel('Probability');
    drawnow;
    f = getframe(gcf);
    writeVideo(v, f.cdata);
end
close(v);
end