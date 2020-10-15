%% Make Flow Figure Data
function FlowFigureData(fileParams)
%% Start FlowFigureData Script
fprintf('\n\n- - - Starting FlowFigureData - - -\n\n');

%% File Parameters
exportFolder = fileParams.exportFolder;
thetaInDegrees = fileParams.thetaInDegrees;
thetaInRadians = fileParams.thetaInRadians;
fileExportFolder = [exportFolder, ...
    filesep, 'FlowFigure', ...
    filesep];

%% Create Folder
if exist(fileExportFolder, 'dir')
else
    mkdir(fileExportFolder);
end

%% Full Image
if exist([fileExportFolder, 'ImageA.mat'], 'file')
    fprintf('- Figure Image Located\n');
else
    fprintf('- Creating First Figure Image\n');
    fprintf('  Loading Original Image\n');
    load([exportFolder, 'OriginalImage.mat'], 'OriginalImage');
    actinImage = OriginalImage.Image(:, :, :, OriginalImage.ActinChannel);
    imageA = imrotate(double(actinImage), thetaInDegrees);
    imageA = uint16(imageA);
    fprintf('  Saving First Figure Image\n');
    save([fileExportFolder, 'ImageA.mat'], 'imageA');
end

%% "Image A" (first mask)
if exist([fileExportFolder, 'FigureAImages.mat'], 'file')
    %% Params and Images
    fprintf('- Figure A Images and Parameters Located\n');
elseif exist([fileExportFolder, 'FigureAParams.mat'], 'file')
    %% Load Params
    fprintf('- Figure A Parameters Located\n');
    fprintf('  Loading Figure A Parameters\n');
    load([fileExportFolder, 'FigureAParams.mat'], 'FigureAParams');
    fprintf('  Loading First Figure Image\n');
    load([fileExportFolder, 'ImageA.mat'], 'imageA');
    fprintf('  Loading Optical Flow Vector Images\n');
    load([exportFolder, 'OpticalFlow.mat'], 'vxMat', 'vyMat', 'relMat');
    %% Create and Load Images
    fprintf('  Creating Figure A Images\n');
    FigureA_NoImages(fileExportFolder, FigureAParams, imageA, vxMat, vyMat, relMat, thetaInDegrees, thetaInRadians)
else
    %% Create and Load Params and Images
    fprintf('- Loading First Figure Image\n');
    load([fileExportFolder, 'ImageA.mat'], 'imageA');
    fprintf('  Loading Optical Flow Vector Images\n');
    load([exportFolder, 'OpticalFlow.mat'], 'vxMat', 'vyMat', 'relMat');
    fprintf('  Creating Figure A Images and Parameters\n');
    FigureA_NoParams(fileExportFolder, imageA, vxMat, vyMat, relMat, thetaInDegrees, thetaInRadians)
end

end