function callbackXRDMatchAll(obj, evt, ternHandles, specHandles)
%CALLBACKXRDMATCHALL compares each ternary point's XRD pattern to patterns
%from the XRD database folder and then for each pattern in the database
%folder, plots a ternary diagram indicating which points had peak matches

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    numTernPoints = ternInfo.numPoints;
    xTernCoords = ternInfo.xCoords;
    yTernCoords = ternInfo.yCoords;
    XRDData = specInfo.XRDData;
    XRDDatabase = specInfo.XRDDatabase;
    collcodes = specInfo.collcodes;
    
    numDatabaseFiles = length(XRDDatabase(1, :)) / 2;
    matchAll = zeros(numTernPoints, numDatabaseFiles);
    for i = 1:numTernPoints
        [matchAll(i, :), ~] = findXRDMatchesPoint(i, XRDData, XRDDatabase);
    end
    
    for indexFiles = 1:numDatabaseFiles
        figure;
        axesFig = axes('Units', 'Normalized', 'Position', [0.1 0.1 0.8 0.8]);
        plotTernBase(axesFig);
        hold on;
        %plotTernSurf(xTernCoords, yTernCoords, matchAll(:, indexFiles));
        %colorbar;
        plotTernScatter(xTernCoords, yTernCoords, matchAll(:, indexFiles), ...
            axesFig, 30);
        legendString = sprintf('collcode: %d', collcodes(indexFiles));
        legend(legendString, 'location', 'SouthOutside');
    end

end

