function [matches, matchData] = findXRDMatchesPoint(indexPoint, XRDData, XRDDatabase, confidenceFactor, tol)
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
    
    [pks, proms, peakLocs, widths, ~, ~, ~] = findPeakXRD(angles, intensity, confidenceFactor);
    anglesToCheck = peakLocs;
    widthsToCheck = widths;
    intensityToCheck = pks;
    promsToCheck = proms;   
    
    numFiles = length(XRDDatabase(1, :)) / 2;
    matches = zeros(1, numFiles);
    matchData = zeros(1, 1);
    
    otherData = zeros(1, numFiles);
    
    numSaved = 0;
    tolerance = 0.1;
    intensityTol = 10;
    numAngles = length(anglesToCheck);
    for indexAngle = 1:numAngles
        for indexDatabase = 1:numFiles
            ids1 = abs(XRDDatabase(:, indexDatabase * 2 - 1) - ...
                anglesToCheck(indexAngle)) < (widthsToCheck(indexAngle) * tol);
            ids2 = XRDDatabase(:, indexDatabase * 2) > intensityTol;
            ids3 = find(ids1 .* ids2);
            if isempty(ids3) ~= 1
                for indexLines = 1:length(ids3)
                    numSaved = numSaved + 1;
                    
                    % FOM
                    matchVal = ...
                        promsToCheck(indexAngle) / ...
                        (widthsToCheck(indexAngle) * widthsToCheck(indexAngle)) / ...
                        abs(XRDDatabase(ids3(indexLines), indexDatabase * 2 - 1) - anglesToCheck(indexAngle));
                    
                    %{
                    matchVal = ...
                        promsToCheck(indexAngle) / ...
                        widthsToCheck(indexAngle) / ...
                        abs(XRDDatabase(ids3(indexLines), indexDatabase * 2 - 1) - anglesToCheck(indexAngle));
                    %}
                        
                    matchVal = log10(matchVal);
                    %matchVal = sqrt(matchVal);
                  
                    if matches(1, indexDatabase) < matchVal
                        matches(1, indexDatabase) = matchVal;
                        %otherData(1, indexDatabase) = promsToCheck(indexAngle);
                        %otherData(1, indexDatabase) = widthsToCheck(indexAngle);
                        %otherData(1, indexDatabase) = abs(XRDDatabase(ids3(indexLines), indexDatabase * 2 - 1) - anglesToCheck(indexAngle));
                        %otherData(1, indexDatabase) = power(matchVal, 10);
                    end
                                       
                    %matches(1, indexDatabase) = matchVal + matches(1, indexDatabase);
                    
                    matchData(numSaved, 1) = indexDatabase;
                    matchData(numSaved, 2) = anglesToCheck(indexAngle);
                    matchData(numSaved, 3) = intensityToCheck(indexAngle);
                    matchData(numSaved, 4) = XRDDatabase(ids3(indexLines), indexDatabase * 2 - 1);
                    matchData(numSaved, 5) = XRDDatabase(ids3(indexLines), indexDatabase * 2);
                end
            end
        end
    end

    %matches = otherData;
    
end

