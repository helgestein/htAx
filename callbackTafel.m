function callbackTafel(obj, evt, ECHandles)
%CALLBACKTAFEL calculates the tafel slope from the selected CV curve

    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    lobfData = ECInfo.lobfData;
    genIndex = ECInfo.selectedPlotGenIndex;
    ECPlotInfo = ECInfo.ECPlotInfo;
    
    tafelSlope = 1 / lobfData(genIndex, 3);
    ECPlotInfo(genIndex, 1) = tafelSlope;
    set(ECHandles.textTafel, 'String', num2str(tafelSlope));
    
    ECInfo.ECPlotInfo = ECPlotInfo;
    fECPlot.UserData = ECInfo;
end

