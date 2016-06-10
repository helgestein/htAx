function [] = ternaryGUI()
%TERNARYGUI Summary of this function goes here
%   Detailed explanation goes here

% Create and then hide the UI as it is being constructed.
f1 = figure('Visible','off','Position',[200, 500, 400, 310]);
f2 = figure('Visible','off','Position',[700, 500, 600, 285]);

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
zMax = 3000;

% precalculate to save time
sqrt3Half = sqrt(3) / 2;
sqrt3Inv = 1 / sqrt(3);

% save selected points
%xSelected = zeros(20, 1);
%ySelected = zeros(20, 1);
numSelected = 0;
xSelected = zeros(1, 1);
ySelected = zeros(1, 1);

% test folder
folder = '/Users/sjiao/Documents/summer_2016/data/CoFeMnO-mapcorr';

% get data
[xCoord, yCoord, data] = readXRDData(folder);
[A, B, C] = ...
    importEDXFile('/Users/sjiao/Documents/summer_2016/data/MnFeCoO-EDX');
% convert to percents
A = A ./ 100; 
B = B ./ 100;
C = C ./ 100;

minAngle = min(data(:, 1));
maxAngle = max(data(:, 1));

sliderVal = minAngle;

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

% components
hbuttonA = uicontrol(f1, 'Style', 'pushbutton', 'String', 'A', ...
    'Position', [315, 220, 40, 25], ...
    'Callback', {@buttonACallback});
hbuttonB = uicontrol(f1, 'Style', 'pushbutton', 'String', 'B', ...
    'Position', [315, 180, 40, 25], ...
    'Callback', {@buttonBCallback});
hbuttonC = uicontrol(f1, 'Style', 'pushbutton', 'String', 'C', ...
    'Position', [315, 135, 40, 25], ...
    'Callback', {@buttonCCallback});
hbuttonScatter = uicontrol(f1, 'Style', 'pushbutton', 'String', 'scatter', ...
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

%old slider
%{
hslider = uicontrol(f2, 'Style', 'slider', ...
    'Position', [50, 40, 200, 20], ...
    'value', minAngle, ...
    'min', minAngle, 'max', maxAngle, ...
    'Callback', {@sliderCallback});
htextSlider = uicontrol(f2, 'Style', 'text', 'String', ...
    strcat('Slider val: ', num2str(minAngle)), ...
    'Position', [50, 20, 200, 10]);

%}

figure(f1);
ha1 = axes('Units','Pixels','Position',[50, 60, 200, 185]); 

hold on;

angleID = 1;
numPoints = length(data(1, :)) / 2;
plotTernary(A, B, data(angleID, 2 .* (1:numPoints)), ha1);

%figure(f2)
%ha2 = axes('Units', 'Pixels', 'Position', [50, 100, 200, 185]);

align([hbuttonA, hbuttonB, hbuttonC, htextConst, heditConst, ...
    htextWidth, heditWidth], 'Center', 'None');

hold off;

% make UI visible
f1.Visible = 'on';
f2.Visible = 'on';

    % callback functions
    
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
        plotTernData(ternPlotType, xIndex);
    end

    function buttonSurfCallback(hbuttonSurf, eventdata, handles)
        ternPlotType = 1;
        plotTernData(ternPlotType, xIndex);
    end

    function buttonSelectionCallback(hbuttonSelection, eventdata, handles)
        numSelected = numSelected + 1;
        [xClick, yClick] = ginput(1);
        [compA, compB, compC] = getComp(yClick);
        [xTernCoord, yTernCoord] = ...
            getTernCoord(compA, compB, sqrt3Half, sqrt3Inv);
        xSelected(numSelected) = xTernCoord;
        ySelected(numSelected) = yTernCoord;
        figure(f1);
        hold on;
        scatter3(ha1, xTernCoord, yTernCoord, zMax, 30, 'r', 'filled');
        hold off;
    end

    function editConstCallback(heditConst, eventdata, handles)
        constPercent = str2double(get(heditConst, 'String')) / 100;
    end

    function editWidthCallback(heditWidth, eventdata, handles)
        width = str2double(get(heditWidth, 'String')) / 100;
    end


%old slider
%{
    function sliderCallback(hslider, eventdata, handles)
        sliderVal = get(hslider, 'Value');
        set(htextSlider, 'String', ...
            strcat('Slider val: ', num2str(sliderVal)));
    end
%}

    % helper functions
    
    function plotTernData(plotType, xIndexTemp)
        numPoints = length(data(1, :)) / 2;
        if plotType == 0
            figure(f1);
            hold off;
            plotTernary(A, B, data(xIndexTemp, 2 .* (1:numPoints)), ha1);
            hold on;
        else
            hold off;
            plotTernarySurf(A, B, data(xIndexTemp, 2 .* (1:numPoints)), ha1, f1);
            hold on
        end
            hold on
            if numSelected ~= 0
                zVals = zMax * ones(numSelected, 1);
                scatter3(ha1, xSelected, ySelected, zVals, 30, 'r', 'filled');
            end
    end

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
        
        %binaryPlot(data(:, 1), data(:, ids), ySpec, scaling, ha2);
        sliderBinary(data(:, 1), data(:, ids), ySpec, scaling);
    end

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

    function sb = sliderBinary(xAxis, yAxis, composition,scaling)

        %set Up ... partially copied from CombiView

        %sb.SBFigure = figure('Color','w'); 
        hold off;
        figure(f2)
        sb.SBFigure = f2;
        sb.plotwindow = 1;
        % position_rectangle = [left, bottom, width, height];
        
        sb.DataAxes = axes(...
                  'Units', 'Normalized',...
                  'Position',[.07 .15 .60 .80],...
                  'XTick',[],'YTick',[],...
                  'Box','on');  
        % Slider Axes
        sb.SliderAxes = axes(...
                  'position',[.07 .951 .60 .02],...
                  'XTick',[],...
                  'YTick',[],...
                  'YLim',[0 1],...
                  'Box','on');
       
       if axesSet ~= 0
           set(sb.DataAxes, 'XTick', [], 'YTick', []);
       end
       axes(sb.DataAxes);
       Range.X = [min(xAxis) max(xAxis)];
       Range.Y = [min(yAxis(:)) max(yAxis(:))];  

       % plotting according to binaryPlot

       %sorting the data according to composition
       [sComposition,ID] = sort(composition); %sort them according to the composition
       [x,y] = meshgrid(xAxis, sComposition); %create what is nessesary for surf plot

       %select the scaling function
       if (scaling == 2)
           yAxis = sqrt(yAxis);
       end 
       if (scaling == 3)
           yAxis = log10(yAxis);
       end 
       figure(f2);
       sb.DataPlots = surf(x, y, yAxis(:,ID).'); %plot the data
       if axesSet ~= 0
           set(sb.DataAxes, 'XTick', [], 'YTick', []);
       end
       axes(sb.DataAxes);
       if axesSet == 0
           xlabel('Angle'); 
           ylabel('Composition');
           axesSet = 1;
       end
       shading('interp');
       axis('tight'); %this is to make it look good 
       view(2); %this is so ensure the correct view
       hold on;
       set(sb.SliderAxes, 'ButtonDownFcn', {@buttondownfcn, sb.SliderAxes});
       set(sb.DataAxes,'XLim',Range.X)
       set(sb.SBFigure, 'BusyAction', 'cancel');
       setappdata(sb.SBFigure,'forcedclose','0');

        %% Create a "slider" to select angle
        figure(f2);
        axes(sb.SliderAxes)
        set(sb.SliderAxes,'XLim',Range.X)
        figure(f2);
        hold on
        sb.SliderLine = plot(Range.X,[.5 .5],'-r');
        sb.SliderMarker = plot(Range.X(1),.5,'rv','MarkerFaceColor','r');
        hold off
        figure(f2);
        axes(sb.DataAxes)
        hold on
        sb.AngleMarker = plot([Range.X(1) Range.X(1)],get(sb.DataAxes,'YLim'),'r');
        hold off
    %     uistack(sb.AngleMarker, 'top');
        uistack(sb.SliderAxes,'top')
        set(sb.SliderAxes,'ButtonDownFcn',{@buttondownfcn, sb.SliderAxes})
        set(sb.SliderLine,'ButtonDownFcn',{@buttondownfcn, sb.SliderAxes})
        set(sb.SliderMarker,'ButtonDownFcn',{@buttondownfcn, sb.SliderAxes})
       %{
        function raisescrolloptionsfigure(src, evt)
            scrollfigsbandle = scrolloptionsfigure(sb);
            setappdata(sb.SBFigure, 'scrollfigsbandle', scrollfigsbandle);
        end

        function raiseaxiscontrolsfigure(src, evt)
           axiscontrolssbandle =  axiscontrolsfigure(sb);
           setappdata(sb.SBFigure, 'axiscontrolssbandle', axiscontrolssbandle);       
        end
        %}

        function SliderClick(src,evt,parentfig)          
            %handles_to_update = getappdata(parentfig, 'PlotHandles')
            Selected = get(sb.SliderAxes,'CurrentPoint');
            sliderVal = Selected(1,1); % changed xNew to sliderVal for readability



            %this is where you shold then hop in an select the proper ID in
            %the XRD intensity data

            % find index of closest x value to the slider position
            [xApproxVal, xIndex] = min(abs(xAxis - sliderVal));

            % plot the ternary diagram again
            
            plotTernData(ternPlotType, xIndex);

            %cla(ha1);
            %numPoints = length(data(1, :)) / 2;
            %figure(f1);
            %hold off;
            %plotTernary(A, B, data(xIndex, 2 .* (1:numPoints)), ha1);
            %hold on;
            % replot the selected points
            %if numSelected ~= 0
            %    scatter(ha1, xSelected, ySelected, 30, 'r', 'filled');
            %end
            
            set(sb.SliderMarker,'XData',sliderVal);
            set(sb.AngleMarker,'XData',[sliderVal sliderVal]);
    %       
        end        
    %% buttondownfcn
        function buttondownfcn (src, evt, sb)

            parentfig = get(sb,'Parent');
            if parentfig ~= 0
                set(parentfig, 'WindowButtonMotionFcn', {@SliderClick, parentfig}, ...
                    'WindowButtonUpFcn', {@buttonupfcn, parentfig});  
                SliderClick(src,evt,parentfig);
            end
        end

    %% windowbuttonupfcn
        function buttonupfcn (src, evt, sb)
            set(sb, 'WindowButtonMotionFcn', [])
        end


    end
end

