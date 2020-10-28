function PlotPolarDistributionOverTime(folderName, fileName, counts, spacing, varargin)
%% Create xData
xData = (0:spacing:360) - spacing/2;
xData = xData(:);
xData = [xData(1:(end - 1)), xData(1:(end - 1)), xData(2:end)]';
xData = [xData(:); xData(end)];

%% Create yData
weightArray = sum(counts, 2)/sum(counts(:))*size(counts, 1);
counts = counts/sum(counts(:))*size(counts, 1);

%%  Process varargin
if ~isempty(varargin)
    nPoints = 1000;
    xData2 = linspace(0, 2*pi, nPoints);
    timeArray = varargin{1}(:, 1);
    modelArray = varargin{1}(:, 2:end);
end

%% Plot data
figure;
rmax = max(ceil((360/spacing)*max(counts, [], 2))/(360/spacing));
v = VideoWriter([folderName, fileName], 'MPEG-4');
v.FrameRate = 12;
open(v);
for frameNum = 1:size(counts, 1)
    yData = counts(frameNum, :);
    yData = [zeros(size(yData(:))), yData(:), yData(:)]';
    yData = [yData(:); 0];
    polarplot(xData*pi/180, yData, 'linewidth', 2, 'Color', [2 2 2]/4);
    rlim([0 rmax]);
    if ~isempty(varargin)
        if any(timeArray == frameNum)
            yData2 = weightArray(frameNum)*nPoints*VMMix_f_proportions(xData2, modelArray(timeArray == frameNum, :))/(length(0:spacing:360) - 1);
            hold on;
            polarplot(xData2, yData2, 'k', 'linewidth', 1);
            hold off;
        end
    end
    title(fileName, 'Interpreter', 'none');
    drawnow;
    f = getframe(gcf);
    writeVideo(v, f.cdata);
end
close(v);
end