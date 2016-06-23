function [isError] = checkInputErrorComp(constPercent, width)
%CHECKINPUTERRORCOMP checks for an error in the user-specified composition
%spread

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

