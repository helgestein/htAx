function [] = callbackEditDotSize(hObj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKEDITDOTSIZE changes the size of the scatter plot dots on the
%ternary diagram

    dotSize = str2double(hObj.String);
    if isnan(dotSize) == 1
        errordlg('not a number');
        resetDotSize(hObj);
    elseif dotSize < 0
        errordlg('not a valid dot size');
        resetDotSize(hObj);
    end
    
    hObj.UserData = dotSize;
    plotTernData(ternHandles, specHandles, ECHandles);
    
    function resetDotSize(hObj)
        hObj.UserData = 30;
        hObj.String = '30';
    end
end

