function callbackXRDMatchAll(obj, evt, ternHandles, specHandles)
%CALLBACKXRDMATCHALL compares each ternary point's XRD pattern to patterns
%from the XRD database folder and then for each pattern in the database
%folder, plots a ternary diagram indicating which points had peak matches
    
    tic

    msgbox('Matching peaks. Please wait');
    
    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    numTernPoints = ternInfo.numPoints;
    xTernCoords = ternInfo.xCoords;
    yTernCoords = ternInfo.yCoords;
    pointInfo = ternInfo.pointInfo;
    XRDData = specInfo.XRDData;
    XRDDatabase = specInfo.XRDDatabase;
    collcodes = specInfo.collcodes;
    confidenceFactor = ternHandles.editConfFactor.UserData;
    tol = ternHandles.editTol.UserData;
    
    numDatabaseFiles = length(XRDDatabase(1, :)) / 2;
    matchAll = zeros(numTernPoints, numDatabaseFiles);
    for i = 1:numTernPoints
        [matchAll(i, :), ~] = findXRDMatchesPoint(i, XRDData, XRDDatabase, confidenceFactor, tol);
    end
    specInfo.matchInfo = matchAll;
    fSpecPlot.UserData = specInfo;
    
    set(0, 'DefaultFigureWindowStyle', 'docked');
    
    for indexFiles = 1:numDatabaseFiles
        figure;
        set(gcf, 'color', 'w');
        axesFig = axes('Units', 'Normalized', 'Position', [0.1 0.1 0.8 0.8]);
        plotTernBase(axesFig, ternInfo.labels);
        hold on;
        
        plotTernScatter(xTernCoords, yTernCoords, matchAll(:, indexFiles), ...
            axesFig, 30);
        %plotTernSurf(xTernCoords, yTernCoords, matchAll(:, indexFiles));
        
        legendString = sprintf('collcode: %d', collcodes(indexFiles));
        legend(legendString, 'location', 'SouthOutside');
        hold on;
        
        % overlays points selected using binary cuts
        if ternInfo.numSelected ~= 0
            scatter(pointInfo(:, 1), pointInfo(:, 2), 'r');
        end
    end
    
    set(0, 'DefaultFigureWindowStyle', 'normal');
    
    toc

end

