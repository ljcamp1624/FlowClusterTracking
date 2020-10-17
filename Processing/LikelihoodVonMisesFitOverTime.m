function newFitParams = LikelihoodVonMisesFitOverTime(angList, timeList, fitParams)
%% Calculate new fit parameters
timeArray = unique(timeList);
newFitParams = [];
for t = 1:length(timeArray)
    currAngList = angList(timeList == timeArray(t));
    currParams = fitParams(fitParams(:, 1) == timeArray(t), 2:6);
    currParams = LikelihoodVonMisesFit(angListInRadians(timeList == currTime), currParams);
    newFitParams = [newFitParams; [timeArray(t), currParams]];
end
end