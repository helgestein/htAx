% reads in all XRD data files from folder; if there are files with the same
% x and y coordinate, will merge them together; returns the x coordinate, y
% coordinate, and associated data at each point in parallel arrays

function [xCoord, yCoord, xrdData] = readXRDData(folder)

maxPoints = 342;
maxAngles = 2300;

% navigate to folder
fileEnding = '*.xy'; 
codeDir = pwd;
cd(folder);
fileNames = dir(fileEnding);
cd(codeDir);

% initialize arrays
xCoord = zeros(1, maxPoints);
yCoord = zeros(1, maxPoints);
xrdData = zeros(maxAngles, length(fileNames));
numAngles = zeros(1, maxPoints);

numPoints = 0;
for k = 1:length(fileNames)
    
    % get x and y coordinates
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
    
    % get data
    [angle, intensity] = importXRDFile(strcat(folder, '/', fileNames(k).name));
    
    % merge data if duplicate; if not, make new data point
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
        numAngles(index) = numAnglesTemp;
        numPoints = index;
    end
end
end

