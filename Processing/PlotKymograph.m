function PlotKymograph(folderName, fileName, counts, basicModel, mixedModel, angSpacing)
%% Create xData
xData = 0:angSpacing:(360 - angSpacing);
xDataShow = 0:30:(360 - 15);

%% Create yData1
counts = counts/sum(counts(:))*size(counts, 1);
yData1 = circshift(counts', length(xData)/4, 1);
yWeights = sum(counts, 2)/sum(counts(:))*size(counts, 1);
yWeights = circshift(yWeights', length(xData)/4);

%% Create yData2
nPoints = 1000;
xTemp = linspace(0, 2*pi, nPoints);
tArray = basicModel(:, 1); 
model = basicModel(:, 2:end);
yData2 = [];
for tIdx = 1:size(counts, 1)
    if any(tArray == tIdx)
        yTemp = VMMix_f_proportions(xTemp, model(tArray == tIdx, :));
    else
        yTemp = zeros(size(xTemp));
    end
    yData2 = [yData2; yTemp];
end
yData2 = circshift(yData2', length(xTemp)/4, 1).*yWeights*nPoints/length(xData);

%% Create yData3
xTemp = linspace(0, 2*pi, nPoints);
tArray = mixedModel(:, 1); 
model = mixedModel(:, 2:end);
yData3 = [];
for tIdx = 1:size(counts, 1)
    if any(tArray == tIdx)
        yTemp = VMMix_f_proportions(xTemp, model(tArray == tIdx, :));
    else
        yTemp = zeros(size(xTemp));
    end
    yData3 = [yData3; yTemp];
end
yData3 = circshift(yData3', length(xTemp)/4, 1).*yWeights*nPoints/length(xData);

%% Plot data
rmax = max(ceil((360/angSpacing)*max(counts, [], 2))/(360/angSpacing));

figure;
imagesc(1:size(yData1, 2), 1:length(xDataShow), yData1, [0 rmax]);
set(gca, 'YDir', 'normal');
set(gca, 'YTick', 1:length(xDataShow));
set(gca, 'YTickLabel', cellfun(@num2str, num2cell(mod(xDataShow + 89, 360) - 179), 'UniformOutput', false))
ylabel('Angle');
xlabel('Frame');
colorbar;
title(fileName, 'Interpreter', 'none');
print([folderName, fileName], '-dpng', '-r150');

figure;
imagesc(1:size(yData2, 2), 1:length(xDataShow), yData2, [0 rmax]);
set(gca, 'YDir', 'normal');
set(gca, 'YTick', 1:length(xDataShow));
set(gca, 'YTickLabel', cellfun(@num2str, num2cell(mod(xDataShow + 89, 360) - 179), 'UniformOutput', false))
ylabel('Angle');
xlabel('Frame');
colorbar;
title(fileName, 'Interpreter', 'none');
print([folderName, fileName, '_basicModel'], '-dpng', '-r150');

figure;
imagesc(1:size(yData3, 2), 1:length(xDataShow), yData3, [0 rmax]);
set(gca, 'YDir', 'normal');
set(gca, 'YTick', 1:length(xDataShow));
set(gca, 'YTickLabel', cellfun(@num2str, num2cell(mod(xDataShow + 89, 360) - 179), 'UniformOutput', false))
ylabel('Angle');
xlabel('Frame');
colorbar;
title(fileName, 'Interpreter', 'none');
print([folderName, fileName, '_mixedModel'], '-dpng', '-r150');
end