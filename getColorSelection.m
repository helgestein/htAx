function colorSelection = getColorSelection(angle, minAngle, maxAngle)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    angleFrac = (angle - minAngle) / (maxAngle - minAngle);
    
    % pastel-y
    %origColor = [255 102 102];
    %endColor = [102 178 255];
    
    endColor = [204 0 0]; % red
    origColor = [0 0 204]; % blue
    
    colorSelection = origColor * (1 - angleFrac) + endColor * angleFrac;
    colorSelection = colorSelection / 255;

end

