function [ECData, dataTaken] = readECData(folder1, folder2, folder3, wdmX, wdmY)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

maxPoints = 342;
maxPotentials = 2000;
fileEnding = '*OER.dat';

% initialize arrays
ECData = zeros(maxPotentials, maxPoints * 2);
dataTaken = zeros(maxPoints, 1);

%% read in folder1 data

% navigate to folder1
codeDir = pwd;
cd(folder1);
fileNames = dir(fileEnding);
cd(codeDir);

for k = 1:length(fileNames)

    % get x and y coordinates
    nameComponents = strsplit(fileNames(k).name, 'x');
    xCoord = str2double(nameComponents(1));
    yCoord = str2double(nameComponents(2));

    % get index of corresponding WDM coordinates point
    [xTransCoord, yTransCoord] = toWDMCoord(xCoord, yCoord);
    wdmIndex = findWDMIndex(xTransCoord, yTransCoord);
    if wdmIndex ~= 0
        dataTaken(wdmIndex) = 1;

        % get data
        imported = importECFile(strcat(folder1, '/', fileNames(k).name));
        imported = ...
            removerows(imported, 'ind', find(imported(:, 1) < -200));
        potential = imported(:, 1);
        current = imported(:, 2);
        numPotential = length(potential);
        ECData(1:numPotential, wdmIndex * 2 - 1) = potential;
        ECData(1:numPotential, wdmIndex * 2) = current;
    end

end

%% read in folder2 data

% navigate to folder2
codeDir = pwd;
cd(folder2);
fileNames = dir(fileEnding);
cd(codeDir);

for k = 1:length(fileNames)

    % get x and y coordinates
    nameComponents = strsplit(fileNames(k).name, '.x');
    xCoord = str2double(nameComponents(1));
    yCoord = str2double(nameComponents(2));
    
    % transform x and y coordinates to account for different starting point
    xCoord = xCoord - 27000;
    yCoord = yCoord + 27000;

    % get index of corresponding WDM coordinates point
    [xTransCoord, yTransCoord] = toWDMCoord(xCoord, yCoord);
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

    % get x and y coordinates
    nameComponents = strsplit(fileNames(k).name, '.x');
    xCoord = str2double(nameComponents(1));
    yCoord = str2double(nameComponents(2));
    
    % transform x and y coordinates to account for different starting point
    xCoord = xCoord - 13500;
    yCoord = yCoord + 27000;

    % get index of corresponding WDM coordinates point
    [xTransCoord, yTransCoord] = toWDMCoord(xCoord, yCoord);
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

%% helper functions

    %% transform coordinates used in taking EC data to WDM coordinate system coordinates

    function [xTransCoord, yTransCoord] = toWDMCoord(xCoord, yCoord)
        xTransCoord = (xCoord - 18000) / 1000;
        yTransCoord = (-1 * yCoord + 40500) / 1000;
    end

    %% given coordinates in WDM coordinate system, find corresponding index
    function foundIndex = findWDMIndex(xCoord, yCoord)
        [maxNum, found] = max((abs(wdmX - xCoord) + abs(wdmY - yCoord)) == 0);
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

