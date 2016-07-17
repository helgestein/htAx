function [] = beginAnalysis(XRDFolder, EDXFile, EDXCoordFile, saveFile, ...
    ECFolder, XRDDatabaseFolder, filenameInfo)
%BEGINANALYSIS takes in the name of a folder that contains XRD data, the
%name of a file with EDX data, and the name of a file to which the analysis
%can be saved and begins a new analysis session with the data
%   example call:
%   beginAnalysis('/Users/sjiao/Documents/summer_2016/data/CoFeMnO-mapcorr',
%   '/Users/sjiao/Documents/summer_2016/data/MnFeCoO-EDX',
%   '/Users/sjiao/Documents/summer_2016/code/testFiles/testSave.txt')

    % read in XRD and EDX data
    [xEDX, yEDX] = importEDXCoordFile(EDXCoordFile);
    [xCoord, yCoord, XRDData] = readXRDData(XRDFolder, filenameInfo, xEDX, yEDX);
    [A, B, C] = importEDXFile(EDXFile);

    % convert EDX data to percents
    ids = find(A < 0);
    A(ids) = 0;
    ids = find(B < 0);
    B(ids) = 0;
    ids = find(C < 0);
    C(ids) = 0;
    % normalize
    sums = A + B + C;
    A = A ./ sums;
    B = B ./ sums;
    C = C ./ sums;

    % read in EC data
    if ECFolder ~= 1
        ECData = readECData(ECFolder, xCoord, yCoord, filenameInfo);
    else
        %ECData = 1;
        % fill in dummy EC data
        numPoints = size(XRDData, 2) / 2;
        numPots = size(XRDData, 1);
        ECData = zeros(size(XRDData, 1), size(XRDData, 2));
        for i = 1:numPoints
            ECData(:, i * 2 - 1) = 1:numPots;
        end
    end

    % read in XRD database folder
    if XRDDatabaseFolder ~= 1
        [collcodes, XRDDatabase] = readXRDDatabase(XRDDatabaseFolder);
    else
        collcodes = 1;
        XRDDatabase = 1;
    end
    
    %[XRDData(:, 459), XRDData(:, 460)]
    
    %find all points for which XRD data was not taken
    ids = find(XRDData(1, :) + XRDData(2, :) == 0);
    %testids = find(XRDData(1, 2* (1:(size(XRDData, 2)/2))) == 0)
    %XRDData(10, ids)
    %XRDData(12, ids)
    %ids
    %XRDData(1, 658)
    numToRemove = length(ids);
    edxToRemove = ids(2 * (1:(numToRemove / 2))) / 2;
    A = removerows(A, edxToRemove);
    B = removerows(B, edxToRemove);
    C = removerows(C, edxToRemove);
    %length(A)
    %colsToRemove = [ids * 2 - 1 ids * 2];
    colsToRemove = ids;
    XRDData = transpose(removerows(transpose(XRDData), colsToRemove));
    ECData = transpose(removerows(transpose(ECData), colsToRemove));
    %size(XRDData, 2) / 2
    %size(ECData, 2) / 2

    pointInfo = zeros(1, 11);
    numSelected = 0;
    ECPlotInfo = zeros(342, 4);

    openFigs(saveFile, XRDData, A, B, C, numSelected, pointInfo, ECData, ...
        ECPlotInfo, collcodes, XRDDatabase);
end

