    function [xCoord, yCoord, xrdData] = readXRDData(folder, ...
        filenameInfo, xEDX, yEDX)
    %READXRDDATA reads in all the XRD data files from the folder

    maxPoints = 342;
    maxAngles = 2300;

    % navigate to folder
    fileEnding = filenameInfo.xrdEnd;
    codeDir = pwd;
    cd(folder);
    fileNames = dir(fileEnding);
    cd(codeDir);
    
    % get the coordinates
    wdmX = xEDX;
    wdmY = yEDX;
    
    % initialize arrays
    numAngles = zeros(1, maxPoints);
    
    numPoints = 0;
    
    xCoordIndex = filenameInfo.xrdX;
    yCoordIndex = filenameInfo.xrdY;
    delim = filenameInfo.xrdDelim;
    
    for k = 1:length(fileNames)
        
        if xCoordIndex ~= 0
            file = fileNames(k).name;
            [~, name, ~] = fileparts(file);
            nameComponents = strsplit(name, delim);
            xCoordTemp = str2double(nameComponents(xCoordIndex));
            yCoordTemp = str2double(nameComponents(yCoordIndex));
        else
            indexCoord = k;
            xCoordTemp = wdmX(indexCoord);
            yCoordTemp = wdmY(indexCoord);
        end

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
    for i = 1:length(xCoord)
        
        wdmIndex = findWDMIndex(xCoord(i), yCoord(i));
        
        %MnFeCoO dataset ONLY
        %wdmIndex = findWDMIndex(yCoord(i), -1 * xCoord(i));
        
        if wdmIndex ~= 0
            xrdDataNew(:, wdmIndex * 2 - 1) = xrdData(:, i * 2 - 1);
            xrdDataNew(:, wdmIndex * 2) = xrdData(:, i * 2);
        end
    end

    xrdData = xrdDataNew;
    xCoord = wdmX;
    yCoord = wdmY;

    function foundIndex = findWDMIndex(xCoord, yCoord)
        %[~, found] = max((abs(wdmX - xCoord) + abs(wdmY - yCoord)) == 0);
        found = 0;
        for j = 1:length(wdmX)
            if wdmX(j) == xCoord
                if wdmY(j) == yCoord
                    if found == 0
                        found = j;
                    else
                        found = [found j];
                    end
                end
            end
        end
        if found == 0
            foundIndex = 0;
            'error: failed to match wdm coordinate';
        elseif length(found) > 1
            'error: more than one found index'
            foundIndex = found(1);
        else
            foundIndex = found;
        end
    end

end

