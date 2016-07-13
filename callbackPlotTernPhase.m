function callbackPlotTernPhase(obj, evt, ternHandles)
%CALLBACKPLOTTERNPHASE plots the user-selected points on a ternary diagram

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    pointInfo = ternInfo.pointInfo;
    
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
    
    plotTernBase(axesTernPhase);
    hold on;
    scatter(pointInfo(:, 1), pointInfo(:, 2), 'k');
    
    xTernCoords = ternInfo.xCoords;
    yTernCoords = ternInfo.yCoords;
    
    %{
    hold on;
    index1 = 183;
    index2 = 224;
    scatter(xTernCoords(index1), yTernCoords(index1), 30, 'r', 'filled');
    scatter(xTernCoords(index2), yTernCoords(index2), 30, 'r', 'filled');
    %}

end

