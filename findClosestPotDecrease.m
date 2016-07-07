function indexClosest = findClosestPotDecrease(value, potentials)
%FINDCLOSESTPOTDECREASE finds the index of the closest potential in the
%range of decreasing potentials

    [~, maxPotIndex] = max(potentials);
    numPotentials = length(potentials);
    [~, indexClosest] = ...
        min(abs(potentials((maxPotIndex + 1):numPotentials) - value));

    indexClosest = indexClosest + maxPotIndex;
    
end

