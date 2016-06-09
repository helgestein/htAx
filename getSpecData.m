function [specPlotData] = getSpecData(constType, lower, upper, comps1, comps2, data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

numPoints = length(comps1);
entries = 0;

specPlotData = zeros(8000, 3);

for i = 1:numPoints
    
    % if composition is in desired range, save data
    % for constant A save B data, for constant B save C data, for
    % constant C save A data
    comp = comps1(i);
    if comp >= lower
        if comp <= upper
            for j = 1:length(data(:, 1))
                entries = entries + 1;
                specPlotData(entries, 1) = comps2(i);
                specPlotData(entries, 2) = data(j, 2 * i - 1);
                specPlotData(entries, 3) = data(j, 2 * i);
            end
        end
    end
    if entries > 6000
        break;
end

end

