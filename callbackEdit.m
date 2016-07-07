function [] = callbackEdit(hObj, evt)
%CALLBACKEDIT updates a value

hObj.UserData = str2double(hObj.String) / 100;

end