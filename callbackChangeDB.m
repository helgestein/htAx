function callbackChangeDB(obj, evt, file, specHandles)
%CALLBACKCHANGEDB allows the user to select a new set of database patterns
%to be compared with the experimental patterns

    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    

    if file == 0
        % import new database patterns from folder
        
        XRDDatabaseFolder = uigetdir;
        
        [collcodes, XRDDatabase] = readXRDDatabase(XRDDatabaseFolder);
        
        specInfo.collcodes = collcodes;
        specInfo.XRDDatabase = XRDDatabase;
        
    else
        % import new database patterns from file
        
        [file, path] = uigetfile;
        XRDDatabaseFile = strcat(path, file);
        
        db = load(XRDDatabaseFile, '-mat');
        
        specInfo.collcodes = db.collcodes;
        specInfo.XRDDatabase = db.patterns;
    end

    fSpecPlot.UserData = specInfo;
    
end

