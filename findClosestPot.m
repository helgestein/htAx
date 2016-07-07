function indexClosest = findClosestPot(value, potentials)
%FINDCLOSESTPOT finds the index of the closest potential in the range of 
%increasing potentials

    [~, maxPotIndex] = max(potentials);
    [~, indexClosest] = min(abs(potentials(1:maxPotIndex) - value));

end

