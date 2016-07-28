function callbackPlotTernPhase(obj, evt, ternHandles, specHandles)
%CALLBACKPLOTTERNPHASE plots the user-selected points on a ternary diagram

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    pointInfo = ternInfo.pointInfo;
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    if ishandle(ternInfo.fTernPhase) == 1
        figure(ternInfo.fTernPhase);
        clf;
    else
        ternInfo.fTernPhase = figure;
        set(gcf, 'color', 'w');
        set(gcf, 'Name', 'Ternary Phase Plot');
    end
    
    axesTernPhase = axes(...
        'Units', 'Normalized', ...
        'Position', [0.1 0.1 0.8 0.8]);
    
    plotTernBase(axesTernPhase, ternInfo.labels);
    hold on;
    
    for i = 1:ternInfo.numSelected
        angle = specInfo.XRDData(pointInfo(i, 6), 1);
        colorSelection = getColorSelection(angle, specInfo.minAngle, ...
            specInfo.maxAngle);
        hold on;
        scatter(axesTernPhase, pointInfo(i, 1), pointInfo(i, 2), ...
            30, colorSelection, 'filled');
    end

end

