function [IDs] = getSpecIDs(constPercent, width, comps1)
%GETSPECIDS gets the indices of all compositions between CONSTPERCENT -
%WIDTH and CONSTPERCENT + WIDTH

IDs = find(abs(comps1 - constPercent) < width);

end

