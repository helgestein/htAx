function callbackSelectPoly(obj, evt, ternHandles, specHandles, ECHandles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;

    figure(figTern);
    polyHandle = impoly;
    polyCoords = getPosition(polyHandle);
    x = polyCoords(:, 1);
    y = polyCoords(:, 2);
    x = [x ; x(1)];
    y = [y ; y(1)];
    delete(polyHandle);
    
    ternInfo.constType = 3;
    ternInfo.xPoly = x;
    ternInfo.yPoly = y;
    
    figTern.UserData = ternInfo;
    
    plotSpecData(ternHandles, specHandles, ECHandles);
    plotECData(ternHandles, specHandles, ECHandles);
end

