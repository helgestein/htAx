function [IDs] = getSpecIDs(constPercent, width, comps1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

IDs = find(abs(comps1 - constPercent) < width);

end

