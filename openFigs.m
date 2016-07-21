function [] = openFigs(XRDData, A, B, C, ...
    numSelected, pointInfo, ECData, ECPlotInfo, collcodes, XRDDatabase, ...
    labels)
%OPENFIGS opens the figures needed to begin the analysis

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

setTernCallbacks(ternHandles, specHandles, ECHandles);
setSpecCallbacks(ternHandles, specHandles, ECHandles);
if ECData ~= 1
    setECCallbacks(ternHandles, specHandles, ECHandles);
end

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
ternInfo.constType = 0;
ternInfo.fTernPhase = '';
ternInfo.pointOutline = '';
ternInfo.fXRDPlot = '';
ternInfo.fCVPlot = '';
ternInfo.xPoly = '';
ternInfo.yPoly = '';
ternInfo.labels = labels;
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
            {@callbackPlotTernPhase, ternHandles});
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

