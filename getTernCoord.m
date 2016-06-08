% converts the percentages of A and B into rectangular coordinates for a
% ternary diagram

function [xCoord, yCoord] = getTernCoord(fracA, fracB, sqrt3Half, sqrt3Inv)
    yCoord = fracB * sqrt3Half;
    xCoord = fracA + yCoord * sqrt3Inv;
end

