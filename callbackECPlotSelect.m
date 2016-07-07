function callbackECPlotSelect(hObj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKECPLOTSELECT allows the user to select a specific CV curve

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;

    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    selectedCompSort = ECInfo.selectedCompSort;
    hTextTafel = ECHandles.textTafel;
    hTextOnset = ECHandles.textOnsetPot;
    ECPlotInfo = ECInfo.ECPlotInfo;

    composition = str2double(hObj.String) / 100;
    if isnan(composition)
        errordlg('not a number');
        hObj.String = '0';
        ECInfo.selectedPlot = 0;
        composition = 0;
    end
    
    [~, dispIndex] = min(abs(selectedCompSort - composition));
    realComp = selectedCompSort(dispIndex);
    
    if ternInfo.constType == 0
        [~, genIndex] = min(abs(ternInfo.valsCompB - realComp));
    elseif ternInfo.constType == 1
        [~, genIndex] = min(abs(ternInfo.valsCompC - realComp));
    else
        [~, genIndex] = min(abs(ternInfo.valsCompA - realComp));
    end    
    
    ECInfo.selectedPlotDispIndex = dispIndex;
    ECInfo.selectedPlotGenIndex = genIndex;
    hTextTafel.String = num2str(ECPlotInfo(genIndex, 1));
    hTextOnset.String = num2str(ECPlotInfo(genIndex, 2));

    fECPlot.UserData = ECInfo;
    
    plotECData(ternHandles, specHandles, ECHandles);
end

