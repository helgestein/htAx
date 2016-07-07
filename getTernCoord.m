function [xCoord, yCoord] = getTernCoord(fracA, fracB)
%GETTERNCOORD returns the rectangular coordinates corresponding to the
%given composition

    global sqrt3Half;
    global sqrt3Inv;

    yCoord = sqrt3Half .* fracB;
    xCoord = fracA + (sqrt3Inv .* yCoord);
end

