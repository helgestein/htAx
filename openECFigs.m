function [fECButtons, fECPlot] = openECFigs()
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

%% make windows visible

fECButtons.Visible = 'on';
fSpecPlot.Visible = 'on';

end

