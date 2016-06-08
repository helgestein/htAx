function [xCoord, yCoord] = getTernCoord(fracA, fracB, sqrt3Half, sqrt3Inv)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    yCoord = fracB * sqrt3Half;
    xCoord = fracA + yCoord * sqrt3Inv;
end

