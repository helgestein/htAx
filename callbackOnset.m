function callbackOnset(obj, evt, ECHandles)
%CALLBACKONSET calculates the onset potential from the selected CV curve

    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    lobfData = ECInfo.lobfData;
    genIndex = ECInfo.selectedPlotGenIndex;
    ECPlotInfo = ECInfo.ECPlotInfo;
    ECData = ECInfo.ECData;
    
    a1 = lobfData(genIndex, 1);
    a2 = lobfData(genIndex, 3);
    b1 = lobfData(genIndex, 2);
    b2 = lobfData(genIndex, 4);
    onset = (b2 - b1) / (a1 - a2);
    set(ECHandles.textOnsetPot, 'String', num2str(onset));
    ECPlotInfo(genIndex, 2) = onset;
    
    plotPotential = ECData(:, genIndex * 2 - 1);
    ECPlotInfo(genIndex, 3) = findClosestPot(onset, plotPotential);
    
    ECInfo.ECPlotInfo = ECPlotInfo;
    fECPlot.UserData = ECInfo;
end

