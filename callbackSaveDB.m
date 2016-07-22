function callbackSaveDB(obj, evt, specHandles)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    db.collcodes = specInfo.collcodes;
    db.patterns = specInfo.XRDDatabase;

    [saveFile, savePath] = uigetfile;
    saveFile = strcat(savePath, saveFile);
    
    save(saveFile, '-struct', 'db');
    msgbox('Database patterns saved');
    
end

