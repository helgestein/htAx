function callbackXRDPlot(obj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKXRDPLOT waits for the user to select a point on the ternary
%diagram and plots the XRD pattern at that point

    set(ternHandles.buttonXRDPlot, 'Callback', []);

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    xTernPoints = ternInfo.xCoords;
    yTernPoints = ternInfo.yCoords;
    compA = ternInfo.valsCompA;
    compB = ternInfo.valsCompB;
    compC = ternInfo.valsCompC;
    XRDData = specInfo.XRDData;
    
    figure(ternHandles.fTernDiagram);
    [xSelect, ySelect] = ginput(1);
    indexPoint = findNearestPoint(xSelect, ySelect, ...
        ternInfo.numPoints, xTernPoints, yTernPoints);
    
    if ishandle(ternInfo.pointOutline) == 1
        delete(ternInfo.pointOutline);
    end
    ternInfo.pointOutline = scatter(xTernPoints(indexPoint), ...
        yTernPoints(indexPoint), 'k');
    
    % plot XRD data for that point
    if ishandle(ternInfo.fXRDPlot) == 1
        figure(ternInfo.fXRDPlot);
        clf;
    else
        ternInfo.fXRDPlot = figure;
        set(gcf, 'color', 'w');
        set(gcf, 'Name', 'XRD Plot for Selected Point');
    end
    
    axes('Units', 'Normalized', 'Position', [0.1 0.1 0.8 0.8]);
    plot(XRDData(:, indexPoint * 2 - 1), XRDData(:, indexPoint * 2));
    xlabel('Angle');
    ylabel('Intensity');
    
    displayString = sprintf('A: %f\nB: %f\nC: %f', ...
        compA(indexPoint), compB(indexPoint), compC(indexPoint));
    
    hold on;
    legend(displayString, 'location', 'EastOutside');
    
    figTern.UserData = ternInfo;
    
    set(ternHandles.buttonXRDPlot, 'Callback', {@callbackXRDPlot, ternHandles, specHandles, ECHandles});

end

