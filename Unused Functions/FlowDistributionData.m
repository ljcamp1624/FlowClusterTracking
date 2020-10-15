%% Flow Distribution Data and Plots
function FlowDistributionData(fileParams)
%% Make Flow Distribution Data
fprintf('\n\n- - - Starting FlowDistributionData - - -\n');

%% Assign Folders
exportFolder = fileParams.exportFolder;
fileExportFolder = [exportFolder, ...
    filesep, 'FlowFigure', ...
    filesep];
if ~exist(fileExportFolder, 'dir')
    mkdir(fileExportFolder);
end

%% Calculate Full Image Distribution Data
histDataFileName = 'FlowDistributionData.mat'; 
if ~exist([fileExportFolder, histDataFileName], 'file')
    
    fprintf('- Calculating Full Image Distribution Data\n');
    
    % Load dependencies
    load([exportFolder, 'DifferenceImage.mat'], 'smoothDiffImage');
    load([exportFolder, 'OpticalFlow.mat'], 'vxMat', 'vyMat', 'relMat');
    load([exportFolder, 'FlowClusterTracks.mat'], 'clusterImPos', 'clusterImNeg', 'peakThresh');
    load([fileExportFolder, 'FigureAParams.mat'], 'FigureAParams');
    
    % Assign parameters
    thetaInDegrees = fileParams.thetaInDegrees;
    thetaInRadians = fileParams.thetaInRadians;
    cellMasks = FigureAParams.Masks;
    numCells = length(cellMasks);
    
    % Create variables
    [vxMat, vyMat] = RotateQuiver(vxMat, vyMat, thetaInDegrees, thetaInRadians);
    angMat = atan2(vyMat, vxMat);
    magMat = sqrt(vxMat.*vxMat + vyMat.*vyMat);
    relMat = imrotate(relMat, thetaInDegrees);
    relThresh = 10*median(relMat(:));
    relMask = relMat > relThresh;
    smoothDiffImage = imrotate(smoothDiffImage, thetaInDegrees);
    sz3 = size(smoothDiffImage, 3);
    posClusterMask = imrotate(clusterImPos > peakThresh, thetaInDegrees);
    negClusterMask = imrotate(clusterImNeg > peakThresh, thetaInDegrees);
    
    % Calculate distribution data
    tempRelMask = relMask(:, :, 1:sz3);
    tempAngList = angMat(tempRelMask);
    tempDiffImFac = 2*double(smoothDiffImage(tempRelMask) > 0) - 1;
    tempAngRelWeight = relMat(tempRelMask); tempAngRelWeight = tempAngRelWeight/sum(tempAngRelWeight);
    tempAngMagWeight = magMat(tempRelMask); tempAngMagWeight = tempAngMagWeight/sum(tempAngMagWeight);
    
    % Save output
    FlowDistributionData.FullAngList = tempAngList;
    FlowDistributionData.DifferenceImageFactor = tempDiffImFac;
    FlowDistributionData.ReliabilityWeight = tempAngRelWeight;
    FlowDistributionData.MagnitudeWeight = tempAngMagWeight;
    save([fileExportFolder, histDataFileName], 'FlowDistributionData', 'numCells', '-v7.3');
    
    for cellNum = 1:numCells
        
        fprintf(['  Calculating Distribution Data for Cell ', num2str(cellNum), ' of ', num2str(numCells), '\n']);
        
        % Calculate cell distribution data
        tempRelMask = relMask(:, :, 1:sz3) & cellMasks{cellNum};
        tempAngList = angMat(tempRelMask);
        tempDiffImFac = 2*double(smoothDiffImage(tempRelMask) > 0) - 1;
        tempAngRelWeight = relMat(tempRelMask); tempAngRelWeight = tempAngRelWeight/sum(tempAngRelWeight);
        tempAngMagWeight = magMat(tempRelMask); tempAngMagWeight = tempAngMagWeight/sum(tempAngMagWeight);
        FlowDistributionData.FullAngList = tempAngList;
        FlowDistributionData.DifferenceImageFactor = tempDiffImFac;
        FlowDistributionData.ReliabilityWeight = tempAngRelWeight;
        FlowDistributionData.MagnitudeWeight = tempAngMagWeight;
        
        % Calculate cell cluster distribution data
        tempRelMask = relMask(:, :, 1:sz3) & cellMasks{cellNum} & posClusterMask;
        tempAngList = angMat(tempRelMask);
        tempDiffImFac = 2*double(smoothDiffImage(tempRelMask) > 0) - 1;
        tempAngRelWeight = relMat(tempRelMask); tempAngRelWeight = tempAngRelWeight/sum(tempAngRelWeight);
        tempAngMagWeight = magMat(tempRelMask); tempAngMagWeight = tempAngMagWeight/sum(tempAngMagWeight);
        PosClusterFlowDistributionData.FullAngList = tempAngList;
        PosClusterFlowDistributionData.DifferenceImageFactor = tempDiffImFac;
        PosClusterFlowDistributionData.ReliabilityWeight = tempAngRelWeight;
        PosClusterFlowDistributionData.MagnitudeWeight = tempAngMagWeight;
        
        % Calculate cell cluster distribution data
        tempRelMask = relMask(:, :, 1:sz3) & cellMasks{cellNum} & negClusterMask;
        tempAngList = angMat(tempRelMask);
        tempDiffImFac = 2*double(smoothDiffImage(tempRelMask) > 0) - 1;
        tempAngRelWeight = relMat(tempRelMask); tempAngRelWeight = tempAngRelWeight/sum(tempAngRelWeight);
        tempAngMagWeight = magMat(tempRelMask); tempAngMagWeight = tempAngMagWeight/sum(tempAngMagWeight);
        NegClusterFlowDistributionData.FullAngList = tempAngList;
        NegClusterFlowDistributionData.DifferenceImageFactor = tempDiffImFac;
        NegClusterFlowDistributionData.ReliabilityWeight = tempAngRelWeight;
        NegClusterFlowDistributionData.MagnitudeWeight = tempAngMagWeight;
        
        % Save output
        histDataFileName = ['FlowDistributionData_Cell', num2str(cellNum), 'of', num2str(numCells), '.mat']; 
        save([fileExportFolder, histDataFileName], 'FlowDistributionData', 'PosClusterFlowDistributionData', 'NegClusterFlowDistributionData', '-v7.3');
                
    end
   
else
    fprintf('- Flow Distribution Data Located\n');
end