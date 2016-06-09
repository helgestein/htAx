function [] = ternaryGUI()
%TERNARYGUI Summary of this function goes here
%   Detailed explanation goes here

% Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[360, 500, 800, 285]);

% UI parameters
constType = 0; % constant = 0 for A, 1 for B, 2 for C
width = 0;
constPercent = 0;

% precalculate to save time
sqrt3Half = sqrt(3) / 2;
sqrt3Inv = 1 / sqrt(3);

% test folder
folder = '/Users/sjiao/Documents/summer_2016/data/CoFeMnO-mapcorr';

% get data
[xCoord, yCoord, data] = readXRDData(folder);
[A, B, C] = importEDXFile('/Users/sjiao/Documents/summer_2016/data/MnFeCoO-EDX');
% convert to percents
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

% components
hbuttonA = uicontrol('Style', 'pushbutton', 'String', 'A', ...
    'Position', [315, 220, 40, 25], ...
    'Callback', {@buttonACallback});
hbuttonB = uicontrol('Style', 'pushbutton', 'String', 'B', ...
    'Position', [315, 180, 40, 25], ...
    'Callback', {@buttonBCallback});
hbuttonC = uicontrol('Style', 'pushbutton', 'String', 'C', ...
    'Position', [315, 135, 40, 25], ...
    'Callback', {@buttonCCallback});
hbuttonScaleSqrt = uicontrol('Style', 'pushbutton', ...
    'String', 'scale sqrt', ...
    'Position', [650, 135, 100, 30], ...
    'Callback', {@buttonScaleSqrtCallback});
hbuttonScaleLog = uicontrol('Style', 'pushbutton', ...
    'String', 'scale log', ...
    'Position', [650, 100, 100, 30], ...
    'Callback', {@buttonScaleLogCallback});
hbuttonScaleDef = uicontrol('Style', 'pushbutton', ...
    'String', 'no scale', ...
    'Position', [650, 160, 100, 30], ...
    'Callback', {@buttonScaleDefCallback});
hbuttonSelection = uicontrol('Style', 'pushbutton', ...
    'String', 'select line', ...
    'Position', [650, 60, 100, 30], ...
    'Callback', {@buttonSelectionCallback});
htextConst = uicontrol('Style', 'text', 'String', 'Const. %', ...
    'Position', [325, 110, 60, 10]);
heditConst = uicontrol('Style', 'edit', ...
    'Position', [325, 90, 60, 20], ...
    'Callback', {@editConstCallback}); 
htextWidth = uicontrol('Style', 'text', 'String', 'Width', ...
    'Position', [325, 70, 60, 10]);
heditWidth = uicontrol('Style', 'edit', ...
    'Position', [300, 50, 60, 20], ...
    'Callback', {@editWidthCallback});

ha1 = axes('Units','Pixels','Position',[50, 60, 200, 185]); 

hold on
plotTernary(A, B);

ha2 = axes('Units', 'Pixels', 'Position', [400, 60, 200, 185]);

align([hbuttonA, hbuttonB, hbuttonC, htextConst, heditConst, ...
    htextWidth, heditWidth], 'Center', 'None');

hold off

% make UI visible
f.Visible = 'on';

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

    function buttonSelectionCallback(hbuttonSelection, eventdata, handles)
        [xClick, yClick] = ginput(1);
        [compA, compB, compC] = getComp(yClick);
        [xTernCoord, yTernCoord] = getTernCoord(compA, compB, sqrt3Half, sqrt3Inv);
        hold on;
        scatter(ha1, xTernCoord, yTernCoord, 30, 'r', 'filled');
        hold off;
    end

    function editConstCallback(heditConst, eventdata, handles)
        constPercent = str2double(get(heditConst, 'String')) / 100;
    end

    function editWidthCallback(heditWidth, eventdata, handles)
        width = str2double(get(heditWidth, 'String')) / 100;
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
        binaryPlot(data(:, 1), data(:, ids), ySpec, scaling);
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

end

