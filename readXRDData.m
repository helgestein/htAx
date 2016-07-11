    function [xCoord, yCoord, xrdData] = readXRDData(folder)
    %READXRDDATA reads in all the XRD data files from the folder

    maxPoints = 342;
    maxAngles = 2300;

    % navigate to folder
    fileEnding = '*.xy'; 
    codeDir = pwd;
    cd(folder);
    fileNames = dir(fileEnding);
    cd(codeDir);
    
    % get the wdm coordinates
    [wdmX, wdmY] = getCoords();

    % initialize arrays
    %xCoord = zeros(1, maxPoints);
    %yCoord = zeros(1, maxPoints);
    xrdData = zeros(maxAngles, length(fileNames));
    numAngles = zeros(1, maxPoints);

    numPoints = 0;
    for k = 1:length(fileNames)

        % get x and y coordinates
        nameComponents = strsplit(fileNames(k).name, '_');
        xCoordTemp = str2double(nameComponents(5));
        yCoordTemp = str2double(nameComponents(4));

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
        [angle, intensity] = ...
            importXRDFile(strcat(folder, '/', fileNames(k).name));
        %if k == 10
        %    angle
        %    intensity
        %end

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

    % match XRD data
    xrdDataNew = zeros(length(xrdData(:, 1)), 342 * 2);
    for i = 1:length(xCoord)
        wdmIndex = findWDMIndex(xCoord(i), yCoord(i));
        if wdmIndex ~= 0
            xrdDataNew(:, wdmIndex * 2 - 1) = xrdData(:, i * 2 - 1);
            xrdDataNew(:, wdmIndex * 2) = xrdData(:, i * 2);
        end
    end

    xrdData = xrdDataNew;
    xCoord = wdmX;
    yCoord = wdmY;

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

