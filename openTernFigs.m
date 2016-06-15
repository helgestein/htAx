    function [] = openTernFigs(saveFile, data, A, B, C, numSelected, pointInfo)
    %UNTITLED5 Summary of this function goes here
    %   Detailed explanation goes here

    %% parameters

    ternPlotType = 0; % 0 = scatter; 1 = surf
    constPercent = 0;
    width = 0;
    constType = 0; % 0 for A, 1 for B, 2 for C
    xIndex = 1;
    specFigsOpen = 0; % 0 for unopen, 1 for open
    scaleType = 1; % 1 for none, 2 for sqrt, 3 for log
    global fSpecButtons;
    global fSpecPlot;
    global ySpecComp2;
    global ySpec;
    global sliderPlot;
    regionHighlighted = 0;
    global highlighted;
    dotSize = 30;

    % precalculate to save time
    sqrt3Half = sqrt(3) / 2;
    sqrt3Inv = 1 / sqrt(3);

    axesSet = 0;

    zMax = 1000; % large z-value for plotting points above surface plot

    maxComp = 0; % max composition value

    % positions of vertical sliders
    sliderVert1Val = 0;
    sliderVert2Val = 0;

    %% create tern windows

    fButtons = figure('Visible', 'off', ...
        'Units', 'Normalized', ...
        'Position', [0 0.7 0.4 0.2]);
    fTernDiagram = figure('Visible', 'off', ...
        'Units', 'Normalized', ...
        'Position', [0 0 0.4 0.45]);

    % set background to white
    figure(fButtons);
    set(gcf, 'color', 'w');
    figure(fTernDiagram);
    set(gcf, 'color', 'w');

    % set tabs in button window
    tabsTern = uitabgroup('Parent', fButtons);
    tabComp = uitab('Parent', tabsTern, 'Title', 'Select comp.');
    tabStyle = uitab('Parent', tabsTern, 'Title', 'Plot style');
    tabPostProcess = uitab('Parent', tabsTern, 'Title', 'Post-process');

    %% components

    % components in composition tab

    leftColOffset = 0.05;
    topRowOffset = 0.7;
    textWidth = 0.1;
    textHeight = 0.15;
    textSpacingVert = 0.25;
    colSpacing = 0.1;

    htextConst = uicontrol('Parent', tabComp, 'Style', 'text', ...
        'String', 'Comp.', ...
        'Units', 'Normalized', ...
        'Position', [leftColOffset topRowOffset textWidth textHeight]);
    htextWidth = uicontrol('Parent', tabComp, 'Style', 'text', ...
        'String', 'Width', ...
        'Units', 'Normalized', ...
        'Position', [leftColOffset (topRowOffset - textSpacingVert) ...
        textWidth textHeight]);
    heditConst = uicontrol('Parent', tabComp, 'Style', 'edit', ...
        'Units', 'Normalized', ...
        'Position', [(leftColOffset + colSpacing) topRowOffset ...
        textWidth textHeight], ...
        'Callback', {@editConstCallback});
    heditWidth = uicontrol('Parent', tabComp, 'Style', 'edit', ...
        'Units', 'Normalized', ...
        'Position', [(leftColOffset + colSpacing) (topRowOffset - textSpacingVert) ...
        textWidth textHeight], ...
        'Callback', {@editWidthCallback});

    buttonColOffset = leftColOffset + textWidth + colSpacing + textWidth + 0.2;
    buttonWidth = textWidth;
    buttonHeight = textHeight;

    hbuttonA = uicontrol('Parent', tabComp, 'Style', 'pushbutton', ...
        'String', 'A', ...
        'Units', 'Normalized', ...
        'Position', [buttonColOffset topRowOffset buttonWidth buttonHeight], ...
        'Callback', {@buttonACallback});
    hbuttonB = uicontrol('Parent', tabComp, 'Style', 'pushbutton', ...
        'String', 'B', ...
        'Units', 'Normalized', ...
        'Position', [buttonColOffset (topRowOffset - textSpacingVert) ...
        buttonWidth buttonHeight], ...
        'Callback', {@buttonBCallback});
    hbuttonC = uicontrol('Parent', tabComp, 'Style', 'pushbutton', ...
        'String', 'C', ...
        'Units', 'Normalized', ...
        'Position', [buttonColOffset (topRowOffset - textSpacingVert * 2) ...
        buttonWidth buttonHeight], ...
        'Callback', {@buttonCCallback});

    % components in style tab

    buttonWidth = 0.2;
    buttonHeight = textHeight;
    middleHor = 0.5 - buttonWidth / 2;
    topRowOffset = 0.7;
    rowSpace = 0.2;
    leftColOffset = 0.05;
    rightColOffset = 0.6;
    textWidth = 0.1;
    textHeight = 0.15;
    
    hbuttonScatter = uicontrol('Parent', tabStyle, 'Style', 'pushbutton', ...
        'String', 'Scatter', ...
        'Units', 'Normalized', ...
        'Position', [leftColOffset topRowOffset buttonWidth buttonHeight], ...
        'Callback', {@buttonScatterCallback});
    hbuttonSurf = uicontrol('Parent', tabStyle, 'Style', 'pushbutton', ...
        'String', 'Surface', ...
        'Units', 'Normalized', ...
        'Position', [leftColOffset (topRowOffset - rowSpace) ...
        buttonWidth buttonHeight], ...
        'Callback', {@buttonSurfCallback});
    htextSize = uicontrol('Parent', tabStyle, 'Style', 'text', ...
        'String', 'Dot size', ...
        'Units', 'Normalized', ...
        'Position', [rightColOffset topRowOffset textWidth textHeight]);
    heditSize = uicontrol('Parent', tabStyle, 'Style', 'edit', ...
        'Units', 'Normalized', ...
        'Position', [rightColOffset (topRowOffset - rowSpace) ...
        textWidth textHeight], ...
        'Callback', {@editSizeCallback});

    % components in post process tab

    buttonWidth = 0.2;
    buttonHeight = textHeight;
    middleHor = 0.5 - buttonWidth / 2;
    topRowOffset = 0.7;
    rowSpace = 0.2;
    leftColOffset = 0.1;
    rightColOffset = 0.6;

    hbuttonPoint = uicontrol('Parent', tabPostProcess, ...
        'Style', 'pushbutton', ...
        'String', 'Restore settings', ...
        'Units', 'Normalized', ...
        'Position', [leftColOffset topRowOffset buttonWidth buttonHeight], ...
        'Callback', {@buttonPointCallback});
    hbuttonDelete = uicontrol('Parent', tabPostProcess, ...
        'Style', 'pushbutton', ...
        'String', 'Delete selection', ...
        'Units', 'Normalized', ...
        'Position', [leftColOffset (topRowOffset - rowSpace) ...
        buttonWidth buttonHeight], ...
        'Callback', {@buttonDeleteCallback});
    hbuttonSaveAll = uicontrol('Parent', tabPostProcess, ...
        'Style', 'pushbutton', ...
        'String', 'Save analysis', ...
        'Units', 'Normalized', ...
        'Position', [rightColOffset topRowOffset ...
        buttonWidth buttonHeight], ...
        'Callback', {@buttonSaveAllCallback});
    hbuttonClose = uicontrol('Parent', tabPostProcess, ...
        'Style', 'pushbutton', ...
        'String', 'Close', ...
        'Units', 'Normalized', ...
        'Position', [rightColOffset (topRowOffset - rowSpace) ...
        buttonWidth buttonHeight], ...
        'Callback', {@buttonCloseCallback});
    hbuttonSaveClose = uicontrol('Parent', tabPostProcess, ...
        'Style', 'pushbutton', ...
        'String', 'Save and close', ...
        'Units', 'Normalized', ...
        'Position', [rightColOffset (topRowOffset - rowSpace * 2) ...
        buttonWidth buttonHeight], ...
        'Callback', {@buttonSaveCloseCallback});

    %% process and plot data

    % get rectangular coordinates for ternary diagram
    numTernPoints = length(A);
    xTernCoordAll = zeros(numTernPoints, 1);
    yTernCoordAll = zeros(numTernPoints, 1);
    for i = 1:numTernPoints
        [xTernCoordAll(i), yTernCoordAll(i)] = ...
            getTernCoord(A(i), B(i), sqrt3Half, sqrt3Inv);
    end

    figure(fTernDiagram);
    axesTernary = axes('Units','Normalized','Position',[0.1, 0.1, 0.8, 0.8]);
    htextAngle = uicontrol(fTernDiagram, 'Style', 'text', ...
        'String', strcat({'Angle: '}, num2str(data(xIndex, 1))), ...
        'Units', 'Normalized', ...
        'Position', [0.05 0.9 0.2 0.05]);
    hold on;
    figure(fTernDiagram);
    plotTernData(0);
    hold off;

    %% make GUI visible

    fButtons.Visible = 'on';
    fTernDiagram.Visible = 'on';

    %% callbacks

        %% tern composition tab
        
        function resetConstPercent()
            constPercent = 0;
            set(heditConst, 'String', '0');
        end

        function resetWidth()
            width = 0;
            set(heditWidth, 'String', '0');
        end

        function editConstCallback(heditConst, eventdata, handles)
            constPercent = str2double(get(heditConst, 'String')) / 100;
            if isnan(constPercent)
                errordlg('not a number');
                resetConstPercent();
            elseif constPercent < 0
                errordlg('invalid composition percent');
                resetConstPercent();
            elseif constPercent > 1
                errordlg('invalid composition percent');
                resetConstPercent();
            elseif (constPercent + width) > 1
                errordlg('invalid width-percent combination');
                resetConstPercent();
            elseif (constPercent - width) < 0
                errordlg('invalid width-percent combination');
                resetConstPercent();
            end
        end

        function editWidthCallback(heditWidth, eventdata, handles)
            width = str2double(get(heditWidth, 'String')) / 100;
            if isnan(width)
                errordlg('not a number');
                resetWidth();
            elseif width < 0
                errordlg('invalid width');
                resetWidth();
            elseif width > 1
                errordlg('invalid width');
                resetWidth();
            elseif (constPercent + width) > 1
                errordlg('invalid width-percent combination');
                resetWidth();
            elseif (constPercent - width) < 0
                errordlg('invalid width-percent combination');
                resetWidth();
            end
        end

        function buttonACallback(hbuttonA, eventdata, handles)
            constType = 0;
            %{
            if specFigsOpen == 0
                [hbuttonScaleSqrt, hbuttonScaleLog, ...
                    hbuttonScaleNone, hbuttonSave, ...
                    fSpecButtons, fSpecPlot] = openSpecFigs();

                setSpecCallbacks(hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave);

                specFigsOpen = 1;
            end
            %}
            plotSpecData(scaleType);
        end

        function buttonBCallback(hbuttonB, eventdata, handles)
            constType = 1;
            %{
            if specFigsOpen == 0
                [hbuttonScaleSqrt, hbuttonScaleLog, ...
                    hbuttonScaleNone, hbuttonSave, ...
                    fSpecButtons, fSpecPlot] = openSpecFigs();
                setSpecCallbacks(hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave);
                specFigsOpen = 1;
            end
            %}
            plotSpecData(scaleType);
        end

        function buttonCCallback(hbuttonC, eventdata, handles)
            constType = 2;
            %{
            if specFigsOpen == 0
                [hbuttonScaleSqrt, hbuttonScaleLog, ...
                    hbuttonScaleNone, hbuttonSave, ...
                    fSpecButtons, fSpecPlot] = openSpecFigs();
                setSpecCallbacks(hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave);
                specFigsOpen = 1;
            end
            %}
            plotSpecData(scaleType);
        end

        %% tern style tab

        function buttonScatterCallback(hbuttonScatter, eventdata, handles)
            ternPlotType = 0;
            plotTernData(ternPlotType);
        end

        function buttonSurfCallback(hbuttonSurf, eventdata, handles)
            ternPlotType = 1;
            plotTernData(ternPlotType);
        end
    
        function resetDotSize()
            dotSize = 30;
            set(heditSize, 'String', '30');
        end
    
        function editSizeCallback(heditSize, eventdata, handles)
            dotSize = str2double(get(heditSize, 'String'));
            if isnan(dotSize) == 1
                errordlg('not a number');
                resetDotSize();
            elseif dotSize < 0
                errordlg('not a valid dot size');
                resetDotSize();
            end
            plotTernData(ternPlotType);
        end

        %% tern post process tab

        function buttonPointCallback(hbuttonPoint, eventdata, handles)
            figure(fTernDiagram);
            [xSelect, ySelect] = ginput(1);
            indexPoint = findNearestSelection(xSelect, ySelect);
            xIndex = pointInfo(indexPoint, 6);
            constPercent = pointInfo(indexPoint, 7);
            width = pointInfo(indexPoint, 8);
            constType = pointInfo(indexPoint, 9);
            ternPlotType = pointInfo(indexPoint, 10);
            scaleType = pointInfo(indexPoint, 11);

            % plot with restored settings
            plotTernData(ternPlotType);
            plotSpecData(scaleType);

            set(heditConst, 'String', constPercent * 100);
            set(heditWidth, 'String', width * 100);

            % set horizontal slider
            sliderVal = data(pointInfo(indexPoint, 6), 1);
            set(sliderPlot.SliderMarker,'XData',sliderVal);
            set(sliderPlot.AngleMarker,'XData',[sliderVal sliderVal]);
            set(htextAngle, 'String', strcat({'Angle: '}, num2str(data(xIndex, 1))));

            % set vertical slider

            % find index of other point
            if mod(indexPoint, 2) == 0
                partnerIndex = indexPoint - 1;
            else
                partnerIndex = indexPoint + 1;
            end

            if constType == 0
                comp1 = pointInfo(indexPoint, 4);
                comp2 = pointInfo(partnerIndex, 4);
            elseif constType == 1
                comp1 = pointInfo(indexPoint, 5);
                comp2 = pointInfo(partnerIndex, 5);
            else
                comp1 = pointInfo(indexPoint, 3);
                comp2 = pointInfo(partnerIndex, 3);
            end

            set(sliderPlot.SliderMarkerVert, 'YData', comp1);
            set(sliderPlot.CompMarker, 'YData', [comp1 comp1]);
            sliderVert1Val = comp1;
            set(sliderPlot.SliderMarkerVert2, 'YData', comp2);
            set(sliderPlot.CompMarker2, 'YData', [comp2 comp2]);
            sliderVert2Val = comp2;
        end

        function buttonSaveAllCallback(hbuttonSaveAll, eventdata, handles)
            info.data = data;
            info.A = A;
            info.B = B;
            info.C = C;
            info.numSelected = numSelected;
            info.pointInfo = pointInfo;
            save(saveFile, '-struct', 'info');
        end

        function buttonCloseCallback(hbuttonClose, eventdata, handles)
            close(fButtons);
            close(fTernDiagram);
            if ishandle(fSpecButtons) ~= 0
                close(fSpecButtons);
            end
            if ishandle(fSpecPlot) ~= 0
                close(fSpecPlot);
            end
        end

        function buttonSaveCloseCallback(hbuttonSaveClose, eventdata, handles)
            buttonSaveAllCallback();
            buttonCloseCallback();
        end

        function buttonDeleteCallback(hbuttonDelete, eventdata, handles)
            figure(fTernDiagram);
            [xSelect, ySelect] = ginput(1);
            indexPoint = findNearestSelection(xSelect, ySelect);

            % find index of other point
            if mod(indexPoint, 2) == 0
                partnerIndex = indexPoint - 1;
            else
                partnerIndex = indexPoint + 1;
            end

            numSelected = numSelected - 2;
            pointInfo = removerows(pointInfo, [indexPoint, partnerIndex]);

            plotTernData(ternPlotType);
        end

        %% spec style tab

        function buttonScaleSqrtCallback(hbuttonScaleSqrt, eventdata, handles)
            scaleType = 2;
            plotSpecData(scaleType);
        end

        function buttonScaleLogCallback(hbuttonScaleLog, eventdata, handles)
            scaleType = 3;
            plotSpecData(scaleType);
        end

        function buttonScaleNoneCallback(hbuttonScaleNone, eventdata, handles)
            scaleType = 1;
            plotSpecData(scaleType);
        end

        %% spec point tab

        function buttonSaveCallback(hbuttonSave, eventdata, handles)
            numSelected = numSelected + 2;
            [compA1, compB1, compC1] = getComp(sliderVert1Val);
            [compA2, compB2, compC2] = getComp(sliderVert2Val);
            [xTernCoord1, yTernCoord1] = ...
                getTernCoord(compA1, compB1, sqrt3Half, sqrt3Inv);
            [xTernCoord2, yTernCoord2] = ...
                getTernCoord(compA2, compB2, sqrt3Half, sqrt3Inv);
            %xSelected(numSelected - 1) = xTernCoord1;
            %ySelected(numSelected - 1) = yTernCoord1;
            pointInfo(numSelected - 1, :) = [xTernCoord1 yTernCoord1 compA1 compB1 compC1 xIndex constPercent width constType ternPlotType scaleType];
            %xSelected(numSelected) = xTernCoord2;
            %ySelected(numSelected) = yTernCoord2;
            pointInfo(numSelected, :) = [xTernCoord2 yTernCoord2 compA2 compB2 compC2 xIndex constPercent width constType ternPlotType scaleType];

            % plot user-selected points
            figure(fTernDiagram);
            hold on;
            scatter3(axesTernary, xTernCoord1, yTernCoord1, zMax, 30, 'r', 'filled');
            scatter3(axesTernary, xTernCoord2, yTernCoord2, zMax, 30, 'r', 'filled');
            hold off;

            % plot user-selected line
            figure(fTernDiagram);
            hold on;
            plot3(axesTernary, [xTernCoord1 xTernCoord2], [yTernCoord1 yTernCoord2], ...
                [zMax zMax], 'r');
            hold off;
        end

    %% helper functions

        %% returns distance between two points

        function sqDist = squareDistance(x1, y1, x2, y2)
            sqDist = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
        end

        %% find index of nearest selected point to mouse click

        function minIndex = findNearestSelection(xSelect, ySelect)
            minDist = realmax;
            minIndex = 1;
            for indexSearch = 1:numSelected
                distTemp = squareDistance(xSelect, ySelect, pointInfo(indexSearch, 1), pointInfo(indexSearch, 2));
                if distTemp < minDist
                    minDist = distTemp;
                    minIndex = indexSearch;
                end
            end
        end

        %% sets callbacks for spec. buttons

        function setSpecCallbacks(hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave)
            set(hbuttonScaleSqrt, 'Callback', {@buttonScaleSqrtCallback});
            set(hbuttonScaleLog, 'Callback', {@buttonScaleLogCallback});
            set(hbuttonScaleNone, 'Callback', {@buttonScaleNoneCallback});
            set(hbuttonSave, 'Callback', {@buttonSaveCallback});
        end

        %% gets the composition of a point on spec. plot

        function [compA, compB, compC] = getComp(yClick)
            [nearestVal, yIndex] = min(abs(ySpec - yClick));

            if constType == 0
                compA = ySpecComp2(yIndex);
                compB = ySpec(yIndex);
                compC = 1 - compA - compB;
            elseif constType == 1
                compB = ySpecComp2(yIndex);
                compC = ySpec(yIndex);
                compA = 1 - compB - compC;
            else
                compC = ySpecComp2(yIndex);
                compA = ySpec(yIndex);
                compB = 1 - compA - compC;
            end
        end


        %% plots ternary data

        function plotTernData(ternPlotType)

            % plot gridlines
            figure(fTernDiagram);
            hold off; % clear previous figure
            plotTernBase(axesTernary, sqrt3Half, sqrt3Inv);
            hold on;

            highlightTernRegion();

            if ternPlotType == 0
                plotTernScatter(xTernCoordAll, yTernCoordAll, ...
                    data(xIndex, 2 .* (1:numTernPoints)), axesTernary, dotSize);
            else
                plotTernSurf(xTernCoordAll, yTernCoordAll, ...
                    data(xIndex, 2 .* (1:numTernPoints)));
            end

            if numSelected ~= 0
                zVals = zMax * ones(numSelected, 1);
                scatter3(axesTernary, pointInfo(:, 1), pointInfo(:, 2), zVals, 30, 'r', 'filled');
                i = 1;
                hold on;
                while i <= numSelected - 1
                    hold on;
                    plot3(axesTernary, [pointInfo(i, 1) pointInfo(i + 1, 1)], ...
                        [pointInfo(i, 2) pointInfo(i + 1, 2)], ...
                        [zMax zMax], 'r');
                    i = i + 2;
                    hold on;
                end
            end
        end

        %% plots spec data

        function plotSpecData(scaling)

            % get the correct set of composition data
            if constType == 0
                ids = getSpecIDs(constPercent, width, A);
                ySpec = B(ids);
                ySpecComp2 = A(ids);
            elseif constType == 1
                ids = getSpecIDs(constPercent, width, B);
                ySpec = C(ids);
                ySpecComp2 = B(ids);
            else
                ids = getSpecIDs(constPercent, width, C);
                ySpec = A(ids);
                ySpecComp2 = C(ids);
            end

            if isempty(ids) == 1
                errordlg('No points selected');
            else
                ids = ids .* 2;   
                if specFigsOpen == 0
                    [hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave, fSpecButtons, fSpecPlot] = openSpecFigs();
                    setSpecCallbacks(hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave);
                    specFigsOpen = 1;   
                end
                sliderPlot = plotSpecSliders(data(:, 1), data(:, ids), ySpec, scaling);
            end

        end

        %% plot selected region on the ternary diagram

        function highlightTernRegion()
            if ternPlotType == 1
                return;
            end
            if regionHighlighted == 1
                delete(highlighted);
            end
            upper = constPercent + width;
            lower = constPercent - width;
            if constType == 0
                [x(1), y(1)] = getTernCoord(upper, 1 - upper, sqrt3Half, sqrt3Inv);
                [x(2), y(2)] = getTernCoord(lower, 1 - lower, sqrt3Half, sqrt3Inv);
                [x(3), y(3)] = getTernCoord(lower, 0, sqrt3Half, sqrt3Inv);
                [x(4), y(4)] = getTernCoord(upper, 0, sqrt3Half, sqrt3Inv);
            elseif constType == 1
                [x(1), y(1)] = getTernCoord(0, upper, sqrt3Half, sqrt3Inv);
                [x(2), y(2)] = getTernCoord(0, lower, sqrt3Half, sqrt3Inv);
                [x(3), y(3)] = getTernCoord(1 - lower, lower, sqrt3Half, sqrt3Inv);
                [x(4), y(4)] = getTernCoord(1 - upper, upper, sqrt3Half, sqrt3Inv);
            else
                [x(1), y(1)] = getTernCoord(1 - upper, 0, sqrt3Half, sqrt3Inv);
                [x(2), y(2)] = getTernCoord(1 - lower, 0, sqrt3Half, sqrt3Inv);
                [x(3), y(3)] = getTernCoord(0, 1 - lower, sqrt3Half, sqrt3Inv);
                [x(4), y(4)] = getTernCoord(0, 1 - upper, sqrt3Half, sqrt3Inv);
            end
            z = [zMax zMax zMax zMax];
            figure(fTernDiagram);
            hold on;
            highlighted = fill3(x, y, z, [0.5 0.5 0.5]);
            set(highlighted, 'EdgeColor', 'none');
            alpha(highlighted, 0.1);
            regionHighlighted = 1;
            view(2);
        end

        %% creates slider and spec. plot

        function sb = plotSpecSliders(xAxis, yAxis, composition,scaling)

            highlightTernRegion();

            % setup; partially copied from CombiView
            figure(fSpecPlot);
            sb.SBFigure = fSpecPlot;

            % set up the axes

            % setting positions for the graphs
            graphHeightFrac = 0.8;
            graphVertPosFrac = 0.15;
            graphHorPosFrac = 0.07;
            graphWidthFrac = 0.8;
            sliderWidthFrac = 0.02;
            sliderVertWidthFrac = 0.01;

            % rectangle position defined by [left, bottom, width, height];
            sb.DataAxes = axes(...
                      'Units', 'Normalized',...
                      'Position',[graphHorPosFrac graphVertPosFrac ...
                      graphWidthFrac graphHeightFrac], ...
                      'XTick',[],'YTick',[], ...
                      'Box','on');
            sb.SliderAxes = axes(...
                       'Units', 'Normalized', ...
                      'Position',[graphHorPosFrac ...
                      graphVertPosFrac + graphHeightFrac ...
                      graphWidthFrac sliderWidthFrac], ...
                      'XTick',[], ...
                      'YTick',[], ...
                      'YLim',[0 1], ...
                      'Box','on');
            Range.X = [min(xAxis) max(xAxis)];
            sb.SliderAxesVert = axes(...
                        'Units', 'Normalized', ...
                       'Position', [(graphHorPosFrac + graphWidthFrac) ...
                       graphVertPosFrac ...
                       sliderVertWidthFrac graphHeightFrac], ...
                       'XTick', [], ...
                       'YTick', [], ...
                       'XLim', [0 1], ...
                       'Box', 'on');
            Range.Y = [min(composition) max(composition)];
            maxComp = max(composition);

            axes(sb.DataAxes);

            % plot the data

            % sort data according to composition
            [sComposition,ID] = sort(composition); 

            % create what is nessesary for surf plot
            [x,y] = meshgrid(xAxis, sComposition); 

            % select the scaling function
            if (scaling == 2)
                yAxis = sqrt(yAxis);
            end 
            if (scaling == 3)
                yAxis = log10(yAxis);
            end 

            figure(fSpecPlot);

            hold off;

            sb.DataPlots = surf(x, y, yAxis(:,ID).');
            %hold on;
            % remove multiple axes labels
            if axesSet ~= 0
                set(sb.DataAxes, 'XTick', [], 'YTick', []);
            end
            axes(sb.DataAxes);

            if axesSet == 0
                xlabel('Angle'); 
                ylabel('Composition');
                axesSet = 1;
            end

           % make plot look good
           shading('interp');
           axis('tight');
           view(2);

           hold on;
           set(sb.SliderAxes, 'ButtonDownFcn', {@buttondownfcn, sb.SliderAxes});
           set(sb.SliderAxesVert, 'ButtonDownFcn', {@sliderVertCallback, sb.SliderAxesVert});

           set(sb.DataAxes,'XLim',Range.X);
           set(sb.DataAxes, 'YLim', Range.Y);
           set(sb.SBFigure, 'BusyAction', 'cancel');
           setappdata(sb.SBFigure,'forcedclose','0');

            % Create a "slider" to select angle

            % horizontal slider    
            axes(sb.SliderAxes);
            set(sb.SliderAxes,'XLim',Range.X);
            hold on;
            sb.SliderLine = plot(Range.X,[.5 .5],'-r');      
            sb.SliderMarker = plot(Range.X(1),.5,'rv','MarkerFaceColor','r');
            axes(sb.DataAxes);        
            hold on;
            sb.AngleMarker = ...
                plot([Range.X(1) Range.X(1)],get(sb.DataAxes,'YLim'),'r');

            % vertical sliders
            hold on;
            axes(sb.SliderAxesVert);
            set(sb.SliderAxesVert, 'YLim', Range.Y);
            hold on;
            sb.SliderLineVert = plot([.5 .5], Range.Y, '-r');
            sb.SliderMarkerVert = plot(.5, Range.Y(1), '<','MarkerFaceColor','r');
            sliderVert1Val = Range.Y(1);
            sb.SliderMarkerVert2 = plot(.5, Range.Y(2), '<', 'MarkerFaceColor', 'r');
            sliderVert2Val = Range.Y(2);
            axes(sb.DataAxes);
            hold on;
            sb.CompMarker = ...
                plot(get(sb.DataAxes, 'XLim'), [Range.Y(1) Range.Y(1)], 'r');
            sb.CompMarker2 = ...
                plot(get(sb.DataAxes, 'XLim'), [Range.Y(2) Range.Y(2)], 'r');

            % bring slider axes to the front
            uistack(sb.SliderAxes,'top');
            uistack(sb.SliderAxesVert, 'top');

            % set callback functions for sliders
            set(sb.SliderAxes,'ButtonDownFcn', ...
                {@buttondownfcn, sb.SliderAxes});
            set(sb.SliderLine,'ButtonDownFcn', ...
                {@buttondownfcn, sb.SliderAxes});
            set(sb.SliderMarker,'ButtonDownFcn', ...
                {@buttondownfcn, sb.SliderAxes});        
            set(sb.SliderAxesVert, 'ButtonDownFcn', ...
                {@sliderVertCallback, sb.SliderAxesVert});
            set(sb.SliderLineVert, 'ButtonDownFcn', ...
                {@sliderVertCallback, sb.SliderAxesVert});
            set(sb.SliderMarkerVert, 'ButtonDownFcn', ...
                {@sliderVertCallback, sb.SliderAxesVert});
            set(sb.SliderMarkerVert2, 'ButtonDownFcn', ...
                {@sliderVertCallback, sb.SliderAxesVert});

            %% determine where horizontal slider is and adjust ternary plot

            function sliderClick(src,evt,parentfig)          
                selected = get(sb.SliderAxes,'CurrentPoint');
                sliderVal = selected(1,1); % changed xNew to sliderVal for readability

                % find index of closest x value to the slider position
                [xApproxVal, xIndex] = min(abs(xAxis - sliderVal));

                % plot the ternary diagram again           
                plotTernData(ternPlotType);

                set(sb.SliderMarker,'XData',sliderVal);
                set(sb.AngleMarker,'XData',[sliderVal sliderVal]);    
                set(htextAngle, 'String', strcat({'Angle: '}, num2str(data(xIndex, 1))));
            end

            %% determine where vertical slider is

            function sliderClickVert(src, evt, parentfig)
                selected = get(sb.SliderAxesVert, 'CurrentPoint');
                sliderVal = selected(1, 2);

                if sliderVal >= 0
                    if sliderVal <= maxComp
                        sliderNum = closerSlider(sliderVal);
                        if sliderNum == 1
                            set(sb.SliderMarkerVert, 'YData', sliderVal);
                            set(sb.CompMarker, 'YData', [sliderVal sliderVal]);
                            sliderVert1Val = sliderVal;
                        else
                            set(sb.SliderMarkerVert2, 'YData', sliderVal);
                            set(sb.CompMarker2, 'YData', [sliderVal sliderVal]);
                            sliderVert2Val = sliderVal;
                        end
                    end
                end
            end

            %% determine which vertical slider is closer

            function [numCloser] = closerSlider(sliderVal)
                if abs(sliderVal - sliderVert1Val) < abs(sliderVal - sliderVert2Val)
                    numCloser = 1;
                else
                    numCloser = 2;
                end
            end

            %% sliderVertCallback

            function sliderVertCallback(src, evt, sb)
                parentfig = get(sb, 'Parent');
                if parentfig ~= 0
                    set(parentfig, ...
                        'WindowButtonMotionFcn', {@sliderClickVert, parentfig}, ...
                        'WindowButtonUpFcn', {@buttonupfcnVert, parentfig});
                    sliderClickVert(src, evt,  parentfig);
                end
            end

            %% buttondownfcn

            function buttondownfcn (src, evt, sb)
                parentfig = get(sb,'Parent');
                if parentfig ~= 0
                    set(parentfig, ...
                        'WindowButtonMotionFcn', {@sliderClick, parentfig}, ...
                        'WindowButtonUpFcn', {@buttonupfcn, parentfig});  
                    sliderClick(src,evt,parentfig);
                end
            end

            %% windowbuttonupfcn

            function buttonupfcn (src, evt, sb)
                set(sb, 'WindowButtonMotionFcn', [])
            end

            %% buttonupfcnVert

            function buttonupfcnVert(src, evt, sb)
                set(sb, 'WindowButtonMotionFcn', [])
            end

        end
    end

