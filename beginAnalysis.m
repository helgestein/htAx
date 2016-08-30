function [] = beginAnalysis(XRDFolder, EDXFile, EDXCoordFile, ...
    ECFolder, XRDDatabaseFolder, filenameInfo, dataFolder)
%BEGINANALYSIS takes in the name of a folder that contains XRD data, the
%name of a file with EDX data, and the name of a file to which the analysis
%can be saved and begins a new analysis session with the data

    % labels
    labels.A = filenameInfo.labelA;
    labels.B = filenameInfo.labelB;
    labels.C = filenameInfo.labelC;
    
    filenameInfo.dataDelim
    filenameInfo.dataEnd

    % read in XRD and EDX data
    
    if filenameInfo.xrdFile == 0
        [xEDX, yEDX] = importEDXCoordFile(EDXCoordFile);
        [xCoord, yCoord, XRDData] = readXRDData(XRDFolder, filenameInfo, xEDX, yEDX);
    else
        XRDData = readXRDFileAll(XRDFolder);
    end
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
    if sums ~= 0
        A = A ./ sums;
        B = B ./ sums;
        C = C ./ sums;
    end

    % read in EC data
    if ECFolder ~= 1
        ECData = readECData(ECFolder, xCoord, yCoord, filenameInfo);
        ECDataReal = 1;
    else 
        % fill in dummy EC data
        numPoints = size(XRDData, 2) / 2;
        numPots = size(XRDData, 1);
        ECData = zeros(size(XRDData, 1), size(XRDData, 2));
        for i = 1:numPoints
            ECData(:, i * 2 - 1) = 1:numPots;
        end
        ECDataReal = 0;
    end
    
    % read in other dataset
    if isempty(filenameInfo.dataDelim) ~= 1
        otherData = readOtherData(dataFolder, filenameInfo, xCoord, yCoord);
    end

    % read in XRD database folder
    if XRDDatabaseFolder ~= 1
        [collcodes, XRDDatabase] = readXRDDatabase(XRDDatabaseFolder);
    else
        collcodes = 1;
        XRDDatabase = 1;
    end
       
    %find all points for which XRD data was not taken and remove those
    %columns
    ids = find(XRDData(1, :) + XRDData(2, :) == 0);
    numToRemove = length(ids);
    edxToRemove = ids(2 * (1:(numToRemove / 2))) / 2;
    A = removerows(A, edxToRemove);
    B = removerows(B, edxToRemove);
    C = removerows(C, edxToRemove);
    colsToRemove = ids;
    XRDData = transpose(removerows(transpose(XRDData), colsToRemove));
    ECData = transpose(removerows(transpose(ECData), colsToRemove));

    pointInfo = zeros(1, 12);
    numSelected = 0;
    ECPlotInfo = zeros(342, 4);
    savedPoly = zeros(1, 6);

    openFigs(XRDData, A, B, C, numSelected, pointInfo, ECData, ...
        ECPlotInfo, collcodes, XRDDatabase, labels, savedPoly, ...
        ECDataReal, otherData);
end

