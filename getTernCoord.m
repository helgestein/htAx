function [xCoord, yCoord] = getTernCoord(fracA, fracB, sqrt3Half, sqrt3Inv)
%GETTERNCOORD returns the rectangular coordinates corresponding to the
%given composition

    yCoord = sqrt3Half .* fracB;
    xCoord = fracA + (sqrt3Inv .* yCoord);
end

