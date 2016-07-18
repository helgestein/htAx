function [] = plotSpecData(ternHandles, specHandles, ECHandles)
%PLOTSPECDATA plots the spec. data according to the user-selected region

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    XRDData = specInfo.XRDData;
    constType = ternInfo.constType;
    compA = ternInfo.valsCompA;
    compB = ternInfo.valsCompB;
    compC = ternInfo.valsCompC;
    hEditConst = ternHandles.editConst;
    hEditWidth = ternHandles.editWidth;
    constPercent = hEditConst.UserData;
    width = hEditWidth.UserData;
    ternPlotType = ternInfo.ternPlotType;
    numTernPoints = ternInfo.numPoints;
    xTernCoord = ternInfo.xCoords;
    yTernCoord = ternInfo.yCoords;
    xPoly = ternInfo.xPoly;
    yPoly = ternInfo.yPoly;
    
    % highlight appropriate region on ternary diagram
    
    if ternPlotType ~= 1
        if ternPlotType ~= 3
            if ishandle(ternInfo.highlight) == 1
                delete(ternInfo.highlight);
            end
            ternInfo.highlight = plotTernHighlight(figTern, 1000, ...
                constPercent, width, constType);
        end
    end
    
    % get the correct set of composition data
    if constType == 0
        ids = find(abs(compA - constPercent) < width);
        specInfo.selectedComp = compB(ids);
        specInfo.selectedCompPartner = compA(ids);
    elseif constType == 1
        ids = find(abs(compB - constPercent) < width);
        specInfo.selectedComp = compC(ids);
        specInfo.selectedCompPartner = compB(ids);
    elseif constType == 2
        ids = find(abs(compC - constPercent) < width);
        specInfo.selectedComp = compA(ids);
        specInfo.selectedCompPartner = compC(ids);
    else
        found = 0;
        ids = 0;
        for i = 1:numTernPoints
            if inpolygon(xTernCoord(i), yTernCoord(i), xPoly, yPoly) == 1
                found = found + 1;
                ids(found) = i;
            end
        end
        spreads(1) = range(compA(ids));
        spreads(2) = range(compB(ids));
        spreads(3) = range(compC(ids));
        [~, indexMaxSpread] = max(spreads);
        if indexMaxSpread == 1
            specInfo.selectedComp = compA(ids);
            specInfo.selectedCompPartner = compC(ids);
            ternInfo.constType = 2;
        elseif indexMaxSpread == 2
            specInfo.selectedComp = compB(ids);
            specInfo.selectedCompPartner = compA(ids);
            ternInfo.constType = 0;
        else
            specInfo.selectedComp = compC(ids);
            specInfo.selectedCompPartner = compB(ids);
            ternInfo.constType = 1;
        end
    end
    
    %{
    figure(figTern);
    hold on;
    scatter(xTernCoord(ids), yTernCoord(ids), 'c');
    %}
    
    fSpecPlot.UserData = specInfo;
    figTern.UserData = ternInfo;
    
    % find all points for which XRD data was taken
    %ids2 = find(XRDData(1, 2*(1:342) - 1) + XRDData(2, 2*(1:342) - 1) ~= 0);
    
    if isempty(ids) == 1
        errordlg('No points selected');
    else
        ids = ids .* 2;

        plotSpecSliders(specHandles.fSpecPlot, ...
            XRDData(:, 1), XRDData(:, ids), ...
            specInfo.selectedComp, specInfo.scaleType, ...
            ternHandles, specHandles, ECHandles);
    end
    


end

