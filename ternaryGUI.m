function [] = ternaryGUI()
%TERNARYGUI Summary of this function goes here
%   Detailed explanation goes here

%% setup parameters

% figure windows
f1 = figure('Visible','off','Position',[200, 500, 400, 310]);
f2 = figure('Visible','off','Position',[700, 500, 600, 285]);

% set window backgrounds to white
figure(f1);
set(gcf, 'color', 'w');
figure(f2);
set(gcf, 'color', 'w');

% UI parameters
constType = 0; % constant = 0 for A, 1 for B, 2 for C
width = 0;
constPercent = 0;
xIndex = 1;
axesSet = 0;
ternPlotType = 0;
zMax = 1000;
graphHeightFrac = 0.8;
graphVertPosFrac = 0.15;
graphHorPosFrac = 0.07;
graphWidthFrac = 0.6;
sliderWidthFrac = 0.02;
maxComp = 0;
sliderVert1Val = 0;
sliderVert2Val = 0;

% precalculate to save time
sqrt3Half = sqrt(3) / 2;
sqrt3Inv = 1 / sqrt(3);

% save user-selected points
numSelected = 0;
xSelected = zeros(1, 1);
ySelected = zeros(1, 1);

% test folder
folder = '/Users/sjiao/Documents/summer_2016/data/CoFeMnO-mapcorr';

%% get data

% import and read XRD and EDX data
[xCoord, yCoord, data] = readXRDData(folder);
[A, B, C] = ...
    importEDXFile('/Users/sjiao/Documents/summer_2016/data/MnFeCoO-EDX');
    % file corresponds to test folder
    
% convert EDX data to percents
A = A ./ 100; 
B = B ./ 100;
C = C ./ 100;

% specifically for this test file, remove first five rows of EDX data
lengthNew = length(A) - 5;
ATemp = zeros(lengthNew);
BTemp = zeros(lengthNew);
CTemp = zeros(lengthNew);
for i = 6:length(A)
    ATemp(i - 5) = A(i);
    BTemp(i - 5) = B(i);
    CTemp(i - 5) = C(i);
end    
A = ATemp;
B = BTemp;
C = CTemp;

% get rectangular coordinates for ternary diagram
numTernPoints = length(A);
xTernCoordAll = zeros(numTernPoints, 1);
yTernCoordAll = zeros(numTernPoints, 1);
for i = 1:numTernPoints
    [xTernCoordAll(i), yTernCoordAll(i)] = ...
        getTernCoord(A(i), B(i), sqrt3Half, sqrt3Inv);
end

%% GUI components
hbuttonA = uicontrol(f1, 'Style', 'pushbutton', 'String', 'A', ...
    'Position', [315, 220, 40, 25], ...
    'Callback', {@buttonACallback});
hbuttonB = uicontrol(f1, 'Style', 'pushbutton', 'String', 'B', ...
    'Position', [315, 180, 40, 25], ...
    'Callback', {@buttonBCallback});
hbuttonC = uicontrol(f1, 'Style', 'pushbutton', 'String', 'C', ...
    'Position', [315, 135, 40, 25], ...
    'Callback', {@buttonCCallback});
hbuttonScatter = uicontrol(f1, 'Style', 'pushbutton', ...
    'String', 'scatter', ...
    'Position', [315, 250, 70, 25], ...
    'Callback', {@buttonScatterCallback});
hbuttonSurf = uicontrol(f1, 'Style', 'pushbutton', 'String', 'surface', ...
    'Position', [315, 270, 70, 25], ...
    'Callback', {@buttonSurfCallback});
hbuttonScaleSqrt = uicontrol(f2, 'Style', 'pushbutton', ...
    'String', 'scale sqrt', ...
    'Position', [450, 135, 100, 30], ...
    'Callback', {@buttonScaleSqrtCallback});
hbuttonScaleLog = uicontrol(f2, 'Style', 'pushbutton', ...
    'String', 'scale log', ...
    'Position', [450, 100, 100, 30], ...
    'Callback', {@buttonScaleLogCallback});
hbuttonScaleDef = uicontrol(f2, 'Style', 'pushbutton', ...
    'String', 'no scale', ...
    'Position', [450, 160, 100, 30], ...
    'Callback', {@buttonScaleDefCallback});
hbuttonSelection = uicontrol(f2, 'Style', 'pushbutton', ...
    'String', 'select line', ...
    'Position', [450, 60, 100, 30], ...
    'Callback', {@buttonSelectionCallback});
hbuttonSaveSelect = uicontrol(f2, 'Style', 'pushbutton', ...
    'String', 'save points', ...
    'Position', [450, 190, 100, 30], ...
    'Callback', {@buttonSaveSelectCallback});
htextConst = uicontrol(f1, 'Style', 'text', 'String', 'Const. %', ...
    'Position', [325, 110, 60, 10]);
heditConst = uicontrol(f1, 'Style', 'edit', ...
    'Position', [325, 90, 60, 20], ...
    'Callback', {@editConstCallback}); 
htextWidth = uicontrol(f1, 'Style', 'text', 'String', 'Width', ...
    'Position', [325, 70, 60, 10]);
heditWidth = uicontrol(f1, 'Style', 'edit', ...
    'Position', [300, 50, 60, 20], ...
    'Callback', {@editWidthCallback});

%% initial figure 1 display

figure(f1);

% align buttons
align([hbuttonA, hbuttonB, hbuttonC, htextConst, heditConst, ...
    htextWidth, heditWidth], 'Center', 'None');

% plot data for lowest angle
ha1 = axes('Units','Pixels','Position',[50, 60, 200, 185]); 
hold on;
plotTernData(0);
hold off;

%% make UI visible
f1.Visible = 'on';
f2.Visible = 'on';

    %% callback functions
    
    function buttonACallback(hbuttonA, eventdata, handles)
        constType = 0;
        plotSpecData(1);
    end

    function buttonBCallback(hbuttonB, eventdata, handles)
        constType = 1;
        plotSpecData(1);
    end

    function buttonCCallback(hbuttonC, eventdata, handles)
        constType = 2;
        plotSpecData(1);
    end

    function buttonScaleSqrtCallback(hbuttonScaleSqrt, eventdata, handles)
        plotSpecData(2);
    end
    
    function buttonScaleLogCallback(hbuttonScaleLog, eventdata, handles)
        plotSpecData(3);
    end

    function buttonScaleDefCallback(hbuttonScaledDef, eventdata, handles)
        plotSpecData(1);
    end

    function buttonScatterCallback(hbuttonScatter, eventdata, handles)
        ternPlotType = 0;
        plotTernData(ternPlotType);
    end

    function buttonSurfCallback(hbuttonSurf, eventdata, handles)
        ternPlotType = 1;
        plotTernData(ternPlotType);
    end

    function buttonSelectionCallback(hbuttonSelection, eventdata, handles)
        % save user-selected point
        numSelected = numSelected + 1;
        [xClick, yClick] = ginput(1);
        [compA, compB, compC] = getComp(yClick);
        [xTernCoord, yTernCoord] = ...
            getTernCoord(compA, compB, sqrt3Half, sqrt3Inv);
        xSelected(numSelected) = xTernCoord;
        ySelected(numSelected) = yTernCoord;
        
        % plot user-selected point
        figure(f1);
        hold on;
        scatter3(ha1, xTernCoord, yTernCoord, zMax, 30, 'r', 'filled');
        hold off;
    end

    function buttonSaveSelectCallback(hbuttonSaveSelect, eventdata, handles)
        % save user-selected line
        numSelected = numSelected + 2;
        [compA1, compB1, compC1] = getComp(sliderVert1Val);
        [compA2, compB2, compC2] = getComp(sliderVert2Val);
        [xTernCoord1, yTernCoord1] = ...
            getTernCoord(compA1, compB1, sqrt3Half, sqrt3Inv);
        [xTernCoord2, yTernCoord2] = ...
            getTernCoord(compA2, compB2, sqrt3Half, sqrt3Inv);
        xSelected(numSelected - 1) = xTernCoord1;
        ySelected(numSelected - 1) = yTernCoord1;
        xSelected(numSelected) = xTernCoord2;
        ySelected(numSelected) = yTernCoord2;
        
        % plot user-selected points
        figure(f1);
        hold on;
        scatter3(ha1, xTernCoord1, yTernCoord1, zMax, 30, 'r', 'filled');
        scatter3(ha1, xTernCoord2, yTernCoord2, zMax, 30, 'r', 'filled');
        hold off;
        
        % plot user-selected line
        figure(f1);
        hold on;
        plot3(ha1, [xTernCoord1 xTernCoord2], [yTernCoord1 yTernCoord2], ...
            [zMax zMax], 'r');
        hold off;
    end

    function editConstCallback(heditConst, eventdata, handles)
        constPercent = str2double(get(heditConst, 'String')) / 100;
    end

    function editWidthCallback(heditWidth, eventdata, handles)
        width = str2double(get(heditWidth, 'String')) / 100;
    end

    %% helper functions
    
    %% plots ternary data
    function plotTernData(plotType)
        % plot gridlines
        figure(f1);
        hold off;
        plotTernBase(ha1, sqrt3Half, sqrt3Inv);
        hold on;
        
        if plotType == 0
            plotTernScatter(xTernCoordAll, yTernCoordAll, ...
                data(xIndex, 2 .* (1:numTernPoints)), ha1);
        else
            plotTernSurf(xTernCoordAll, yTernCoordAll, ...
                data(xIndex, 2 .* (1:numTernPoints)));
        end
        
        if numSelected ~= 0
            zVals = zMax * ones(numSelected, 1);
            scatter3(ha1, xSelected, ySelected, zVals, 30, 'r', 'filled');
            i = 1;
            hold on;
            while i <= numSelected - 1
                hold on;
                plot3(ha1, [xSelected(i) xSelected(i + 1)], ...
                    [ySelected(i) ySelected(i + 1)], ...
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
        elseif constType == 1
            ids = getSpecIDs(constPercent, width, B);
            ySpec = C(ids);
        else
            ids = getSpecIDs(constPercent, width, C);
            ySpec = A(ids);
        end
        
        ids = ids .* 2;      
        sliderBinary(data(:, 1), data(:, ids), ySpec, scaling);
    end

    %% gets the composition of a click
    function [compA, compB, compC] = getComp(yClick)
        if constType == 0
            compA = constPercent;
            compB = yClick;
            compC = 1 - compA - compB;
        elseif constType == 1
            compB = constPercent;
            compC = yClick;
            compA = 1 - compB - compC;
        else
            compC = constPercent;
            compA = yClick;
            compB = 1 - compA - compC;
        end
    end

    %% creates slider on spec. graph
    function sb = sliderBinary(xAxis, yAxis, composition,scaling)

        % setup; partially copied from CombiView
        
        hold off; % clear previous graph
        figure(f2);
        %hold off;
        sb.SBFigure = f2;
        sb.plotwindow = 1;
        
        % set up the axes
        
        % position_rectangle = [left, bottom, width, height];
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
        %Range.Y = [min(yAxis(:)) max(yAxis(:))]; 
         sb.SliderAxesVert = axes(...
                    'Units', 'Normalized', ...
                   'Position', [(graphHorPosFrac + graphWidthFrac) ...
                   graphVertPosFrac ...
                   sliderWidthFrac graphHeightFrac], ...
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
       
       figure(f2);
       sb.DataPlots = surf(x, y, yAxis(:,ID).');
       
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
        
        axes(sb.SliderAxes);
        set(sb.SliderAxes,'XLim',Range.X);
        %set(sb.SliderAxesVert, 'YLim', Range.Y);

        hold on;
        sb.SliderLine = plot(Range.X,[.5 .5],'-r');      
        sb.SliderMarker = plot(Range.X(1),.5,'rv','MarkerFaceColor','r');
        
        axes(sb.DataAxes);
        
        hold on;
        sb.AngleMarker = ...
            plot([Range.X(1) Range.X(1)],get(sb.DataAxes,'YLim'),'r');
        %hold off;

        hold on;
        axes(sb.SliderAxesVert);
        set(sb.SliderAxesVert, 'YLim', Range.Y);
        hold on;
        sb.SliderLineVert = plot([.5 .5], Range.Y, '-r');
        %Range.Y
        sb.SliderMarkerVert = plot(.5, Range.Y(1), 'rv','MarkerFaceColor','r');
        sliderVert1Val = Range.Y(1);
        sb.SliderMarkerVert2 = plot(.5, Range.Y(2), 'rv', 'MarkerFaceColor', 'r');
        sliderVert2Val = Range.Y(2);
        %sb.SliderMarkerVert = plot(Range.Y(1), .5, 'rv', 'MarkerFaceColor', 'r');
        %hold off;

        axes(sb.DataAxes);
        hold on;
        sb.CompMarker = ...
            plot(get(sb.DataAxes, 'XLim'), [Range.Y(1) Range.Y(1)], 'r');
        sb.CompMarker2 = ...
            plot(get(sb.DataAxes, 'XLim'), [Range.Y(2) Range.Y(2)], 'r');

        uistack(sb.SliderAxes,'top');
        uistack(sb.SliderAxesVert, 'top');
        
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

        %{
        set(sb.DataPlots, 'ButtonDownFcn', ...
            {@buttondownfcn2, sb.SliderAxes});
        %}
        %% determine where slider is
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
                    %sliderVal
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
        %% determine where in graph click occurred
        % can delete
        function graphClick()
            selected = get(0, 'PointerLocation');            
            figureVertPos = get(f2, 'OuterPosition');
            figureVertPos = figureVertPos(2);
            figureHeight = get(f2, 'OuterPosition');
            figureHeight = figureHeight(4);
            graphHeight = figureHeight * graphHeightFrac;
            ySelectedPoint = selected(2) - figureHeight * graphVertPosFrac...
                - figureVertPos;
            ySelectedPoint = ySelectedPoint / graphHeight * (constPercent + width);
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
        %% sliderVertLineCallback
        function sliderVertLineCallback(src, evt, sb)
            parentfig = get(sb, 'Parent');
            if parentfig ~= 0
                set(parentfig, ...
                    'WindowButtonMotionFcn', {@sliderClickVert, parentfig}, ...
                    'WindowButtonUpFcn', {@buttonupfcnVert, parentfig});
                sliderClickVert(src, evt, parentfig);
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
        %% buttondownfcn2
        function buttondownfcn2 (src, evt, sb)
            %parentfig = get(sb, 'Parent');
            graphClick();
        end
    end
end

