function plotECWaterfall(potential, current, composition, decrease, ...
    ternHandles, specHandles, ECHandles)
%PLOTECWATERFALL creates a waterfall plot out of the given CV curve
%information

    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    waterfallPlot = ECInfo.waterfallPlot;
    hEditOffset = ECHandles.editOffset;
    offset = hEditOffset.UserData;
    dispIndex = ECInfo.selectedPlotDispIndex;
    
    figure(fECPlot);
    clf;
    waterfallPlot.figure = fECPlot;
    
    % set up axes
    graphHeightFrac = 0.8;
    graphVertPosFrac = 0.10;
    graphHorPosFrac = 0.07;
    graphWidthFrac = 0.8;
    sliderWidthFrac = 0.02;    
    
    numPlots = length(potential(1, :));
    
    % rectangle position defined by [left, bottom, width, height];    
    
    waterfallPlot.dataAxes = axes(...
        'Units', 'Normalized', ...
        'Position', [graphHorPosFrac graphVertPosFrac ...
        graphWidthFrac graphHeightFrac], ...
        'XTick', [], 'YTick', [], ...
        'Box', 'on');
    waterfallPlot.sliderAxes = axes(...
        'Units', 'Normalized', ...
        'Position', [graphHorPosFrac (graphVertPosFrac + graphHeightFrac)...
        graphWidthFrac sliderWidthFrac], ...
        'XTick', [], 'YTick', [], ...
        'YLim', [0 1], ...
        'Box', 'on');
    waterfallPlot.sliderAxesFit = axes(...
        'Units', 'Normalized', ...
        'Position', ...
        [graphHorPosFrac (graphVertPosFrac + graphHeightFrac + sliderWidthFrac) ...
        graphWidthFrac sliderWidthFrac], ...
        'XTick', [], 'YTick', [], ...
        'YLim', [0 1], ...
        'Box', 'on');
    Range.X = [min(min(potential)) max(max(potential))];
    maxRaw = max(max(log10(abs(current)))) + offset * numPlots;
    minRaw = min(min(log10(abs(current))));
    Range.Y = [minRaw maxRaw];
    
    axes(waterfallPlot.dataAxes);
    
    % sort compositions for plot
    [ECInfo.selectedCompSort, sID] = sort(composition);
    
    figure(fECPlot);
    hold on;
    
    for plotIndex = 1:numPlots
        
        % make selected plot orange; otherwise, link color of plot to
        % composition
        if plotIndex == dispIndex
            plotColor = [240 132 69] / 255;
        else
            plotColor = [0.3 0.5 composition(sID(plotIndex))];
        end
    
        % use only one half of plot data
        if decrease(sID(plotIndex)) ~= 0
            [~, maxPotentialIndex] = max(potential(:, sID(plotIndex)));

            % only plot increasing potential data
            if decrease(sID(plotIndex)) == 1
                plot(potential(1:maxPotentialIndex, sID(plotIndex)), ...
                    log10(abs(current(1:maxPotentialIndex, sID(plotIndex)))) + ...
                    offset * (plotIndex - 1), ...
                    'Color', plotColor);

            else
                lastIndex = length(potential(:, sID(plotIndex)));
                plot(potential(maxPotentialIndex:lastIndex, sID(plotIndex)), ...
                    log10(abs(current(maxPotentialIndex:lastIndex, sID(plotIndex)))) + ...
                    offset * (plotIndex - 1), ...
                    'Color', plotColor);
            end
        else

            % use both increasing and decreasing potentials
            plot(potential(:, sID(plotIndex)), ...
                log10(abs(current(:, sID(plotIndex)))) + offset * (plotIndex - 1), ...
                'Color', plotColor);
        end
        
        % plot label
        text(potential(1, sID(plotIndex)), ...
            log10(abs(current(1, sID(plotIndex)))) + offset * (plotIndex - 1), ...
            strcat({'Composition: '}, num2str(composition(sID(plotIndex)))));
        
    end
    
    % axes labels
    axes(waterfallPlot.dataAxes);
    xlabel('Position');
    ylabel('log(Current)');
    limits = axis;
    set(waterfallPlot.dataAxes, ...
        'XTickMode', 'auto', 'XTickLabelMode', 'auto', ...
        'YTickMode', 'auto', 'YTickLabelMode', 'auto');
    Range.Y = [limits(3) limits(4)];
    
    set(waterfallPlot.dataAxes, 'XLim', Range.X);
    set(waterfallPlot.dataAxes, 'YLim', Range.Y);
    set(waterfallPlot.figure, 'BusyAction', 'cancel');
    setappdata(waterfallPlot.figure, 'forcedclose', '0');
    
    % horizontal slider for ternary plot
    
    axes(waterfallPlot.sliderAxes);
    set(waterfallPlot.sliderAxes, 'XLim', Range.X);
    hold on;
    waterfallPlot.sliderLine = plot(Range.X, [.5 .5], '-r');
    waterfallPlot.sliderMarker = plot(Range.X(1), .5, 'rv', ...
        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
    axes(waterfallPlot.dataAxes);
    hold on;
    waterfallPlot.potentialMarker = ...
        plot([Range.X(1) Range.X(1)], ...
        get(waterfallPlot.dataAxes, 'YLim'), 'r');
    
    % horizontal sliders for fitting linear region
    
    axes(waterfallPlot.sliderAxesFit);
    set(waterfallPlot.sliderAxesFit, 'XLim', Range.X);
    hold on;
    waterfallPlot.sliderECFitLine = plot(Range.X, [.5 .5], '-b');
    waterfallPlot.sliderECFitMarker1 = plot(Range.X(1), .5, 'rv', ...
        'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
    ECInfo.valSliderFit1 = Range.X(1);
    waterfallPlot.sliderECFitMarker2 = plot(Range.X(2), .5, 'rv', ...
        'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
    ECInfo.valSliderFit2 = Range.X(2);
    axes(waterfallPlot.dataAxes);
    hold on;
    waterfallPlot.potentialFitMarker1 = plot([Range.X(1) Range.X(1)], ...
        get(waterfallPlot.dataAxes, 'YLim'), 'b');
    waterfallPlot.potentialFitMarker2 = plot([Range.X(2) Range.X(2)], ...
        get(waterfallPlot.dataAxes, 'YLim'), 'b');
    
    % bring slider axes to the front
    uistack(waterfallPlot.sliderAxes, 'top');
    uistack(waterfallPlot.sliderAxesFit, 'top');
    
    % set callback functions
    set(waterfallPlot.sliderAxes, 'ButtonDownFcn', ...
        {@sliderECHorCallback, waterfallPlot.sliderAxes, ...
        ternHandles, specHandles, ECHandles});
    set(waterfallPlot.sliderLine, 'ButtonDownFcn', ...
        {@sliderECHorCallback, waterfallPlot.sliderAxes, ...
        ternHandles, specHandles, ECHandles});
    set(waterfallPlot.sliderMarker, 'ButtonDownFcn', ...
        {@sliderECHorCallback, waterfallPlot.sliderAxes, ...
        ternHandles, specHandles, ECHandles});
    set(waterfallPlot.sliderAxesFit, 'ButtonDownFcn', ...
        {@sliderECFitCallback, waterfallPlot.sliderAxesFit, ...
        ECHandles});
    set(waterfallPlot.sliderECFitLine, 'ButtonDownFcn', ...
        {@sliderECFitCallback, waterfallPlot.sliderAxesFit, ...
        ECHandles});
    set(waterfallPlot.sliderECFitMarker1, 'ButtonDownFcn', ...
        {@sliderECFitCallback, waterfallPlot.sliderAxesFit, ...
        ECHandles});
    set(waterfallPlot.sliderECFitMarker2, 'ButtonDownFcn', ...
        {@sliderECFitCallback, waterfallPlot.sliderAxesFit, ...
        ECHandles});
    
    ECInfo.waterfallPlot = waterfallPlot;
    fECPlot.UserData = ECInfo;
    
    %% determine where horizontal slider is; adjust ternary plot
    
    function sliderECClickHor(src, evt, ternHandles, specHandles, ECHandles)
        
        figTern = ternHandles.fTernDiagram;
        ternInfo = figTern.UserData;
        
        figEC = ECHandles.fECPlot;
        ECInfoNest = figEC.UserData;
        waterfallPlotNest = ECInfoNest.waterfallPlot;
        
        selected = get(waterfallPlotNest.sliderAxes, 'CurrentPoint');
        sliderVal = selected(1, 1);
        
        ECInfoNest.valSliderECPot = sliderVal;
        
        ECInfoNest.waterfallPlot = waterfallPlotNest;
        figEC.UserData = ECInfoNest;
        
        plotTernData(ternHandles, specHandles, ECHandles);
        
        figEC = ECHandles.fECPlot;
        ECInfoNest = figEC.UserData;
        waterfallPlotNest = ECInfoNest.waterfallPlot;
        
        set(waterfallPlotNest.sliderMarker, 'XData', sliderVal);
        set(waterfallPlotNest.potentialMarker, 'XData', [sliderVal sliderVal]);
        
        if ternInfo.ternPlotType == 2
            set(ternInfo.textAngle, ...
                'String', strcat({'Potential: '}, num2str(sliderVal)));
        elseif ternInfo.ternPlotType == 3
            set(ternInfo.textAngle, ...
                'String', strcat({'Potential: '}, num2str(sliderVal)));
        end
        
        ECInfoNest.waterfallPlot = waterfallPlotNest;
        figEC.UserData = ECInfoNest;
        
        figTern.UserData = ternInfo;
    end

    %% determine where fit horizontal sliders are
    
    function sliderECFitClick(src, evt, ECHandles)
        
        figEC = ECHandles.fECPlot;
        ECInfoNest = figEC.UserData;
        
        waterfallPlotNest = ECInfoNest.waterfallPlot;
        slider1 = ECInfoNest.valSliderFit1;
        slider2 = ECInfoNest.valSliderFit2;
        
        selected = get(waterfallPlotNest.sliderAxesFit, 'CurrentPoint');
        sliderVal = selected(1, 1);
        
        sliderNum = closerSlider(sliderVal, slider1, slider2);
        if sliderNum == 1
            set(waterfallPlotNest.sliderECFitMarker1, 'XData', sliderVal);
            set(waterfallPlotNest.potentialFitMarker1, ...
                'XData', [sliderVal sliderVal]);
            ECInfoNest.valSliderFit1 = sliderVal;
        else
            set(waterfallPlotNest.sliderECFitMarker2, 'XData', sliderVal);
            set(waterfallPlotNest.potentialFitMarker2, ...
                'XData', [sliderVal sliderVal]);
            ECInfoNest.valSliderFit2 = sliderVal;
        end
        
        ECInfoNest.waterfallPlot = waterfallPlotNest;
        figEC.UserData = ECInfoNest;
    end

    %% find which fit slider is closer
    
    function numCloser = closerSlider(sliderVal, slider1, slider2)
        if abs(sliderVal - slider1) < abs(sliderVal - slider2)
            numCloser = 1;
        else
            numCloser = 2;
        end
    end

    %% fit sliders callback
    
    function sliderECFitCallback(src, evt, sb, ECHandles)
        parentfig = get(sb, 'Parent');
        if parentfig ~= 0
            set(parentfig, ...
                'WindowButtonMotionFcn', {@sliderECFitClick, ECHandles}, ...
                'WindowButtonUpFcn', {@buttonUpECFit, parentfig});
            sliderECFitClick(src, evt, ECHandles);
        end
    end

    %% fit sliders button up function
    
    function buttonUpECFit(src, evt, sb)
        set(sb, 'WindowButtonMotionFcn', []);
    end

    %% slider for ternary plot callback
    
    function sliderECHorCallback(src, evt, sb, ternHandles, specHandles, ECHandles)
        
        parentfig = get(sb, 'Parent');
        if parentfig ~= 0
            set(parentfig, ...
                'WindowButtonMotionFcn', {@sliderECClickHor, ...
                ternHandles, specHandles, ECHandles}, ...
                'WindowButtonUpFcn', {@buttonUpECHor, parentfig});
            sliderECClickHor(src, evt, ternHandles, specHandles, ECHandles);
        end
    end

    %% slider for ternary plot button up function
    
    function buttonUpECHor(src, evt, sb)
        set(sb, 'WindowButtonMotionFcn', []);
    end
end

