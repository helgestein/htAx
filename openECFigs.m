function [heditSelect, hbuttonIncrease, hbuttonDecrease, ...
    hbuttonLowerSlope, htextLowerSlope, hbuttonHigherSlope, htextHigherSlope, ...
    hbuttonTafel, htextTafel, hbuttonOnsetPot, htextOnsetPot, ...
    hbuttonBoth, heditOffset, fECButtons, fECPlot] = openECFigs()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% create EC windows
fECButtons = figure(...
    'Visible', 'off', ...
    'Units', 'Normalized', ...
    'Position', [0.3 0.7 0.4 0.2], ...
    'Name', 'EC Data Plot Settings');
fECPlot = figure(...
    'Visible', 'off', ...
    'Units', 'Normalized', ...
    'Position', [0.3 0.03 0.45 0.45], ...
    'Name', 'EC Data Plot');

% set background to white
figure(fECButtons);
set(gcf, 'color', 'w');
figure(fECPlot);
set(gcf, 'color', 'w');

% set tabs in button window
tabsEC = uitabgroup('Parent', fECButtons);
tabStyle = uitab('Parent', tabsEC, 'Title', 'Plot style');
tabSelect = uitab('Parent', tabsEC, 'Title', 'Select plot');
tabAnalyze = uitab('Parent', tabsEC, 'Title', 'Analyze plot');

%% components

topRowOffset = 0.8;
buttonWidth = 0.3;
buttonHeight = 0.2;
textSpacingVert = 0.2;
%midColOffset = 0.5 - buttonWidth / 2;
leftColOffset = 0.1;
rightColOffset = 0.5;
editHeight = buttonHeight;
editWidth = buttonWidth / 2;
rowSpace = 0.2;

% analyze tab

hbuttonLowerSlope = uicontrol('Parent', tabAnalyze, ...
    'Style', 'pushbutton', ...
    'String', 'Fit lower slope', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset topRowOffset buttonWidth buttonHeight]);
htextLowerSlope = uicontrol('Parent', tabAnalyze, ...
    'Style', 'text', ...
    'String', '', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset (topRowOffset - rowSpace)...
    buttonWidth buttonHeight]);
hbuttonHigherSlope = uicontrol('Parent', tabAnalyze, ...
    'Style', 'pushbutton', ...
    'String', 'Fit higher slope', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset (topRowOffset - rowSpace * 2) ...
    buttonWidth buttonHeight]);
htextHigherSlope = uicontrol('Parent', tabAnalyze, ...
    'Style', 'text', ...
    'String', '', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset (topRowOffset - rowSpace * 3) ...
    buttonWidth buttonHeight]);

hbuttonTafel = uicontrol('Parent', tabAnalyze, ...
    'Style', 'pushbutton', ...
    'String', 'Calc. Tafel slope', ...
    'Units', 'Normalized', ...
    'Position', [rightColOffset topRowOffset buttonWidth buttonHeight]);
htextTafel = uicontrol('Parent', tabAnalyze, ...
    'Style', 'text', ...
    'String', '', ...
    'Units', 'Normalized', ...
    'Position', [rightColOffset (topRowOffset - rowSpace)...
    buttonWidth buttonHeight]);
hbuttonOnsetPot = uicontrol('Parent', tabAnalyze, ...
    'Style', 'pushbutton', ...
    'String', 'Calc. onset potential', ...
    'Units', 'Normalized', ...
    'Position', [rightColOffset (topRowOffset - rowSpace * 2) ...
    buttonWidth buttonHeight]);
htextOnsetPot = uicontrol('Parent', tabAnalyze, ...
    'Style', 'text', ...
    'String', '', ...
    'Units', 'Normalized', ...
    'Position', [rightColOffset (topRowOffset - rowSpace * 3) ...
    buttonWidth buttonHeight]);

% select plot tab

htextSelect = uicontrol('Parent', tabSelect, ...
    'Style', 'text', ...
    'String', 'Composition', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset topRowOffset buttonWidth buttonHeight]);
heditSelect = uicontrol('Parent', tabSelect, ...
    'Style', 'edit', ...
    'String', '0', ...
    'Units', 'Normalized', ...
    'Position', [(leftColOffset + (buttonWidth - editWidth) / 2) (topRowOffset - buttonHeight + 0.05) ...
    editWidth editHeight]);
hbuttonIncrease = uicontrol('Parent', tabSelect, ...
    'Style', 'pushbutton', ...
    'String', 'Increase only', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset (topRowOffset - buttonHeight - textSpacingVert) ...
    buttonWidth buttonHeight]);
hbuttonDecrease = uicontrol('Parent', tabSelect, ...
    'Style', 'pushbutton', ...
    'String', 'Decrease only', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset (topRowOffset - buttonHeight - 2 * textSpacingVert) ...
    buttonWidth buttonHeight]);
hbuttonBoth = uicontrol('Parent', tabSelect, ...
    'Style', 'pushbutton', ...
    'String', 'Both', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset (topRowOffset - buttonHeight - 3 * textSpacingVert) ...
    buttonWidth buttonHeight]);

% style tab

htextOffset = uicontrol('Parent', tabStyle, ...
    'Style', 'text', ...
    'String', 'Offset', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset topRowOffset buttonWidth buttonHeight]);
heditOffset = uicontrol('Parent', tabStyle, ...
    'Style', 'edit', ...
    'String', '1', ...
    'Units', 'Normalized', ...
    'Position', [(leftColOffset + (buttonWidth - editWidth) / 2) (topRowOffset - buttonHeight + 0.05) ...
    editWidth editHeight]);

%% make windows visible

fECButtons.Visible = 'on';
fECPlot.Visible = 'on';

end

