function callbackPrintEC(obj, evt, ternHandles, ECHandles)
%CALLBACKPRINTEC exports the calculated tafel slopes and onset potentials 
%to a user-selected file

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    ECPlotInfo = ECInfo.ECPlotInfo;
    
    export.compA = ternInfo.valsCompA;
    export.compB = ternInfo.valsCompB;
    export.compC = ternInfo.valsCompC;
    export.xCoords = ternInfo.xCoords;
    export.yCoords = ternInfo.yCoords;
    export.onsetPotential = ECPlotInfo(:, 1);
    export.tafelSlope = ECPlotInfo(:, 2);
    
    [file, path] = uigetfile;
    exportFile = strcat(path, file);
    
    save(exportFile, '-struct', 'export');
    msgbox('EC Analysis Exported');
end

