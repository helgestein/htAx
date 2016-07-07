function callbackOffset(hObj, evt, ternHandles, specHandles, ECHandles)
%CALLBACKOFFSET changes the vertical distance between CV curves on the
%waterfall plot

    offset = str2double(hObj.String);
    if isnan(offset) == 1
        errordlg('not a number');
        resetOffset(hObj);
    elseif offset < 0
        errordlg('offset cannot be negative');
        resetOffset(hObj);
    end
    
    hObj.UserData = offset;
    
    plotECData(ternHandles, specHandles, ECHandles);
    
    function resetOffset(hObj)
        hObj.UserData = 1;
        hObj.String = '1';
    end

end

