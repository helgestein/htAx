function [] = plotTernData(ternHandles, specHandles, ECHandles)
%PLOTTERNDATA call using PLOTTERNDATA(TERNHANDLES, SPECHANDLES,
%ECHANDLES)

figTern = ternHandles.fTernDiagram;
ternInfo = figTern.UserData;

ternPlotType = ternInfo.ternPlotType;
numTernPoints = ternInfo.numPoints;
numSelected = ternInfo.numSelected;
pointInfo = ternInfo.pointInfo;
hEditSize = ternHandles.editSize;
dotSize = hEditSize.UserData;

figSpec = specHandles.fSpecPlot;
specInfo = figSpec.UserData;

XRDData = specInfo.XRDData;
angleIndex = specInfo.angleIndex;

figEC = ECHandles.fECPlot;
ECInfo = figEC.UserData;

ECData = ECInfo.ECData;
valSliderECPot = ECInfo.valSliderECPot;

% plot gridlines
figure(figTern);
hold off;
plotTernBase(ternInfo.axesTernary, ternInfo.labels);
hold on;

% highlight the appropriate region

if ternPlotType ~= 1
    if ternPlotType ~= 3
        if ishandle(ternInfo.highlight) == 1
            delete(ternInfo.highlight);
        end
        hEditConst = ternHandles.editConst;
        hEditWidth = ternHandles.editWidth;
        ternInfo.highlight = plotTernHighlight(figTern, 1000, ...
            hEditConst.UserData, hEditWidth.UserData, ...
            ternInfo.constType);
        figTern.UserData = ternInfo;
    end
end

ternInfo = figTern.UserData;

% plot the selected data

if ternPlotType == 0
    plotTernScatter(ternInfo.xCoords, ternInfo.yCoords, ...
        XRDData(angleIndex, 2 .* (1:numTernPoints)), ...
        ternInfo.axesTernary, dotSize);
elseif ternPlotType == 1
    plotTernSurf(ternInfo.xCoords, ternInfo.yCoords, ...
        XRDData(angleIndex, 2 .* (1:numTernPoints)));
else
    
    toPlot = zeros(1, numTernPoints);
    for indexEC = 1:numTernPoints
        minIndex = findClosestPot(valSliderECPot, ...
            ECData(:, 2 * indexEC - 1));
        toPlot(indexEC) = ECData(minIndex, 2 .* indexEC);
    end
    
    if ternPlotType == 2
        plotTernScatter(ternInfo.xCoords, ternInfo.yCoords, ...
            toPlot, ternInfo.axesTernary, dotSize);
    else
        plotTernSurf(ternInfo.xCoords, ternInfo.yCoords, toPlot);
    end
    
end

% plot the selected points

if numSelected ~= 0
    zVals = 100000 * ones(numSelected, 1);
    zVal = 100000;
    for i = 2:2:numSelected
        
        angle = XRDData(pointInfo(i, 6), 1);
        colorSelection = getColorSelection(angle, specInfo.minAngle, ...
            specInfo.maxAngle);
        
        hold on;
        
        scatter3(ternInfo.axesTernary, ...
            pointInfo(i - 1, 1), pointInfo(i - 1, 2), ...
            zVal, 30, colorSelection, 'filled');
        scatter3(ternInfo.axesTernary, ...
            pointInfo(i, 1), pointInfo(i, 2), ...
            zVal, 30, colorSelection, 'filled');
        
        plot3(ternInfo.axesTernary, ...
            [pointInfo(i - 1, 1) pointInfo(i, 1)], ...
            [pointInfo(i - 1, 2) pointInfo(i, 2)], ...
            [zVal zVal], 'Color', colorSelection);
        
    end
    
    %{
    scatter3(ternInfo.axesTernary, pointInfo(:, 1), pointInfo(:, 2), ...
        zVals, 30, 'r', 'filled');
    i = 1;
    hold on;
    while i <= numSelected - 1
        hold on;
        plot3(ternInfo.axesTernary, ...
            [pointInfo(i, 1) pointInfo(i + 1, 1)], ...
            [pointInfo(i, 2) pointInfo(i + 1, 2)], ...
            [1000 1000], 'r');
        i = i + 2;
        hold on;
    end
    %}
end

end

