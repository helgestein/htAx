function plotECData(ternHandles, specHandles, ECHandles)
%PLOTECDATA plots the EC data for the user-selected region

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    constType = ternInfo.constType;
    compA = ternInfo.valsCompA;
    compB = ternInfo.valsCompB;
    compC = ternInfo.valsCompC;
    hEditConst = ternHandles.editConst;
    hEditWidth = ternHandles.editWidth;
    constPercent = hEditConst.UserData;
    width = hEditWidth.UserData;
    ECData = ECInfo.ECData;
    ECPlotInfo = ECInfo.ECPlotInfo;
    
    if constType == 0
        ids = find(abs(compA - constPercent) < width);
        specInfo.selectedComp = compB(ids);
        specInfo.selectedCompPartner = compA(ids);
    elseif constType == 1
        ids = find(abs(compB - constPercent) < width);
        specInfo.selectedComp = compC(ids);
        specInfo.selectedCompPartner = compB(ids);
    else
        ids = find(abs(compC - constPercent) < width);
        specInfo.selectedComp = compA(ids);
        specInfo.selectedCompPartner = compC(ids);
    end
    
    fSpecPlot.UserData = specInfo;
    figTern.UserData = ternInfo;
    fECPlot.UserData = ECInfo;
    
    if isempty(ids) == 1
        errordlg('No points selected');
        
    else
        idsOrig = ids;
        ids = ids .* 2;
        plotECWaterfall(ECData(:, ids - 1), ECData(:, ids), ...
            specInfo.selectedComp, ECPlotInfo(idsOrig, 4), ...
            ternHandles, specHandles, ECHandles);
    end

end

