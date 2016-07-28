function specHandles = openSpecFigs()
%OPENSPECFIGS opens the binary plot window and its settings window

%{
Copyright (c) 2016, Sally Jiao <sjiao@princeton.edu>
Copyright (c) 2016, Helge S. Stein <helge.stein@rub.de>
Copyright (c) 2016, Prof. Dr. Alfred Ludwig <alfred.ludwig@rub.de>

All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright 
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%}

% create spec. windows
specHandles.fSpecButtons = figure(...
    'Visible', 'off', ...
    'Units', 'Normalized', ...
    'Position', [0.5 0.7 0.4 0.2], ...
    'Name', 'Spec. Data Plot Settings');
specHandles.fSpecPlot = figure(...
    'Visible', 'off', ...
    'Units', 'Normalized', ...
    'Position', [0.52 0.03 0.45 0.45], ...
    'Name', 'Spec. Data Plot');

% set background to white
figure(specHandles.fSpecButtons);
set(gcf, 'color', 'w');
figure(specHandles.fSpecPlot);
set(gcf, 'color', 'w');

% set tabs in button window
tabsSpec = uitabgroup('Parent', specHandles.fSpecButtons);
tabStyle = uitab('Parent', tabsSpec, 'Title', 'Plot style');
tabSelect = uitab('Parent', tabsSpec, 'Title', 'Select points');

%% components

topRowOffset = 0.7;
buttonWidth = 0.3;
buttonHeight = 0.2;
textSpacingVert = 0.2;
leftColOffset = 0.5 - buttonWidth / 2;

specHandles.buttonScaleSqrt = uicontrol('Parent', tabStyle, ...
    'Style', 'pushbutton', ...
    'String', 'Scale sq. rt.', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset topRowOffset buttonWidth buttonHeight]);
specHandles.buttonScaleLog = uicontrol('Parent', tabStyle, ...
    'Style', 'pushbutton', ...
    'String', 'Scale log', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset (topRowOffset - textSpacingVert) ...
    buttonWidth buttonHeight]);
specHandles.buttonScaleNone = uicontrol('Parent', tabStyle, ...
    'Style', 'pushbutton', ...
    'String', 'No scale', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset (topRowOffset - 2 * textSpacingVert) ...
    buttonWidth buttonHeight]);
specHandles.buttonSave = uicontrol('Parent', tabSelect, ...
    'Style', 'pushbutton', ...
    'String', 'Save points', ...
    'Units', 'Normalized', ...
    'Position', [leftColOffset topRowOffset buttonWidth buttonHeight]);

%% make windows visible

fig = specHandles.fSpecButtons;
fig.Visible = 'on';
fig = specHandles.fSpecPlot;
fig.Visible = 'on';

end

