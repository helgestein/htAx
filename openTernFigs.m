function [] = openTernFigs(saveFile, data, A, B, C, numSelected, pointInfo)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% parameters
ternPlotType = 0; % 0 = scatter; 1 = surf
constPercent = 0;
width = 0;
constType = 0; % 0 for A, 1 for B, 2 for C
xIndex = 1;
%yIndex = 1;
specFigsOpen = 0; % 0 for unopen, 1 for open
scaleType = 1; % 1 for none, 2 for sqrt, 3 for log
global fSpecPlot;
global ySpecComp2;
global ySpec;
global sliderPlot;

figButtonsLeft = 200;
figButtonsBottom = 500;
figButtonsWidth = 400;
figButtonsHeight = 310;

% precalculate to save time
sqrt3Half = sqrt(3) / 2;
sqrt3Inv = 1 / sqrt(3);

% saved points
%numSelected = 0;
%xSelected = zeros(1, 1);
%ySelected = zeros(1, 1);
%pointInfo = zeros(1, 11);

axesSet = 0;

zMax = 1000; % large z-value for plotting points above surface plot

% setting positions for the graphs
graphHeightFrac = 0.8;
graphVertPosFrac = 0.15;
graphHorPosFrac = 0.07;
graphWidthFrac = 0.8;
sliderWidthFrac = 0.02;
sliderVertWidthFrac = 0.01;

maxComp = 0; % max composition value

% positions of vertical sliders
sliderVert1Val = 0;
sliderVert2Val = 0;

%% create windows

figTernDiagramLeft = figButtonsLeft + figButtonsWidth + 100;
figTernDiagramBottom = figButtonsBottom;
figTernDiagramWidth = figButtonsWidth;
figTernDiagramHeight = figButtonsHeight;

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

hbuttonScatter = uicontrol('Parent', tabStyle, 'Style', 'pushbutton', ...
    'String', 'Scatter', ...
    'Units', 'Normalized', ...
    'Position', [middleHor topRowOffset buttonWidth buttonHeight], ...
    'Callback', {@buttonScatterCallback});
hbuttonSurf = uicontrol('Parent', tabStyle, 'Style', 'pushbutton', ...
    'String', 'Surface', ...
    'Units', 'Normalized', ...
    'Position', [middleHor (topRowOffset - rowSpace) ...
    buttonWidth buttonHeight], ...
    'Callback', {@buttonSurfCallback});

% components in post-process tab

buttonWidth = 0.2;
buttonHeight = textHeight;
middleHor = 0.5 - buttonWidth / 2;
topRowOffset = 0.7;
rowSpace = 0.2;

hbuttonPoint = uicontrol('Parent', tabPostProcess, ...
    'Style', 'pushbutton', ...
    'String', 'Restore settings', ...
    'Units', 'Normalized', ...
    'Position', [middleHor topRowOffset buttonWidth buttonHeight], ...
    'Callback', {@buttonPointCallback});
hbuttonSaveAll = uicontrol('Parent', tabPostProcess, ...
    'Style', 'pushbutton', ...
    'String', 'Save analysis', ...
    'Units', 'Normalized', ...
    'Position', [middleHor (topRowOffset - rowSpace) ...
    buttonWidth buttonHeight], ...
    'Callback', {@buttonSaveAllCallback});
    

%% get data

% import and read XRD and EDX data


%[xCoord, yCoord, data] = readXRDData(XRDFolder);
%[A, B, C] = ...
%    importEDXFile(EDXFile);

% convert EDX data to percents
%A = A ./ 100;
%B = B ./ 100;
%C = C ./ 100;

% FOR TEST FILE ONLY remove first five rows of EDX data
%rowsToRemove = 5;
%lengthNew = length(A) - rowsToRemove;
%ATemp = zeros(lengthNew);
%BTemp = zeros(lengthNew);
%CTemp = zeros(lengthNew);
%for i = (rowsToRemove + 1):length(A)
%    ATemp(i - rowsToRemove) = A(i);
%    BTemp(i - rowsToRemove) = B(i);
%    CTemp(i - rowsToRemove) = C(i);
%end    
%A = ATemp;
%B = BTemp;
%C = CTemp;

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
hold on;
figure(fTernDiagram);
plotTernData(0);
hold off;

%% make GUI visible

fButtons.Visible = 'on';
fTernDiagram.Visible = 'on';

%% callbacks

    % composition
    function editConstCallback(heditConst, eventdata, handles)
        constPercent = str2double(get(heditConst, 'String')) / 100;
    end
    function editWidthCallback(heditWidth, eventdata, handles)
        width = str2double(get(heditWidth, 'String')) / 100;
    end
    function buttonACallback(hbuttonA, eventdata, handles)
        constType = 0;

        if specFigsOpen == 0
            [hbuttonScaleSqrt, hbuttonScaleLog, ...
                hbuttonScaleNone, hbuttonSave, ...
                fSpecButtons, fSpecPlot] = openSpecFigs();

            setSpecCallbacks(hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave);

            specFigsOpen = 1;
        end
        plotSpecData(scaleType);
    end
    function buttonBCallback(hbuttonB, eventdata, handles)
        constType = 1;
        if specFigsOpen == 0
            [hbuttonScaleSqrt, hbuttonScaleLog, ...
                hbuttonScaleNone, hbuttonSave, ...
                fSpecButtons, fSpecPlot] = openSpecFigs();
            setSpecCallbacks(hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave);
            specFigsOpen = 1;
        end
        plotSpecData(scaleType);
    end
    function buttonCCallback(hbuttonC, eventdata, handles)
        constType = 2;
        if specFigsOpen == 0
            [hbuttonScaleSqrt, hbuttonScaleLog, ...
                hbuttonScaleNone, hbuttonSave, ...
                fSpecButtons, fSpecPlot] = openSpecFigs();
            setSpecCallbacks(hbuttonScaleSqrt, hbuttonScaleLog, hbuttonScaleNone, hbuttonSave);
            specFigsOpen = 1;
        end
        plotSpecData(scaleType);
    end
    
    % style
    function buttonScatterCallback(hbuttonScatter, eventdata, handles)
        ternPlotType = 0;
        plotTernData(ternPlotType);
    end
    function buttonSurfCallback(hbuttonSurf, eventdata, handles)
        ternPlotType = 1;
        plotTernData(ternPlotType);
    end

    % spec. windows
    
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
        save('/Users/sjiao/Documents/summer_2016/code/testFiles/testSave.mat', '-struct', 'info');
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
        
        if ternPlotType == 0
            plotTernScatter(xTernCoordAll, yTernCoordAll, ...
                data(xIndex, 2 .* (1:numTernPoints)), axesTernary);
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
        
        ids = ids .* 2;     
        sliderPlot = plotSpecSliders(data(:, 1), data(:, ids), ySpec, scaling); 

    end

%% creates slider and spec. plot
    
    function sb = plotSpecSliders(xAxis, yAxis, composition,scaling)
        
        % setup; partially copied from CombiView
        figure(fSpecPlot);
        sb.SBFigure = fSpecPlot;

        % set up the axes

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

