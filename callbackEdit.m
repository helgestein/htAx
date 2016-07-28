function [] = callbackEdit(hObj, evt)
%CALLBACKEDIT updates a percentage value

hObj.UserData = str2double(hObj.String) / 100;

end