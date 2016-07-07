function [] = callbackButtonTernPlotType(obj, evt, ...
    ternPlotType, ternHandles, specHandles, ECHandles)
%CALLBACKBUTTONTERNPLOTTYPE updates the type of the ternary diagram

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    ternInfo.ternPlotType = ternPlotType;
    figTern.UserData = ternInfo;
    
    plotTernData(ternHandles, specHandles, ECHandles);

end

