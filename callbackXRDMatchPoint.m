function callbackXRDMatchPoint(obj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKXRDMATCHPOINT waits for the user to select a point on the ternary
%diagram, compares that point's XRD pattern to patterns in the XRD database
%folder, and for each XRD database pattern it shares at least one peak
%with, plots the XRD database pattern with the point's XRD pattern

    set(ternHandles.buttonSelectPoint, 'Callback', []);

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
    XRDDatabase = specInfo.XRDDatabase;
    collcodes = specInfo.collcodes;

    figure(ternHandles.fTernDiagram);
    [xSelect, ySelect] = ginput(1);
    indexPoint = findNearestPoint(xSelect, ySelect, ...
        ternInfo.numPoints, xTernPoints, yTernPoints);
    
    hold on;
    
    % outline selected point
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
    
    figure(ternInfo.fXRDPlot);
    
    hold on;
    legend(displayString, 'location', 'EastOutside');
    
    [~, matchData] = findXRDMatchesPoint(indexPoint, XRDData, specInfo.XRDDatabase);
    
    if matchData(1, 1) ~= 0
        matchData = sortrows(matchData);
        databaseIndex = 0;
        for indexData = 1:length(matchData(:, 1))
            if matchData(indexData, 1) ~= databaseIndex
                databaseIndex = matchData(indexData, 1);
                figure;
                plot(XRDDatabase(:, databaseIndex * 2 - 1), XRDDatabase(:, databaseIndex * 2), 'b');
                hold on;
                XRDDataPlot = plot(XRDData(:, indexPoint * 2 - 1), XRDData(:, indexPoint * 2), 'g');
                collcodeString = sprintf('collcode: (%d, %d), composition(%f, %f, %f)', ...
                    databaseIndex, collcodes(databaseIndex), ...
                    compA(indexPoint), compB(indexPoint), compC(indexPoint));
                legend(collcodeString, 'location', 'SouthOutside');
            end
            hold on;
            xOrigVal = matchData(indexData, 2);
            xDBVal = matchData(indexData, 4);
            plot([xOrigVal xOrigVal], [0 250], 'r');
            plot([xDBVal xDBVal], [0 250], 'm');
            uistack(XRDDataPlot, 'top');
        end
    end
    
    figTern.UserData = ternInfo;
    
    set(ternHandles.buttonSelectPoint, 'Callback', {@callbackXRDMatchPoint, ternHandles, specHandles, ECHandles});

end

