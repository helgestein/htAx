function callbackResetECCalcs(obj, evt, ECHandles)
%CALLBACKRESETECCALCS deletes the calculated tafel slope and onset
%potential for the selected CV curve

    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    ECPlotInfo = ECInfo.ECPlotInfo;
    genIndex = ECInfo.selectedPlotGenIndex;
    
    set(ECHandles.textTafel, 'String', '0');
    set(ECHandles.textOnsetPot, 'String', '0');
    
    ECPlotInfo(genIndex, 1) = 0;
    ECPlotInfo(genIndex, 2) = 0;
    ECPlotInfo(genIndex, 3) = 0;
    
    ECInfo.ECPlotInfo = ECPlotInfo;
    fECPlot.UserData = ECInfo;

end

