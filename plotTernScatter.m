function [] = plotTernScatter(xCoord, yCoord, vals, axesHandle)
%PLOTTERNSCATTER Summary of this function goes here
%   Detailed explanation goes here

% plot settings
dotSize = 30;

scatter(axesHandle, xCoord, yCoord, dotSize, vals, 'filled'); 

end