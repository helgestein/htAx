function [] = plotTernScatter(xCoord, yCoord, vals, axesHandle, dotSize)
%PLOTTERNSCATTER Summary of this function goes here
%   Detailed explanation goes here

scatter(axesHandle, xCoord, yCoord, dotSize, vals, 'filled'); 

end