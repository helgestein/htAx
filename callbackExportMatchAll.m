function callbackExportMatchAll(obj, evt, ternHandles, specHandles)
%CALLBACKEXPORTMATCHALL exports a struct containing COLLCODES and MATCHINFO
%where MATCHINFO is a (number of ternary points) x (number of database
%patterns) matrix where each element is the FOM for that point-pattern
%combination

    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    if isempty(specInfo.matchInfo) == 1
        callbackXRDMatchAll(obj, evt, ternHandles, specHandles);
    end
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    
    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    matches.collcodes = specInfo.collcodes;
    matches.matchInfo = specInfo.matchInfo;
    matches.valsA = ternInfo.valsCompA;
    matches.valsB = ternInfo.valsCompB;
    matches.valsC = ternInfo.valsCompC;
    matches.xCoords = ternInfo.xCoords;
    matches.yCoords = ternInfo.yCoords;
    matches.labels = ternInfo.labels;

    [file, path] = uigetfile;
    exportFile = strcat(path, file);
    
    save(exportFile, '-struct', 'matches');
    msgbox('Matches exported');
end

