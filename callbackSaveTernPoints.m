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
    scatter3(ternInfo.axesTernary, xTernCoord1, yTernCoord1, 1000, ...
        30, 'r', 'filled');
    scatter3(ternInfo.axesTernary, xTernCoord2, yTernCoord2, 1000, ...
        30, 'r', 'filled');
    plot3(ternInfo.axesTernary, [xTernCoord1 xTernCoord2], ...
        [yTernCoord1 yTernCoord2], [1000 1000], 'r');
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
        else
            compC = selectedCompPartner(closestIndex);
            compA = selectedComp(closestIndex);
            compB = 1 - compC - compA;
        end
    end

end

