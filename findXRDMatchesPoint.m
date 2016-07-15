function [matches, matchData] = findXRDMatchesPoint(indexPoint, XRDData, XRDDatabase)
%FINDXRDMATCHES identifies peaks in the given XRD pattern using the wavelet
%transform, compares those peaks with peaks in patterns from the XRD
%database folder, and returns any matching peaks
    
    angles = XRDData(:, indexPoint * 2 - 1);
    intensity = XRDData(:, indexPoint * 2);
    
    if angles(1) == 0
        matches = zeros(1, length(XRDDatabase(1, :)) / 2);
        matchData = zeros(1, 1);
        return;
    end
    
    % denoise

    dnIntensity = wden(intensity, 'sqtwolog', 's', 'mln', 3, 'sym6');

    % wavelet transform

    scales = 10:0.1:20;
    coefs = cwt(dnIntensity, scales, 'mexh');
    
    %size(coefs, 1)
    %figure;
    %plot(angles, coefs(50, :));
    %coefs(50, :)

    % take one plot out of transform and find its peaks

    coefsSet = coefs(80, :);
    
    ids = find(abs(coefsSet) > 0.0001);
    %length(coefsSet)
    %length(angles)
    coefsSet = coefsSet(ids);
    angles = angles(ids);
    intensity = intensity(ids);
    %length(coefsSet)
    %length(angles)
    
    ids = find(angles ~= 0);
    coefsSet = coefsSet(ids);
    angles = angles(ids);
    intensity = intensity(ids);
    %length(coefsSet)
    %length(angles)
    %figure;
    %plot(angles, coefsSet);
    %angles
    
    %ids = find(abs(angles - 43) < 13);
    %angles = angles(ids);
    %coefsSet = coefsSet(ids);
    %intensity = intensity(ids);
    
    %figure;
    %findpeaks(coefsSet, angles);
    
    [peaks, peakIndex] = findpeaks(coefsSet, angles, 'MinPeakDistance', 5);

    % choose 10 highest peaks

    if isempty(peaks) == 1
        matches = 0;
        matchData = 0;
        return
    end
    numpeaks = min([5 length(peaks)]);
    peaks = transpose(peaks);
    peakInfo = [peaks peakIndex];
    peakInfo = flipud(sortrows(peakInfo));
    anglesToCheck = peakInfo(1:numpeaks, 2);
    intensityToCheck = peakInfo(1:numpeaks, 1);

    
    numFiles = length(XRDDatabase(1, :)) / 2;
    matches = zeros(1, numFiles);
    matchData = zeros(1, 1);
    numSaved = 0;
    tolerance = 0.1;
    intensityTol = 10;
    numAngles = length(anglesToCheck);
    for indexAngle = 1:numAngles
        for indexDatabase = 1:numFiles
            ids1 = abs(XRDDatabase(:, indexDatabase * 2 - 1) - ...
                anglesToCheck(indexAngle)) < tolerance;
            ids2 = XRDDatabase(:, indexDatabase * 2) > intensityTol;
            ids3 = find(ids1 .* ids2);
            if isempty(ids3) ~= 1
                matches(1, indexDatabase) = 1;
                for indexLines = 1:length(ids3)
                    numSaved = numSaved + 1;
                    matchData(numSaved, 1) = indexDatabase;
                    matchData(numSaved, 2) = anglesToCheck(indexAngle);
                    matchData(numSaved, 3) = intensityToCheck(indexAngle);
                    matchData(numSaved, 4) = XRDDatabase(ids3(indexLines), indexDatabase * 2 - 1);
                    matchData(numSaved, 5) = XRDDatabase(ids3(indexLines), indexDatabase * 2);
                end
            end
        end
    end
    
end

