function callbackButtonSaveClose(obj, evt, saveFile, ternHandles, specHandles, ECHandles)
%CALLBACKBUTTONSAVECLOSE saves the analysis and closes the GUI

    callbackSaveAnalysis(obj, evt, saveFile, ternHandles, specHandles, ECHandles);
    callbackButtonClose(obj, evt, ternHandles, specHandles, ECHandles);

end

