function callbackSaveDB(obj, evt, specHandles)
%CALLBACKSAVEDB saves the database patterns currently being used to a 
%single file in a format that can be read in by htAxe for another analysis 
%session

    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    db.collcodes = specInfo.collcodes;
    db.patterns = specInfo.XRDDatabase;

    [saveFile, savePath] = uigetfile;
    saveFile = strcat(savePath, saveFile);
    
    save(saveFile, '-struct', 'db');
    msgbox('Database patterns saved');
    
end

