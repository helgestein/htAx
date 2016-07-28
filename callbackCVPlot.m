function callbackCVPlot(obj, evt, type, ternHandles, specHandles, ECHandles)
%CALLBACKCVPLOT waits for the user to select a point on the ternary diagram
%and plots the CV curve corresponding to that point

    if type == 1
        set(ternHandles.buttonCVPlot, 'Callback', []);
    else
        set(ternHandles.buttonCVPlotNormal, 'Callback', []);
    end
    
    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    xTernPoints = ternInfo.xCoords;
    yTernPoints = ternInfo.yCoords;
    compA = ternInfo.valsCompA;
    compB = ternInfo.valsCompB;
    compC = ternInfo.valsCompC;
    ECData = ECInfo.ECData;
    
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
    if ishandle(ternInfo.fCVPlot) == 1
        figure(ternInfo.fCVPlot);
        clf;
    else
        ternInfo.fCVPlot = figure;
        set(gcf, 'color', 'w');
        set(gcf, 'Name', 'CV Plot for Selected Point');
    end
    
    axes('Units', 'Normalized', 'Position', [0.1 0.1 0.8 0.8]);
    
    if type == 1
        plot(ECData(:, indexPoint * 2 - 1), log10(abs(ECData(:, indexPoint * 2))));
        xlabel('Potential');
        ylabel('log(Current)');
    else
        ids = (ECData(:, indexPoint * 2 - 1) == 0);
        ECData(ids, indexPoint * 2 - 1) = NaN;
        ECData(ids, indexPoint * 2) = NaN;
        plot(ECData(:, indexPoint * 2 - 1), ...
            ECData(:, indexPoint * 2));
        xlabel('Potential');
        ylabel('Current');
    end
    
    displayString = sprintf('A: %f\nB: %f\nC: %f', ...
        compA(indexPoint), compB(indexPoint), compC(indexPoint));
    
    hold on;
    legend(displayString, 'location', 'EastOutside');
    
    figTern.UserData = ternInfo;
    
    if type == 1
        set(ternHandles.buttonCVPlot, 'Callback', ...
            {@callbackCVPlot, 1, ternHandles, specHandles, ECHandles});
    else
        set(ternHandles.buttonCVPlotNormal, 'Callback', ...
            {@callbackCVPlot, 0, ternHandles, specHandles, ECHandles});
    end

end

