function [] = openFigs(XRDData, A, B, C, ...
    numSelected, pointInfo, ECData, ECPlotInfo, collcodes, XRDDatabase, ...
    labels, savedPoly, ECDataReal)
%OPENFIGS opens the figures needed to begin the analysis

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

3. Neither the name of the copyright holder nor the names of its 
contributors may be used to endorse or promote products derived from this 
software without specific prior written permission.

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

%% precalculate to save time
global sqrt3Half;
global sqrt3Inv;
sqrt3Half = sqrt(3) / 2;
sqrt3Inv = 1 / sqrt(3);

%% open figures and set callbacks

ternHandles = openTernFigs();
ternHandles.buttonA.String = labels.A;
ternHandles.buttonB.String = labels.B;
ternHandles.buttonC.String = labels.C;
specHandles = openSpecFigs();
ECHandles = openECFigs();

if ECDataReal == 0
    ECHandles.fECPlot.Visible = 'off';
    ECHandles.fECButtons.Visible = 'off';
end

setTernCallbacks(ternHandles, specHandles, ECHandles);
setSpecCallbacks(ternHandles, specHandles, ECHandles);
%if ECData ~= 1
    setECCallbacks(ternHandles, specHandles, ECHandles);
%end

%% process and plot data

% get rectangular coordinates for ternary diagram
numTernPoints = length(A);
%length(A)
%numTernPoints = 342;
xTernCoordAll = zeros(numTernPoints, 1);
yTernCoordAll = zeros(numTernPoints, 1);
for index = 1:numTernPoints
    [xTernCoordAll(index), yTernCoordAll(index)] = ...
        getTernCoord(A(index), B(index));
end

% initial spec. state
figSpec = specHandles.fSpecPlot;
specInfo.XRDData = XRDData;
specInfo.angleIndex = 1;
specInfo.scaleType = 0;
specInfo.sliderPlot = '';
specInfo.valSliderVert1 = 0;
specInfo.valSliderVert2 = 0;
specInfo.collcodes = collcodes;
specInfo.XRDDatabase = XRDDatabase;
specInfo.selectedComp = '';
specInfo.selectedCompPartner = '';
specInfo.minAngle = min(XRDData(:, 1));
specInfo.maxAngle = max(XRDData(:, 1));
specInfo.matchInfo = '';
figSpec.UserData = specInfo;


% initial ternary state
figTern = ternHandles.fTernDiagram;
figure(figTern);
ternInfo.axesTernary = axes('Units', 'Normalized', ...
    'Position', [0.1, 0.1, 0.8, 0.8]);
%axis equal;
hold off;
axis image;
axis off;
ternInfo.textAngle = uicontrol(ternHandles.fTernDiagram, ...
    'Style', 'text', ...
    'String', strcat({'Angle: '}, ...
    num2str(specInfo.XRDData(specInfo.angleIndex, 1))), ...
    'Units', 'Normalized', ...
    'Position', [0.05 0.85 0.3 0.08], ...
    'BackgroundColor', 'w', ...
    'FontSize', 14, 'FontWeight', 'bold');
ternInfo.valsCompA = A;
ternInfo.valsCompB = B;
ternInfo.valsCompC = C;
ternInfo.xCoords = xTernCoordAll;
ternInfo.yCoords = yTernCoordAll;
ternInfo.numPoints = numTernPoints;
ternInfo.ternPlotType = 0;
ternInfo.highlight = '';
ternInfo.numSelected = numSelected;
ternInfo.pointInfo = pointInfo;
ternInfo.savedPoly = savedPoly;
ternInfo.constType = 0;
ternInfo.fTernPhase = '';
ternInfo.pointOutline = '';
ternInfo.fXRDPlot = '';
ternInfo.fCVPlot = '';
ternInfo.xPoly = '';
ternInfo.yPoly = '';
ternInfo.labels = labels;
ternInfo.polySelected = 0;
figTern.UserData = ternInfo;

% initial EC state
figEC = ECHandles.fECPlot;
ECInfo.ECData = ECData;
ECInfo.valSliderECPot = 0;
ECInfo.ECPlotInfo = ECPlotInfo;
ECInfo.fBinaryPlot = '';
ECInfo.fTernTafelSurf = '';
ECInfo.fTernTafelScatter = '';
ECInfo.fTernOnsetSurf = '';
ECInfo.fTernOnsetScatter = '';
ECInfo.lobfData = zeros(numTernPoints, 6);
ECInfo.selectedCompSort = '';
ECInfo.selectedPlotGenIndex = 1;
ECInfo.selectedPlotDispIndex = 1;
ECInfo.waterfallPlot = '';
ECInfo.lowLobf = '';
ECInfo.highLobf = '';
ECInfo.valSliderFit1 = 0;
ECInfo.valSliderFit2 = 0;
ECInfo.dataReal = ECDataReal;
figEC.UserData = ECInfo;

plotTernData(ternHandles, specHandles, ECHandles);
   
    %% setting callbacks
    
    function setTernCallbacks(ternHandles, specHandles, ECHandles)

        set(ternHandles.editConst, 'Callback', {@callbackEdit});
        set(ternHandles.editWidth, 'Callback', {@callbackEdit});
        set(ternHandles.buttonA, 'Callback', ...
            {@callbackButtonConst, 0, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonB, 'Callback', ...
            {@callbackButtonConst, 1, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonC, 'Callback', ...
            {@callbackButtonConst, 2, ternHandles, specHandles, ECHandles});      
        set(ternHandles.buttonScatter, 'Callback', ...
            {@callbackButtonTernPlotType, 0, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonSurf, 'Callback', ...
            {@callbackButtonTernPlotType, 1, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonScatterEC, 'Callback', ...
            {@callbackButtonTernPlotType, 2, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonSurfEC, 'Callback', ...
            {@callbackButtonTernPlotType, 3, ternHandles, specHandles, ECHandles});
        set(ternHandles.editSize, 'Callback', ...
            {@callbackEditDotSize, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonPoint, 'Callback', ...
            {@callbackButtonRestoreSetting, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonDelete, 'Callback', ...
            {@callbackButtonDeleteSelection, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonSaveAll, 'Callback', ...
            {@callbackSaveAnalysis, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonClose, 'Callback', ...
            {@callbackButtonClose, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonSaveClose, 'Callback', ...
            {@callbackButtonSaveClose, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonPhase, 'Callback', ...
            {@callbackPlotTernPhase, ternHandles, specHandles});
        set(ternHandles.buttonSelectPoint, 'Callback', ...
            {@callbackXRDMatchPoint, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonProcessAll, 'Callback', ...
            {@callbackXRDMatchAll, ternHandles, specHandles});
        set(ternHandles.buttonXRDPlot, 'Callback', ...
            {@callbackXRDPlot, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonCVPlot, 'Callback', ...
            {@callbackCVPlot, 1, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonCVPlotNormal, 'Callback', ...
            {@callbackCVPlot, 0, ternHandles, specHandles, ECHandles});
        set(ternHandles.buttonSelectPoly, 'Callback', ...
            {@callbackSelectPoly, ternHandles, specHandles, ECHandles});
        set(ternHandles.editConfFactor, 'Callback', ...
            {@callbackEditNum});
        set(ternHandles.buttonExportMatchAll, 'Callback', ...
            {@callbackExportMatchAll, ternHandles, specHandles});
        set(ternHandles.buttonChangeDatabaseFd, 'Callback', ...
            {@callbackChangeDB, 0, specHandles});
        set(ternHandles.buttonChangeDatabaseFile, 'Callback', ...
            {@callbackChangeDB, 1, specHandles});
        set(ternHandles.buttonSaveDatabase, 'Callback', ...
            {@callbackSaveDB, specHandles});
        set(ternHandles.buttonPlotPeaks, 'Callback', ...
            {@callbackPlotPeaks, ternHandles, specHandles});
        set(ternHandles.editTol, 'Callback', {@callbackEditNum});
    end
    
    function setSpecCallbacks(ternHandles, specHandles, ECHandles)     
        set(specHandles.buttonScaleSqrt, 'Callback', ...
            {@callbackSpecPlotScale, 2, ternHandles, specHandles, ECHandles});
        set(specHandles.buttonScaleLog, 'Callback', ...
            {@callbackSpecPlotScale, 3, ternHandles, specHandles, ECHandles});
        set(specHandles.buttonScaleNone, 'Callback', ...
            {@callbackSpecPlotScale, 1, ternHandles, specHandles, ECHandles});
        set(specHandles.buttonSave, 'Callback', ...
            {@callbackSaveTernPoints, ternHandles, specHandles});
    end
    
    function setECCallbacks(ternHandles, specHandles, ECHandles)        
        set(ECHandles.editSelect, 'Callback', ...
            {@callbackECPlotSelect, ternHandles, specHandles, ECHandles});
        set(ECHandles.buttonIncrease, 'Callback', ...
            {@callbackECPlotData, 1, ternHandles, specHandles, ECHandles});
        set(ECHandles.buttonDecrease, 'Callback', ...
            {@callbackECPlotData, -1, ternHandles, specHandles, ECHandles});
        set(ECHandles.buttonBoth, 'Callback', ...
            {@callbackECPlotData, 0, ternHandles, specHandles, ECHandles});
        set(ECHandles.buttonLowerSlope, 'Callback', ...
            {@callbackSlopeFit, 1, ECHandles});
        set(ECHandles.buttonHigherSlope, 'Callback', ...
            {@callbackSlopeFit, 0, ECHandles});
        set(ECHandles.buttonTafel, 'Callback', ...
            {@callbackTafel, ECHandles});
        set(ECHandles.buttonOnsetPot, 'Callback', ...
            {@callbackOnset, ECHandles});
        set(ECHandles.editOffset, 'Callback', ...
            {@callbackOffset, ternHandles, specHandles, ECHandles});
        set(ECHandles.buttonReset, 'Callback', ...
            {@callbackResetECCalcs, ECHandles});
        set(ECHandles.buttonPrint, 'Callback', ...
            {@callbackPrintEC, ternHandles, ECHandles});
        set(ECHandles.buttonPlotTern, 'Callback', ...
            {@callbackECPlotTern, ternHandles, ECHandles});
    end
end

