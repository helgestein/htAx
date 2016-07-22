function callbackPlotPeaks(obj, evt, ternHandles, specHandles)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    set(ternHandles.buttonPlotPeaks, 'Callback', []);
    
    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    xTernPoints = ternInfo.xCoords;
    yTernPoints = ternInfo.yCoords;
    XRDData = specInfo.XRDData;
    confidenceFactor = ternHandles.editConfFactor.UserData;
    
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
    
    angles = XRDData(:, indexPoint * 2 - 1);
    intensity = XRDData(:, indexPoint * 2);
    
    if angles(1) ~= 0
        [~, ~, ~, ~, signal, ~, ~] = ...
            findPeakXRD(angles, intensity, confidenceFactor);
        
        if ishandle(ternInfo.fXRDPlot) == 1
            figure(ternInfo.fXRDPlot);
            clf;
        else
            ternInfo.fXRDPlot = figure;
            set(gcf, 'color', 'w');
            set(gcf, 'Name', 'XRD Plot and Reconstructed Pattern for Selected Point');
        end

        xrdPlotAxes = axes('Units', 'Normalized', ...
            'Position', [0.1 0.1 0.8 0.8]);
        subplot(2, 1, 1, xrdPlotAxes);
        plot(XRDData(:, indexPoint * 2 - 1), XRDData(:, indexPoint * 2));
        xlabel('Angle');
        ylabel('Intensity');
        %hold on;
        reconPlotAxes = axes('Units', 'Normalized', ...
            'Position', [0.1 0.1 0.8 0.8]);
        subplot(2, 1, 2, reconPlotAxes);
        plot(angles, signal);
        xlabel('Angle');
        ylabel('Intensity');
        %{
        anglesToCheck = peakLocs;
        widthsToCheck = widths;
        intensityToCheck = pks;
        promsToCheck = proms;
        figure;
        plot(angles, intensity);
        hold on;
        for i = 1:length(anglesToCheck)
            left = anglesToCheck(i) - widthsToCheck(i) / 2;
            right = anglesToCheck(i) + widthsToCheck(i) / 2;
            x = [left right right left left];
            y = [0 0 intensity(i) intensity(i) 0];
            peak = fill(x, y, 'r');
            alpha(peak, 0.1);
        end
            %}
    end
    
    figTern.UserData = ternInfo;
    fSpecPlot.UserData = specInfo;
    
    set(ternHandles.buttonPlotPeaks, 'Callback', {@callbackPlotPeaks, ternHandles, specHandles});
end

