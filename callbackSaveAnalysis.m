function callbackSaveAnalysis(obj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKSAVEANALYSIS saves the analysis

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    figSpec = specHandles.fSpecPlot;
    specInfo = figSpec.UserData;
    
    figEC = ECHandles.fECPlot;
    ECInfo = figEC.UserData;
    
    [saveFile, savePath] = uigetfile;
    saveFile = strcat(savePath, saveFile);
     
    analysis.XRDData = specInfo.XRDData;
    analysis.A = ternInfo.valsCompA;
    analysis.B = ternInfo.valsCompB;
    analysis.C = ternInfo.valsCompC;
    analysis.numSelected = ternInfo.numSelected;
    analysis.pointInfo = ternInfo.pointInfo;
    analysis.ECData = ECInfo.ECData;
    analysis.ECPlotInfo = ECInfo.ECPlotInfo;
    analysis.collcodes = specInfo.collcodes;
    analysis.XRDDatabase = specInfo.XRDDatabase;
    analysis.labels = ternInfo.labels;
    analysis.savedPoly = ternInfo.savedPoly;
    save(saveFile, '-struct', 'analysis');
    msgbox('Analysis saved');

end

