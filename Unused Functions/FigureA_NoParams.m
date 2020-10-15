function FigureA_NoParams(fileExportFolder, imageA, vxMat, vyMat, relMat, thetaInDegrees, thetaInRadians)
h = figure;
dispImage = mean(double(imageA), 3);
dispImage = RenormalizeImage(dispImage, .1);
dispImage(dispImage(:) == 0) = mean(dispImage(dispImage(:) ~= 0));
imagesc(dispImage);
axis equal;
disp(' ');
numMasks = input('How many cell masks should be created? ');
imageAmasks = cell(1, numMasks);
xIdxA = cell(1, numMasks);
yIdxA = cell(1, numMasks);
for i = 1:numMasks
    %% get the mask
    imageAmasks{i} = roipoly;
    [ix, iy] = find(imageAmasks{i});
    maskWidth = max(max(ix) - min(ix), max(iy) - min(iy));
    ix = min(ix):(min(ix) + maskWidth);
    iy = min(iy):(min(iy) + maskWidth);
    ix = ix + min(0, size(imageA, 1) - max(ix));
    iy = iy + min(0, size(imageA, 2) - max(iy));
    %% plot the mask
    hold on;
    plot(iy, min(ix) + zeros(size(iy)), 'r', 'linewidth', 1.5);
    plot(iy, max(ix) + zeros(size(iy)), 'r', 'linewidth', 1.5);
    plot(min(iy) + zeros(size(ix)), ix, 'r', 'linewidth', 1.5);
    plot(max(iy) + zeros(size(ix)), ix, 'r', 'linewidth', 1.5);
    hold off;
    %% save the mask
    xIdxA{i} = ix;
    yIdxA{i} = iy;
end
close(h);
FigureAParams.xIdx = xIdxA;
FigureAParams.yIdx = yIdxA;
FigureAParams.Masks = imageAmasks;
save([fileExportFolder, 'FigureAParams.mat'], 'FigureAParams');
FigureA_NoImages(fileExportFolder, FigureAParams, imageA, vxMat, vyMat, relMat, thetaInDegrees, thetaInRadians);