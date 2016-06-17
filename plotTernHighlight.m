function [highlighted] = plotTernHighlight(fTernDiagram, zMax, ...
    constPercent, width, constType, sqrt3Half, sqrt3Inv)
%PLOTTERNHIGHLIGHT highlights the part of the ternary diagram selected by
%the composition constraints specified by the user

upper = constPercent + width;
lower = constPercent - width;

if constType == 0
    [x(1), y(1)] = ...
        getTernCoord(upper, 1 - upper, sqrt3Half, sqrt3Inv);
    [x(2), y(2)] = ...
        getTernCoord(lower, 1 - lower, sqrt3Half, sqrt3Inv);
    [x(3), y(3)] = ...
        getTernCoord(lower, 0, sqrt3Half, sqrt3Inv);
    [x(4), y(4)] = ...
        getTernCoord(upper, 0, sqrt3Half, sqrt3Inv);
elseif constType == 1
    [x(1), y(1)] = ...
        getTernCoord(0, upper, sqrt3Half, sqrt3Inv);
    [x(2), y(2)] = ...
        getTernCoord(0, lower, sqrt3Half, sqrt3Inv);
    [x(3), y(3)] = ...
        getTernCoord(1 - lower, lower, sqrt3Half, sqrt3Inv);
    [x(4), y(4)] = ...
        getTernCoord(1 - upper, upper, sqrt3Half, sqrt3Inv);
else
    [x(1), y(1)] = ...
        getTernCoord(1 - upper, 0, sqrt3Half, sqrt3Inv);
    [x(2), y(2)] = ...
        getTernCoord(1 - lower, 0, sqrt3Half, sqrt3Inv);
    [x(3), y(3)] = ...
        getTernCoord(0, 1 - lower, sqrt3Half, sqrt3Inv);
    [x(4), y(4)] = ...
        getTernCoord(0, 1 - upper, sqrt3Half, sqrt3Inv);
end
z = [zMax zMax zMax zMax];
figure(fTernDiagram);
hold on;
highlighted = fill3(x, y, z, [0.5 0.5 0.5]);
set(highlighted, 'EdgeColor', 'none');
alpha(highlighted, 0.1);
view(2);

end

