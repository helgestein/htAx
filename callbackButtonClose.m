function callbackButtonClose(obj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKBUTTONCLOSE closes the GUI

    fTernButtons = ternHandles.fTernButtons;
    fTernDiagram = ternHandles.fTernDiagram;
    fSpecButtons = specHandles.fSpecButtons;
    fSpecPlot = specHandles.fSpecPlot;
    fECButtons = ECHandles.fECButtons;
    fECPlot = ECHandles.fECPlot;
    
    ECInfo = fECPlot.UserData;
    
    close(fTernButtons);
    if ishandle(fTernDiagram) ~= 0
        close(fTernDiagram);
    end
    if ishandle(fSpecButtons) ~= 0
        close(fSpecButtons);
    end
    if ishandle(fSpecPlot) ~= 0
        close(fSpecPlot);
    end
    if ishandle(fECButtons) ~= 0
        close(fECButtons);
    end
    if ishandle(fECPlot) ~= 0
        close(fECPlot);
    end
    if ishandle(ECInfo.fBinaryPlot) ~= 0
        close(ECInfo.fBinaryPlot);
    end
    if ishandle(ECInfo.fTernTafelSurf) ~= 0
        close(ECInfo.fTernTafelSurf);
    end
    if ishandle(ECInfo.fTernTafelScatter) ~= 0
        close(ECInfo.fTernTafelScatter);
    end
    if ishandle(ECInfo.fTernOnsetSurf) ~= 0
        close(ECInfo.fTernOnsetSurf);
    end
    if ishandle(ECInfo.fTernOnsetScatter) ~= 0
        close(ECInfo.fTernOnsetScatter);
    end

end

