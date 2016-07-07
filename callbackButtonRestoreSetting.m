function callbackButtonRestoreSetting(obj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKBUTTONRESTORESETTING waits for the user to select an already
%selected point and restores the settings that were in place when the user
%originally selected that point

    set(ternHandles.buttonPoint, 'Callback', []);

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    pointInfo = ternInfo.pointInfo;
    hEditConst = ternHandles.editConst;
    hEditWidth = ternHandles.editWidth;
    
    figSpec = specHandles.fSpecPlot;
    specInfo = figSpec.UserData;
    
    figure(figTern);
    [xSelect, ySelect] = ginput(1);
    indexPoint = findNearestPoint(xSelect, ySelect, ...
        ternInfo.numSelected, ...
        pointInfo(:, 1), pointInfo(:, 2));
    
    % update information
    specInfo.angleIndex = pointInfo(indexPoint, 6);
    hEditConst.UserData = pointInfo(indexPoint, 7);
    hEditWidth.UserData = pointInfo(indexPoint, 8);
    ternInfo.constType = pointInfo(indexPoint, 9);
    ternInfo.ternPlotType = pointInfo(indexPoint, 10);
    specInfo.scaleType = pointInfo(indexPoint, 11);
    
    figTern.UserData = ternInfo;
    figSpec.UserData = specInfo;
    
    % plot with restored settings
    plotTernData(ternHandles, specHandles, ECHandles);
    plotSpecData(ternHandles, specHandles, ECHandles);
    plotECData(ternHandles, specHandles, ECHandles);
    hEditConst.String = num2str(hEditConst.UserData * 100);
    hEditWidth.String = num2str(hEditWidth.UserData * 100);
    
    ternInfo = figTern.UserData;
    specInfo = figSpec.UserData;    
    
    % set sliders
    
    XRDData = specInfo.XRDData;
    sliderPlot = specInfo.sliderPlot;
    
    % set horizontal slider
    sliderHorVal = XRDData(pointInfo(indexPoint, 6), 1);
    set(sliderPlot.sliderMarker, 'XData', sliderHorVal);
    set(sliderPlot.angleMarker, 'XData', [sliderHorVal sliderHorVal]);
    set(ternInfo.textAngle, 'String', ...
        strcat({'Angle: '}, ...
        num2str(XRDData(pointInfo(indexPoint, 6), 1))));
    
    % set vertical slider
    
    % find index of other point
    if mod(indexPoint, 2) == 0
        indexPartner = indexPoint - 1;
    else
        indexPartner = indexPoint + 1;
    end
   
    if ternInfo.constType == 0
        comp1 = pointInfo(indexPoint, 4);
        comp2 = pointInfo(indexPartner, 4);
    elseif ternInfo.constType == 1
        comp1 = pointInfo(indexPoint, 5);
        comp2 = pointInfo(indexPartner, 5);
    else
        comp1 = pointInfo(indexPoint, 3);
        comp2 = pointInfo(indexPoint, 3);
    end
    
    set(sliderPlot.sliderMarkerVert, 'YData', comp1);
    set(sliderPlot.compMarker, 'YData', [comp1 comp1]);
    specInfo.valSliderVert1 = comp1;
    set(sliderPlot.sliderMarkerVert2, 'YData', comp2);
    set(sliderPlot.compMarker2, 'YData', [comp2 comp2]);
    specInfo.valSliderVert2 = comp2;
    
    specInfo.sliderPlot = sliderPlot;
    
    figTern.UserData = ternInfo;
    figSpec.UserData = specInfo;
    
    set(ternHandles.buttonPoint, 'Callback', {@callbackButtonRestoreSetting, ternHandles, specHandles, ECHandles});
    
end

