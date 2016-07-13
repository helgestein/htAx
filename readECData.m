function [ECData, dataTaken] = readECData(folder, wdmX, wdmY, filenameInfo)
%READECDATA reads in all the EC data files from a given folder

maxPoints = 342;
maxPotentials = 2000;
fileEnding = filenameInfo.ecEnd;
%fileEnding = '*OER.dat';

% initialize arrays
ECData = zeros(maxPotentials, maxPoints * 2);
dataTaken = zeros(maxPoints, 1);

% these values used to confirm that coordinates were sorted correctly
%numChemPoints = 0;
%chemXPoints = zeros(1, 1);
%chemYPoints = zeros(1, 1);
%chemXPointsTrans = zeros(1, 1);
%chemYPointsTrans = zeros(1, 1);

%% read in folder1 data

% navigate to folder1
codeDir = pwd;
cd(folder);
fileNames = dir(fileEnding);
cd(codeDir);

xCoordIndex = filenameInfo.ecX;
yCoordIndex = filenameInfo.ecY;
delim = filenameInfo.ecDelim;

for k = 1:length(fileNames)

    %numChemPoints = numChemPoints + 1;
    
    % get x and y coordinates
    nameComponents = strsplit(fileNames(k).name, delim);
    xCoord = str2double(nameComponents(xCoordIndex));
    yCoord = str2double(nameComponents(yCoordIndex));
    
    %chemXPoints(numChemPoints) = xCoord;
    %chemYPoints(numChemPoints) = yCoord;

    % get index of corresponding WDM coordinates point
    [xTransCoord, yTransCoord] = toWDMCoord(xCoord, yCoord);
    
    %chemXPointsTrans(numChemPoints) = xTransCoord;
    %chemYPointsTrans(numChemPoints) = yTransCoord;
    
    wdmIndex = findWDMIndex(xTransCoord, yTransCoord);
    if wdmIndex ~= 0
        dataTaken(wdmIndex) = 1;

        % get data
        imported = importECFile(strcat(folder, '/', fileNames(k).name));
        
        % remove potentials less than -200
        imported = ...
            removerows(imported, 'ind', find(imported(:, 1) < -200));
        potential = imported(:, 1);
        current = imported(:, 2);
        numPotential = length(potential);
        ECData(1:numPotential, wdmIndex * 2 - 1) = potential;
        ECData(1:numPotential, wdmIndex * 2) = current;
    end

end

%{
%% read in folder2 data

% navigate to folder2
codeDir = pwd;
cd(folder2);
fileNames = dir(fileEnding);
cd(codeDir);

for k = 1:length(fileNames)

    %numChemPoints = numChemPoints + 1;
    
    % get x and y coordinates
    nameComponents = strsplit(fileNames(k).name, '.x');
    xCoord = str2double(nameComponents(1));
    yCoord = str2double(nameComponents(2));
    
    % transform x and y coordinates to account for different starting point
    xCoord = xCoord - 27000;
    yCoord = yCoord + 27000;
    
    %chemXPoints(numChemPoints) = xCoord;
    %chemYPoints(numChemPoints) = yCoord;

    % get index of corresponding WDM coordinates point
    [xTransCoord, yTransCoord] = toWDMCoord(xCoord, yCoord);
    
    %chemXPointsTrans(numChemPoints) = xTransCoord;
    %chemYPointsTrans(numChemPoints) = yTransCoord;
    
    wdmIndex = findWDMIndex(xTransCoord, yTransCoord);
    if wdmIndex ~= 0
        dataTaken(wdmIndex) = 1;

        % get data
        imported = importECFile(strcat(folder2, '/', fileNames(k).name));
        imported = ...
            removerows(imported, 'ind', find(imported(:, 1) < -200));
        potential = imported(:, 1);
        current = imported(:, 2);
        numPotential = length(potential);
        ECData(1:numPotential, wdmIndex * 2 - 1) = potential;
        ECData(1:numPotential, wdmIndex * 2) = current;
    end

end


%% read in folder3 data

% navigate to folder2
codeDir = pwd;
cd(folder3);
fileNames = dir(fileEnding);
cd(codeDir);

for k = 1:length(fileNames)
    
    %numChemPoints = numChemPoints + 1;

    % get x and y coordinates
    nameComponents = strsplit(fileNames(k).name, '.x');
    xCoord = str2double(nameComponents(1));
    yCoord = str2double(nameComponents(2));
    
    % transform x and y coordinates to account for different starting point
    xCoord = xCoord - 13500;
    yCoord = yCoord + 27000;
    
    %chemXPoints(numChemPoints) = xCoord;
    %chemYPoints(numChemPoints) = yCoord;

    % get index of corresponding WDM coordinates point
    [xTransCoord, yTransCoord] = toWDMCoord(xCoord, yCoord);
    
    %chemXPointsTrans(numChemPoints) = xTransCoord;
    %chemYPointsTrans(numChemPoints) = yTransCoord;
    
    wdmIndex = findWDMIndex(xTransCoord, yTransCoord);
    if wdmIndex ~= 0
        dataTaken(wdmIndex) = 1;

        % get data
        imported = importECFile(strcat(folder3, '/', fileNames(k).name));
        imported = ...
            removerows(imported, 'ind', find(imported(:, 1) < -200));
        potential = imported(:, 1);
        current = imported(:, 2);
        numPotential = length(potential);
        ECData(1:numPotential, wdmIndex * 2 - 1) = potential;
        ECData(1:numPotential, wdmIndex * 2) = current;
    end
end

%figure;
%scatter(chemXPoints, chemYPoints);
%figure;
%zVals = ones(1, length(chemXPointsTrans));
%scatter3(chemXPointsTrans, chemYPointsTrans, zVals, 'b');
%hold on
%zVals2 = 2 * ones(1, length(wdmX));
%scatter3(wdmX, wdmY, zVals2, 'r');

%}

%% helper functions

    %% transform coordinates used in taking EC data to WDM coordinate system coordinates

    function [xTransCoord, yTransCoord] = toWDMCoord(xCoord, yCoord)
        xTransCoord = (xCoord - 18000) / 1000;
        yTransCoord = (-1 * yCoord + 40500) / 1000;
    end

    %% given coordinates in WDM coordinate system, find corresponding index
    function foundIndex = findWDMIndex(xCoord, yCoord)
        [~, found] = max((abs(wdmX - xCoord) + abs(wdmY - yCoord)) == 0);
        if isempty(found)
            foundIndex = 0;
        elseif length(found) > 1
            'error: more than one found index'
            foundIndex = found(1);
        else
            foundIndex = found;
        end
    end


end

