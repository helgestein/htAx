function [heditSelect, hbuttonIncrease, hbuttonDecrease, hbuttonBoth, fECButtons, fECPlot] = openECFigs()
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

%% components

topRowOffset = 0.8;
buttonWidth = 0.3;
buttonHeight = 0.2;
textSpacingVert = 0.2;
midColOffset = 0.5 - buttonWidth / 2;
leftColOffset = 0.1;
editHeight = buttonHeight;
editWidth = buttonWidth / 2;

htextSelect = uicontrol('Parent', tabSelect, ...
    'Style', 'text', ...
    'String', 'Composition', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset topRowOffset buttonWidth buttonHeight]);
heditSelect = uicontrol('Parent', tabSelect, ...
    'Style', 'edit', ...
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

%% make windows visible

fECButtons.Visible = 'on';
fSpecPlot.Visible = 'on';

end

