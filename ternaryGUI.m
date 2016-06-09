function [] = ternaryGUI()
%TERNARYGUI Summary of this function goes here
%   Detailed explanation goes here

% Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[360, 500, 800, 285]);

% UI parameters
constType = 0; % constant = 0 for A, 1 for B, 2 for C
width = 0;
constPercent = 0;
scaled = 0;

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
hbuttonScale = uicontrol('Style', 'pushbutton', ...
    'String', 'adjust intensity contrast', ...
    'Position', [650, 135, 100, 100], ...
    'Callback', {@buttonScaleCallback});
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
        plotSpecData();
        %specPlotData = getSpecData(constType, lower, upper, A, B, data);
        %plotSpecData(specPlotData);
    end

    function buttonBCallback(hbuttonB, eventdata, handles)
        constType = 1;
        plotSpecData();
        %specPlotData = getSpecData(constType, lower, upper, B, C, data);
        %plotSpecData(specPlotData);
    end

    function buttonCCallback(hbuttonC, eventdata, handles)
        constType = 2;
        plotSpecData();
        %specPlotData = getSpecData(constType, lower, upper, C, A, data);
        %plotSpecData(specPlotData);
    end

    function buttonScaleCallback(hbuttonScale, eventdata, handles)
        numPoints = length(data(1, :)) / 2;
        if scaled == 0
            for i = 1:numPoints
                data(:, 2 * i) = sqrt(data(:, 2 * i));
            end
            scaled = 1;
        else
            for i = 1:numPoints
                data(:, 2 * i) = data(:, 2 * i) .* data(:, 2 * i);
            end
            scaled = 0;
            
        end
        
        plotSpecData();
    end

    function editConstCallback(heditConst, eventdata, handles)
        constPercent = str2double(get(heditConst, 'String')) / 100;
    end

    function editWidthCallback(heditWidth, eventdata, handles)
        width = str2double(get(heditWidth, 'String')) / 100;
    end

    function plotSpecData()
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
        imagesc(data(:, 1), ySpec, data(:, ids));
    end
        
% make UI visible
f.Visible = 'on';

end

