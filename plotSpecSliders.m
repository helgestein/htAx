function plotSpecSliders(fig, ...
    xAxis, yAxis, composition, scaling, ternHandles, specHandles, ECHandles)
%PLOTSPECSLIDERS plots the spec. data with sliders
    
    %figTern = ternHandles.fTernDiagram;
    %ternInfo = figTern.UserData;
   
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;

    figure(fig);
    clf;
    sliderPlot.fig = fig;
    
    % set up the axes

    % setting positions for the graphs
    graphHeightFrac = 0.8;
    graphVertPosFrac = 0.15;
    graphHorPosFrac = 0.07;
    graphWidthFrac = 0.8;
    sliderWidthFrac = 0.02;
    sliderVertWidthFrac = 0.01;
    
    sliderPlot.dataAxes = axes(...
        'Units', 'Normalized', ...
        'Position', [graphHorPosFrac graphVertPosFrac ...
        graphWidthFrac graphHeightFrac], ...
        'XTick', [], 'YTick', [], ...
        'Box', 'on');
    sliderPlot.sliderAxes = axes(...
        'Units', 'Normalized', ...
        'Position', [graphHorPosFrac (graphVertPosFrac + graphHeightFrac) ...
        graphWidthFrac sliderWidthFrac], ...
        'XTick', [], 'YTick', [], ...
        'YLim', [0 1], ...
        'Box', 'on');
    sliderPlot.sliderAxesVert = axes(...
        'Units', 'Normalized', ...
        'Position', [(graphHorPosFrac + graphWidthFrac) graphVertPosFrac ...
        sliderVertWidthFrac graphHeightFrac], ...
        'XTick', [], 'YTick', [], ...
        'XLim', [0 1], ...
        'Box', 'on');
    Range.X = [min(xAxis) max(xAxis)];
    Range.Y = [min(composition) max(composition)];
    %maxComp = max(composition);
    
    axes(sliderPlot.dataAxes);
    
    [sComposition, ID] = sort(composition);
    [x, y] = meshgrid(xAxis, sComposition);
    
    if scaling == 2
        yAxis = sqrt(yAxis);
    elseif scaling == 3
        yAxis = log10(yAxis);
    end
    
    figure(fig);
    hold off;
    sliderPlot.dataPlots = surf(x, y, yAxis(:, ID).');
    
    shading('interp');
    axis('tight');
    view(2);
    
    axes(sliderPlot.dataAxes);
    
    xlabel('Angle');
    ylabel('Composition');
    set(sliderPlot.dataAxes, ...
        'XTickMode', 'auto', 'XTickLabelMode', 'auto', ...
        'YTickMode', 'auto', 'YTickLabelMode', 'auto');
    set(sliderPlot.dataAxes, 'XLim', Range.X);
    set(sliderPlot.dataAxes, 'YLim', Range.Y);
    set(sliderPlot.fig, 'BusyAction', 'cancel');
    setappdata(sliderPlot.fig, 'forcedclose', '0');
    
    % horizontal slider
    
    axes(sliderPlot.sliderAxes);
    set(sliderPlot.sliderAxes, 'XLim', Range.X);
    hold on;
    sliderPlot.sliderLine = plot(Range.X, [.5 .5], '-r');
    sliderPlot.sliderMarker = plot(Range.X(1), .5, 'rv', ...
        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
    axes(sliderPlot.dataAxes)
    hold on;
    sliderPlot.angleMarker = ...
        plot([Range.X(1) Range.X(1)], get(sliderPlot.dataAxes, 'YLim'), 'r');
    
    % vertical sliders
    
    hold on;
    axes(sliderPlot.sliderAxesVert);
    set(sliderPlot.sliderAxesVert, 'YLim', Range.Y);
    hold on;
    sliderPlot.sliderLineVert = plot([.5 .5], Range.Y, '-r');
    sliderPlot.sliderMarkerVert = plot(.5, Range.Y(1), '<', ...
        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
    specInfo.valSliderVert1 = Range.Y(1);
    sliderPlot.sliderMarkerVert2 = plot(.5, Range.Y(2), '<', ...
        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
    specInfo.valSliderVert2 = Range.Y(2);
    axes(sliderPlot.dataAxes);
    sliderPlot.compMarker = ...
        plot(get(sliderPlot.dataAxes, 'XLim'), ...
        [Range.Y(1) Range.Y(1)], 'r', 'LineWidth', 2);
    sliderPlot.compMarker2 = ...
        plot(get(sliderPlot.dataAxes, 'XLim'), ...
        [Range.Y(2) Range.Y(2)], 'r', 'LineWidth', 2);
    
    % bring slider axes to the front
    uistack(sliderPlot.sliderAxes, 'top');
    uistack(sliderPlot.sliderAxesVert, 'top');
    
    set(sliderPlot.sliderAxes, 'ButtonDownFcn', ...
        {@sliderHorCallback, sliderPlot.sliderAxes, ternHandles, specHandles, xAxis, ECHandles});
    set(sliderPlot.sliderLine, 'ButtonDownFcn', ...
        {@sliderHorCallback, sliderPlot.sliderAxes, ternHandles, specHandles, xAxis, ECHandles});
    set(sliderPlot.sliderMarker, 'ButtonDownFcn', ...
        {@sliderHorCallback, sliderPlot.sliderAxes, ternHandles, specHandles, xAxis, ECHandles});
    set(sliderPlot.sliderAxesVert, 'ButtonDownFcn', ...
        {@sliderVertCallback, sliderPlot.sliderAxesVert, specHandles});
    set(sliderPlot.sliderLineVert, 'ButtonDownFcn', ...
        {@sliderVertCallback, sliderPlot.sliderAxesVert, specHandles});
    set(sliderPlot.sliderMarkerVert, 'ButtonDownFcn', ...
        {@sliderVertCallback, sliderPlot.sliderAxesVert, specHandles});
    set(sliderPlot.sliderMarkerVert2, 'ButtonDownFcn', ...
        {@sliderVertCallback, sliderPlot.sliderAxesVert, specHandles});
    
    specInfo.sliderPlot = sliderPlot;
    fSpecPlot.UserData = specInfo;
    
    %% determine where horizontal slider is and adjust ternary plot
    
    function sliderClickHor(src, evt, ternHandles, specHandles, xAxis, ECHandles)
        
        figTern = ternHandles.fTernDiagram;
        ternInfo = figTern.UserData;
        
        figSpec = specHandles.fSpecPlot;
        specInfoNest = figSpec.UserData;
        
        sliderPlotNest = specInfoNest.sliderPlot;
        
        selected = get(sliderPlotNest.sliderAxes, 'CurrentPoint');
        sliderVal = selected(1, 1);
        
        % find index of closest x value to the slider position
        [~, angleIndex] = min(abs(xAxis - sliderVal));
        specInfoNest.angleIndex = angleIndex;
        
        % plot ternary diagram
        specInfoNest.sliderPlot = sliderPlotNest;
        figSpec.UserData = specInfoNest;
        
        plotTernData(ternHandles, specHandles, ECHandles);
        
        figSpec = specHandles.fSpecPlot;
        specInfoNest = figSpec.UserData;
        sliderPlotNest = specInfoNest.sliderPlot;
        
        set(sliderPlotNest.sliderMarker, 'XData', sliderVal);
        set(sliderPlotNest.angleMarker, 'XData', [sliderVal sliderVal]);
        if ternInfo.ternPlotType == 0
            set(ternInfo.textAngle, ...
                'String', strcat({'Angle: '}, ...
                num2str(specInfoNest.XRDData(angleIndex, 1))));
        elseif ternInfo.ternPlotType == 1
            set(ternInfo.textAngle, ...
                'String', strcat({'Angle: '}, ...
                num2str(specInfoNest.XRDData(angleIndex, 1))));
        end
        
        specInfoNest.sliderPlot = sliderPlotNest;
        figSpec.UserData = specInfoNest;
    end

    %% determine where vertical slider is
    
    function sliderClickVert(src, evt, specHandles)
        
        figSpec = specHandles.fSpecPlot;
        specInfoNest = figSpec.UserData;
        
        sliderPlotNest = specInfoNest.sliderPlot;
        slider1 = specInfoNest.valSliderVert1;
        slider2 = specInfoNest.valSliderVert2;
        
        selected = get(sliderPlotNest.sliderAxesVert, 'CurrentPoint');
        sliderVal = selected(1, 2);
        
        sliderNum = closerSlider(sliderVal, slider1, slider2);
        if sliderNum == 1
            set(sliderPlotNest.sliderMarkerVert, 'YData', sliderVal);
            set(sliderPlotNest.compMarker, 'YData', [sliderVal sliderVal]);
            specInfoNest.valSliderVert1 = sliderVal;
        else
            set(sliderPlotNest.sliderMarkerVert2, 'YData', sliderVal);
            set(sliderPlotNest.compMarker2, 'YData', [sliderVal sliderVal]);
            specInfoNest.valSliderVert2 = sliderVal;
        end
        
        specInfoNest.sliderPlot = sliderPlotNest;
        figSpec.UserData = specInfoNest;
        
    end

    %% find which vertical slider is closer

    function numCloser = closerSlider(sliderVal, slider1, slider2)
        if abs(sliderVal - slider1) < abs(sliderVal - slider2)
            numCloser = 1;
        else
            numCloser = 2;
        end
    end

    %% vertical slider callback
    
    function sliderVertCallback(src, evt, sb, specHandles)
        parentfig = get(sb, 'Parent');
        if parentfig ~= 0
            set(parentfig, ...
                'WindowButtonMotionFcn', {@sliderClickVert, specHandles}, ...
                'WindowButtonUpFcn', {@buttonUpVert, parentfig});
            sliderClickVert(src, evt, specHandles);
        end
    end

    %% horizontal slider callback
    
    function sliderHorCallback(src, evt, sb, ternHandles, specHandles, xAxis, ECHandles)
        parentfig = get(sb, 'Parent');
        if parentfig ~= 0
            set(parentfig, ...
                'WindowButtonMotionFcn', {@sliderClickHor, ...
                ternHandles, specHandles, xAxis, ECHandles}, ...
                'WindowButtonUpFcn', {@buttonUpHor, parentfig});
            sliderClickHor(src, evt, ternHandles, specHandles, xAxis, ECHandles);
        end
    end

    %% horizontal slider button up function
    
    function buttonUpHor(src, evt, sb)
        set(sb, 'WindowButtonMotionFcn', []);
    end

    %% vertical slider button up function
    
    function buttonUpVert(src, evt, sb)
        set(sb, 'WindowButtonMotionFcn', []);
    end

end

