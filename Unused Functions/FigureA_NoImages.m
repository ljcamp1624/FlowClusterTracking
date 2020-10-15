function FigureA_NoImages(fileExportFolder, FigureAParams, imageA, vxMat, vyMat, relMat, thetaInDegrees, thetaInRadians)
xIdxA = FigureAParams.xIdx;
yIdxA = FigureAParams.yIdx;
imageAmasks = cell(1, length(xIdxA));
imageAshow = cell(1, length(xIdxA));
vxMatShowA = cell(1, length(xIdxA));
vyMatShowA = cell(1, length(xIdxA));
relMatShowA = cell(1, length(xIdxA));
for i = 1:length(xIdxA)
    ix = xIdxA{i};
    iy = yIdxA{i};
    vxMatTemp = vxMat;
    vyMatTemp = vyMat;
    [vxMatShow, vyMatShow] = RotateQuiver(vxMatTemp, vyMatTemp, thetaInDegrees, thetaInRadians);
    vxMatShow = vxMatShow(ix, iy, :);
    vyMatShow = vyMatShow(ix, iy, :);
    vxMatShowA{i} = vxMatShow;
    vyMatShowA{i} = vyMatShow;
    imageAshow{i} = imageA(ix, iy, :);
    relMatShow = imrotate(relMat, thetaInDegrees);
    relMatShow = relMatShow(ix, iy, :);
    relMatShowA{i} = relMatShow;
    imageMask = zeros(size(imageA, 1), size(imageA, 2));
    imageMask(ix, iy) = 1;
    imageAmasks{i} = imageMask > 0;
end
FigureAImages.ImageA = imageAshow;
FigureAImages.vxMatA = vxMatShowA;
FigureAImages.vyMatA = vyMatShowA;
FigureAImages.relMatA = relMatShowA; %#ok<STRNU>
save([fileExportFolder, 'FigureAImages.mat'], 'FigureAImages');