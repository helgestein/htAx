% creates a ternary diagram from compositions of A, B, and (implied) C,
% given by arrays compA and compB
% comment test for push
%this is a commit over the GUI interface from helge
function [] = plotTernary(compA, compB, vals, handle)

% plot settings
numTicks = 5;

% precalculate to save time
sqrt3Half = sqrt(3) / 2;
sqrt3Inv = 1 / sqrt(3);

% plot triangle
plot(handle, [0 1 0.5 0], [0 0 sqrt3Half 0], 'k');

hold on;

% plot gridlines
tickBottom = linspace(0, 1, numTicks + 1);
tickBottom = tickBottom(1:numTicks);
for i = 1:numTicks
    [xTickLeft(i), yTickLeft(i)] = getTernCoord(0, 1 - tickBottom(i), sqrt3Half, sqrt3Inv);
    [xTickRight(i), yTickRight(i)] = getTernCoord(1 - tickBottom(i), tickBottom(i), sqrt3Half, sqrt3Inv);
end
for i = 2:numTicks
    partnerTick = numTicks - i + 2;
    guidelines1 = plot(handle, [tickBottom(i) xTickRight(partnerTick)], [0 yTickRight(partnerTick)], 'k'); % constant A
    guidelines2 = plot(handle, [xTickLeft(i) xTickRight(partnerTick)], [yTickLeft(i) yTickRight(partnerTick)], 'k'); % constant B
    guidelines3 = plot(handle, [xTickLeft(i) tickBottom(partnerTick)], [yTickLeft(i) 0], 'k'); % constant C
    set(guidelines1, 'color', [0.5 0.5 0.5]);
    set(guidelines2, 'color', [0.5 0.5 0.5]);
    set(guidelines3, 'color', [0.5 0.5 0.5]);
end
    
% get rectangular coordinates from compositions and plot points
numPoints = length(compA);
xCoord = zeros(numPoints, 1);
yCoord = zeros(numPoints, 1);
for i = 1:numPoints
    fracA = compA(i);
    fracB = compB(i);
    [xCoord(i), yCoord(i)] = getTernCoord(fracA, fracB, sqrt3Half, sqrt3Inv);
    %scatter(xCoord, yCoord, 30, [153/255 204/255 255/255], 'filled');
end

scatter(handle, xCoord, yCoord, 30, vals, 'filled');
shading interp;

end

