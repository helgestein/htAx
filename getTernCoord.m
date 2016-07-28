function [xCoord, yCoord] = getTernCoord(fracA, fracB)
%GETTERNCOORD returns the rectangular coordinates corresponding to the
%given composition

    global sqrt3Half;
    global sqrt3Inv;
    
    if isempty(sqrt3Half) == 1
        sqrt3Half = sqrt(3) / 2;
    end
    
    if isempty(sqrt3Inv) == 1
        sqrt3Inv = 1 / sqrt(3);
    end

    yCoord = sqrt3Half .* fracB;
    xCoord = fracA + (sqrt3Inv .* yCoord);
end

