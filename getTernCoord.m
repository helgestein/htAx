function [xCoord, yCoord] = getTernCoord(fracA, fracB)
%GETTERNCOORD returns the rectangular coordinates corresponding to the
%given composition
%SQRT3HALF and SQRT3INV must be set as global variables before calling
%GETTERNCOORD

    global sqrt3Half;
    global sqrt3Inv;

    yCoord = sqrt3Half .* fracB;
    xCoord = fracA + (sqrt3Inv .* yCoord);
end

