function callbackPrintEC(obj, evt, ternHandles, ECHandles)
%CALLBACKPRINTEC prints the calculated tafel slopes and onset potentials to
%a user-selected file

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    compA = ternInfo.valsCompA;
    compB = ternInfo.valsCompB;
    compC = ternInfo.valsCompC;
    ECPlotInfo = ECInfo.ECPlotInfo;

    [saveFilePrint, savePath] = uigetfile;
    saveFilePrint = strcat(savePath, saveFilePrint);
    
    fileID = fopen(saveFilePrint, 'w');
    
    for i = 1:ternInfo.numPoints
        fprintf(fileID, ...
            'Compositions: %f, %f, %f \t Tafel slope: %f \t Onset potential: %f \n', ...
            compA(i), compB(i), compC(i), ECPlotInfo(i, 1), ECPlotInfo(i, 2));
    end
    
    fclose(fileID);

end

