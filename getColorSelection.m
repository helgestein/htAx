function colorSelection = getColorSelection(angle, minAngle, maxAngle)
%GETCOLORSELECTION returns a color value based on the value of the angle in
%comparison to minAngle and maxAngle

    angleFrac = (angle - minAngle) / (maxAngle - minAngle);
    
    % pastel-y
    %origColor = [255 102 102];
    %endColor = [102 178 255];
    
    endColor = [204 0 0]; % red
    origColor = [0 0 204]; % blue
    
    colorSelection = origColor * (1 - angleFrac) + endColor * angleFrac;
    colorSelection = colorSelection / 255;

end

