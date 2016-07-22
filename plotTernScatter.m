function [] = plotTernScatter(xCoord, yCoord, vals, axesHandle, dotSize)
%PLOTTERNSCATTER plots a ternary plot as a scatter plot

hold on;
scatter(axesHandle, xCoord, yCoord, dotSize, vals, 'filled'); 

end