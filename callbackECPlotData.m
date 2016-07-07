function callbackECPlotData(obj, evt, dataSection, ternHandles, specHandles, ECHandles)
%CALLBACKECPLOTDATA allows the user to choose which parts of the CV data
%(increasing potential, decreasing potential, both) to use

    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    ECPlotInfo = ECInfo.ECPlotInfo;
    ECPlotInfo(ECInfo.selectedPlotGenIndex, 4) = dataSection;
    ECInfo.ECPlotInfo = ECPlotInfo;
    fECPlot.UserData = ECInfo;
    
    plotECData(ternHandles, specHandles, ECHandles);

end

