function [] = plotSpecData(specPlotData)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numPoints = length(specPlotData(:, 1));
figure;
hold on;
for i = 1:numPoints
    % determine color
    intensity = specPlotData(i, 3);
    if intensity < 40
        color = 'r';
    elseif intensity < 50
        color = 'y';
    elseif intensity < 60
        color = 'g';
    elseif intensity < 70
        color = 'c';
    else
        color = 'b';
    end
    
    % plot
    scatter(specPlotData(i, 2), specPlotData(i, 1), 30, color);

end

