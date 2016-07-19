function XRDData = readXRDFileAll(XRDFile)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    data = importXRDFileAll(XRDFile);
    numAngles = size(data, 2);
    numPoints = size(data, 1) - 1;
    XRDData = zeros(numAngles, numPoints * 2);
    
    for i = 1:numPoints
        XRDData(:, i * 2 - 1) = transpose(data(1, :));
        XRDData(:, i * 2) = transpose(data(i + 1, :));
    end

end

