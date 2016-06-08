function [xCoord, yCoord, xrdData] = readXRDData(folder)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

fileEnding = '*.xy'; 
codeDir = pwd;
cd(folder);
fileNames = dir(fileEnding);
cd(codeDir);

%xCoord = zeros(342, 1);
%yCoord = zeros(342, 1);
xrdData = zeros(1500, length(fileNames));

numPoints = 0;
for k = 1:length(fileNames)
    nameComponents = strsplit(fileNames(k).name, '_');
    xCoordTemp = str2double(nameComponents(4));
    yCoordTemp = str2double(nameComponents(5));
    
    % check if duplicate
    duplicate = 0;
    index = numPoints + 1;
    for i = 1:numPoints
        if xCoord(i) == xCoordTemp
            if yCoord(i) == yCoordTemp
                index = i;
                duplicate = 1;
                break;
            end                
        end
    end
    
    [angle, intensity] = importXRDFile(strcat(folder, '/', fileNames(k).name));
    
    if duplicate == 1
        xIndex = numAngles(index) + 1;
        numAngles(index) = numAngles(index) + length(angle);
        xrdData(xIndex:numAngles(index), 2 * index - 1) = angle;
        xrdData(xIndex:numAngles(index), 2 * index) = intensity;
    else
        numAnglesTemp = length(angle);
        xrdData(1:numAnglesTemp, 2 * index - 1) = angle;
        xrdData(1:numAnglesTemp, 2 * index) = intensity;
        xCoord(index) = xCoordTemp;
        yCoord(index) = yCoordTemp;
        numAngles(index) = length(angle);
        numPoints = index;
    end
end
end

