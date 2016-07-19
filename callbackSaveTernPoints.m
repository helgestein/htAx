function callbackSaveTernPoints(obj, evt, ternHandles, specHandles)
%CALLBACKSAVETERNPOINTS saves user-selected points from the spec. plot

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    hEditConst = ternHandles.editConst;
    hEditWidth = ternHandles.editWidth;
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    ternInfo.numSelected = ternInfo.numSelected + 2;
    numSelected = ternInfo.numSelected;
    pointInfo = ternInfo.pointInfo;
    selectedComp = specInfo.selectedComp;
    selectedCompPartner = specInfo.selectedCompPartner;
    constType = ternInfo.constType;
    
    [compA1, compB1, compC1] = getComp(specInfo.valSliderVert1, ...
        selectedComp, selectedCompPartner, constType);
    [compA2, compB2, compC2] = getComp(specInfo.valSliderVert2, ...
        selectedComp, selectedCompPartner, constType);
    [xTernCoord1, yTernCoord1] = getTernCoord(compA1, compB1);
    [xTernCoord2, yTernCoord2] = getTernCoord(compA2, compB2);
    pointInfo(numSelected - 1, :) = ...
        [xTernCoord1 yTernCoord1 compA1 compB1 compC1 ...
        specInfo.angleIndex hEditConst.UserData hEditWidth.UserData ...
        ternInfo.constType ternInfo.ternPlotType specInfo.scaleType];
    pointInfo(numSelected, :) = ...
        [xTernCoord2 yTernCoord2 compA2 compB2 compC2 ...
        specInfo.angleIndex hEditConst.UserData hEditWidth.UserData ...
        ternInfo.constType ternInfo.ternPlotType specInfo.scaleType];
    
    ternInfo.pointInfo = pointInfo;    
    figTern.UserData = ternInfo;
    
    % plot user selected points and line
    
    figure(figTern);
    hold on;
    angle = specInfo.XRDData(specInfo.angleIndex, 1);
    %{
    angleFrac = (angle - specInfo.minAngle) / ...
        (specInfo.maxAngle - specInfo.minAngle);
    origColor = [255 102 102];
    endColor = [102 178 255];
    colorSelection = origColor * (1 - angleFrac) + endColor * angleFrac;
    %colorSelection = [255 0 127 * angleFrac];
    colorSelection = colorSelection / 255;
    %}
    colorSelection = getColorSelection(angle, ...
        specInfo.minAngle, specInfo.maxAngle);
    
    %{
    % testing colors
    figure;
    fill([0 1 1 0 0], [0 0 1 1 0], colorSelection);
    %}
    
    zMax = 100000;
    figure(figTern);
    scatter3(ternInfo.axesTernary, xTernCoord1, yTernCoord1, zMax, ...
        30, colorSelection, 'filled');
    scatter3(ternInfo.axesTernary, xTernCoord2, yTernCoord2, zMax, ...
        30, colorSelection, 'filled');
    plot3(ternInfo.axesTernary, [xTernCoord1 xTernCoord2], ...
        [yTernCoord1 yTernCoord2], [zMax zMax], 'Color', colorSelection);
    hold off;
    
    function [compA, compB, compC] = getComp(composition, selectedComp, ...
            selectedCompPartner, constType)
        [~, closestIndex] = min(abs(selectedComp - composition));
        
        if constType == 0
            compA = selectedCompPartner(closestIndex);
            compB = selectedComp(closestIndex);
            compC = 1 - compA - compB;
        elseif constType == 1
            compB = selectedCompPartner(closestIndex);
            compC = selectedComp(closestIndex);
            compA = 1 - compB - compC;
        elseif constType == 2
            compC = selectedCompPartner(closestIndex);
            compA = selectedComp(closestIndex);
            compB = 1 - compC - compA;
        else
            compA = selectedCompPartner(closestIndex);
            compB = selectedComp(closestIndex);
            compC = 1 - compA - compB;
        end
    end

end

