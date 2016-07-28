function XRDData = readXRDFileAll(XRDFile)
%READXRDFILEALL reads in XRD data from a single file

    data = importdata(XRDFile);
    numAngles = size(data, 2);
    numPoints = size(data, 1) - 1;
    XRDData = zeros(numAngles, numPoints * 2);
    
    for i = 1:numPoints
        XRDData(:, i * 2 - 1) = transpose(data(1, :));
        XRDData(:, i * 2) = transpose(data(i + 1, :));
    end

end

