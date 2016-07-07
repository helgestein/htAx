function minIndex = findNearestPoint(xSelect, ySelect, ...
    numPoints, xPoints, yPoints)
%FINDNEARESTPOINT called FINDNEARESTPOINT(XSELECT, YSELECT, NUMPOINTS,
%XPOINTS, YPOINTS) returns the index of the closest point in XPOINTS and
%YPOINTS to (XSELECT, YSELECT)

    minDist = realmax;
    minIndex = 1;
    for i = 1:numPoints
        distTemp = squareDistance(xSelect, ySelect, xPoints(i), yPoints(i));
        if distTemp < minDist
            minDist = distTemp;
            minIndex = i;
        end
    end
    
    function sqDist = squareDistance(x1, y1, x2, y2)
        sqDist = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
    end

end

