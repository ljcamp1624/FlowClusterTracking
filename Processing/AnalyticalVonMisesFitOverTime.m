function fitParams = AnalyticalVonMisesFitOverTime(angList, timeList)
timeArray = unique(timeList);
fitParams = [];
for t = 1:length(timeArray)
    currAngList = angList(timeList == timeArray(t));
    currParams = AnalyticalVonMisesFit(currAngList);
    fitParams = [fitParams; [timeArray(t), currParams]];
end
end