function CalculateDifferenceImage(exportFolder, numFrames, origImage, smoothImage)

% Calculate Difference Image
origDiffImage = origImage(:, :, (1 + numFrames):end) - origImage(:, :, 1:(end - numFrames));
smoothDiffImage = smoothImage(:, :, (1 + numFrames):end) - smoothImage(:, :, 1:(end - numFrames));

% Save
save([exportFolder, 'DifferenceImage.mat'], 'origDiffImage', 'smoothDiffImage', '-v7.3');