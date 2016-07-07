function callbackButtonConst(obj, evt, constComp, ternHandles, ...
    specHandles, ECHandles)
%CALLBACKBUTTONCONST plots the spec. and EC data according to the
%user-selected ternary region

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    ternInfo.constType = constComp;
    
    figTern.UserData = ternInfo;
    
    hEditConst = ternHandles.editConst;
    hEditWidth = ternHandles.editWidth;
    valConst = hEditConst.UserData;
    valWidth = hEditWidth.UserData;
    
    if checkInputErrorComp(valConst, valWidth) == 1
        resetConst(hEditConst, hEditWidth);
    else
        plotSpecData(ternHandles, specHandles, ECHandles);
        plotECData(ternHandles, specHandles, ECHandles);
    end
    
    function isError = checkInputErrorComp(constPercent, width)
 
        if isnan(constPercent)
            errordlg('comp. not a number');
            isError = 1;
        elseif isnan(width)
            errordlg('width not a number');
            isError = 1;
        elseif constPercent < 0
            errordlg('invalid composition percent');
            isError = 1;
        elseif constPercent > 1
            errordlg('invalid composition percent');
            isError = 1;
        elseif width < 0
            errordlg('invalid width');
            isError = 1;
        elseif width > 1
            errordlg('invalid width');
            isError = 1;
        elseif (constPercent + width) > 1
            errordlg('invalid width-percent combination');
            isError = 1;
        elseif (constPercent - width) < 0
            errordlg('invalid width-percent combination');
            isError = 1;
        else
            isError = 0;
        end
        
    end

    function [] = resetConst(editConstObj, editWidthObj)

        editConstObj.UserData = 0;
        editWidthObj.UserData = 0;
        editConstObj.String = '0';
        editWidthObj.String = '0';

    end

end

