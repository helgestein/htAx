function callbackButtonSaveClose(obj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKBUTTONSAVECLOSE saves the analysis and closes the GUI

    callbackSaveAnalysis(obj, evt, ternHandles, specHandles, ECHandles);
    callbackButtonClose(obj, evt, ternHandles, specHandles, ECHandles);

end

