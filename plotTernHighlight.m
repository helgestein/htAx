function [highlighted] = plotTernHighlight(fTernDiagram, zMax, ...
    constPercent, width, constType)
%PLOTTERNHIGHLIGHT highlights the part of the ternary diagram selected by
%the composition constraints specified by the user

    upper = constPercent + width;
    lower = constPercent - width;
    ternInfo = fTernDiagram.UserData;

    if constType == 0
        [x(1), y(1)] = getTernCoord(upper, 1 - upper);
        [x(2), y(2)] = getTernCoord(lower, 1 - lower);
        [x(3), y(3)] = getTernCoord(lower, 0);
        [x(4), y(4)] = getTernCoord(upper, 0);
    elseif constType == 1
        [x(1), y(1)] = getTernCoord(0, upper);
        [x(2), y(2)] = getTernCoord(0, lower);
        [x(3), y(3)] = getTernCoord(1 - lower, lower);
        [x(4), y(4)] = getTernCoord(1 - upper, upper);
    else
        [x(1), y(1)] = getTernCoord(1 - upper, 0);
        [x(2), y(2)] = getTernCoord(1 - lower, 0);
        [x(3), y(3)] = getTernCoord(0, 1 - lower);
        [x(4), y(4)] = getTernCoord(0, 1 - upper);
    end
    
    z = [zMax zMax zMax zMax];
    figure(fTernDiagram);
    hold on;
    
    if ternInfo.polySelected ~= 1
        highlighted = fill3(x, y, z, [0.3 0.3 0.3]);
    else
        xPoly = ternInfo.xPoly;
        yPoly = ternInfo.yPoly;
        z = zMax * ones(length(xPoly));
        
        highlighted = fill3(xPoly, yPoly, z, [0.3 0.3 0.3]);
    end
    set(highlighted, 'EdgeColor', 'none');
    alpha(highlighted, 0.1);
    view(2);

end

