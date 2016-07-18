function callbackECPlotTern(obj, evt, ternHandles, ECHandles)
%CALLBACKECPLOTTERN plots the calculated onset potentials and tafel slopes
%on a ternary diagram
    
    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;

    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    ECPlotInfo = ECInfo.ECPlotInfo;
    compA = ternInfo.valsCompA;
    compB = ternInfo.valsCompB;
    compC = ternInfo.valsCompC;
    
    % get the points to plot (the ones with calculated tafel slope and
    % onset potential)
    
    pointsToPlot = zeros(1, 1);
    binPoints = zeros(1, 1);
    binPoints2 = zeros(1, 1);
    numBinPoints = 0;
    numBinPoints2 = 0;
    numPointsToPlot = 0;
    for i = 1:ternInfo.numPoints
        if ECPlotInfo(i, 1) ~= 0
            numPointsToPlot = numPointsToPlot + 1;
            [pointsToPlot(numPointsToPlot, 1), ...
                pointsToPlot(numPointsToPlot, 2)] = ...
                getTernCoord(compA(i), compB(i));
            pointsToPlot(numPointsToPlot, 3) = ECPlotInfo(i, 1);
            pointsToPlot(numPointsToPlot, 4) = ECPlotInfo(i, 2);
            
            %if compA(i) < 0.05
            if compA(i) < 0.02
                numBinPoints = numBinPoints + 1;
                binPoints(numBinPoints, 1) = compB(i);
                binPoints(numBinPoints, 2) = ECPlotInfo(i, 1);
                binPoints(numBinPoints, 3) = ECPlotInfo(i, 2);
            end
            
            %if abs(compC(i) - 0.50) < 0.15
            if abs(compC(i) - 0.50) < 0.1
                numBinPoints2 = numBinPoints2 + 1;
                binPoints2(numBinPoints2, 1) = compA(i);
                binPoints2(numBinPoints2, 2) = ECPlotInfo(i, 1);
                binPoints2(numBinPoints2, 3) = ECPlotInfo(i, 2);
            end
        end
    end
    
    zVals = 1000 * ones(1, size(pointsToPlot, 1));
    
    % surf plot of tafel slope
    
    if ishandle(ECInfo.fTernTafelSurf) == 1
        figure(ECInfo.fTernTafelSurf);
        clf;
    else
        ECInfo.fTernTafelSurf = figure;
        set(gcf, 'color', 'w');
        set(ECInfo.fTernTafelSurf, 'Name', 'Tafel Slope - Surf Plot');
    end    
    axesTernTafel = axes('Units', 'Normalized', 'Position', [0.1 0.1 0.8 0.8]);
    plotTernBase(axesTernTafel, ternInfo.labels);    
    plotTernSurf(pointsToPlot(:, 1), pointsToPlot(:, 2), pointsToPlot(:, 3));
    colorbar;
    hold on;
    scatter3(axesTernTafel, pointsToPlot(:, 1), pointsToPlot(:, 2), ...
        zVals, 30, 'k', 'filled');
    
    % surf plot of onset potential
    
    if ishandle(ECInfo.fTernOnsetSurf) == 1
        figure(ECInfo.fTernOnsetSurf);
        clf;
    else
        ECInfo.fTernOnsetSurf = figure;
        set(gcf, 'color', 'w');
        set(ECInfo.fTernOnsetSurf, 'Name', 'Onset Potential - Surf Plot');
    end
    axesTernOnset = axes('Units', 'Normalized', 'Position', [0.1 0.1 0.8 0.8]);
    plotTernBase(axesTernOnset, ternInfo.labels);
    plotTernSurf(pointsToPlot(:, 1), pointsToPlot(:, 2), pointsToPlot(:, 4));
    colorbar;
    hold on;
    scatter3(axesTernOnset, pointsToPlot(:, 1), pointsToPlot(:, 2), ...
        zVals, 30, 'k', 'filled');
    
    % scatter plot of tafel slope
    
    if ishandle(ECInfo.fTernTafelScatter) == 1
        figure(ECInfo.fTernTafelScatter);
        clf;
    else
        ECInfo.fTernTafelScatter = figure;
        set(gcf, 'color', 'w');
        set(ECInfo.fTernTafelScatter, 'Name', 'Tafel Slope - Scatter Plot');
    end
    axesTernTafelScatter = axes('Units', 'Normalized', 'Position', [0.1 0.1 0.8 0.8]);
    plotTernBase(axesTernTafelScatter, ternInfo.labels);
    plotTernScatter(pointsToPlot(:, 1), pointsToPlot(:, 2), pointsToPlot(:, 3), ...
        axesTernTafelScatter, 30);
    
    % scatter plot of onset potential
    
    if ishandle(ECInfo.fTernOnsetScatter) == 1
        figure(ECInfo.fTernOnsetScatter);
        clf;
    else
        ECInfo.fTernOnsetScatter = figure;
        set(gcf, 'color', 'w');
        set(ECInfo.fTernOnsetScatter, 'Name', 'Onset Potential - Scatter Plot');
    end
    axesTernOnsetScatter = axes('Units', 'Normalized', 'Position', [0.1 0.1 0.8 0.8]);
    plotTernBase(axesTernOnsetScatter, ternInfo.labels);
    plotTernScatter(pointsToPlot(:, 1), pointsToPlot(:, 2), pointsToPlot(:, 4), ...
        axesTernOnsetScatter, 30);
    
    
    % binary plot of tafel slope and onset potential for B-C binary region
    %{
    binPoints = sortrows(binPoints);
    if ishandle(ECInfo.fBinaryPlot) == 1
        figure(ECInfo.fBinaryPlot);
        clf;
    else
        ECInfo.fBinaryPlot = figure;
        set(gcf, 'color', 'w');
        set(gcf, 'Name', 'Binary Region Plot (B & C)');
    end
    
    [hAx, ~, ~] = plotyy(binPoints(:, 1), binPoints(:, 2), ...
        binPoints(:, 1), binPoints(:, 3));
    
    xlabel('Fe composition');
    ylabel(hAx(1), 'Tafel slope');
    ylabel(hAx(2), 'Onset potential');
    
    binPoints2 = sortrows(binPoints2);
    figure;
    set(gcf, 'color', 'w');
    %}
    
    %{
    scatter(binPoints2(:, 1), binPoints2(:, 3), 'b');
    %plot(binPoints2(:, 1), binPoints2(:, 3));
    xlabel('Mn composition');
    ylabel('Onset potential');
    %ylim([0 650]);
    %}
    
    %{
    scatter(binPoints2(:, 1), binPoints2(:, 2), 'b');
    %plot(binPoints2(:, 1), binPoints2(:, 2));
    xlabel('Mn composition');
    ylabel('Tafel slope');
    %}
    
    %{
    [hAx2, ~, ~] = plotyy(binPoints2(:, 1), binPoints2(:, 2), ...
        binPoints2(:, 1), binPoints2(:, 3));
    
    xlabel('Mn composition');
    ylabel(hAx2(1), 'Tafel slope');
    ylabel(hAx2(2), 'Onset potential');
    %}
    
    
    %{
    yyaxis left;
    plot(binPoints(:, 1), binPoints(:, 2));
    ylabel('Tafel slope');
    hold on;
    yyaxis right;
    plot(binPoints(:, 1), binPoints(:, 3));
    xlabel('Fe composition');
    ylabel('Onset potential');
    %}
         
    fECPlot.UserData = ECInfo;
end

