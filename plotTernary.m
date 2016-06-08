% creates a ternary diagram from compositions of A, B, and (implied) C,
% given by arrays compA and compB
% comment test for push
function [] = plotTernary(compA, compB)

% plot settings
numTicks = 5;

% precalculate to save time
sqrt3Half = sqrt(3) / 2;
sqrt3Inv = 1 / sqrt(3);

% plot triangle
plot([0 1 0.5 0], [0 0 sqrt3Half 0], 'k');

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
    plot([tickBottom(i) xTickRight(partnerTick)], [0 yTickRight(partnerTick)], 'k'); % constant A
    plot([xTickLeft(i) xTickRight(partnerTick)], [yTickLeft(i) yTickRight(partnerTick)], 'k'); % constant B
    plot([xTickLeft(i) tickBottom(partnerTick)], [yTickLeft(i) 0], 'k'); % constant C
end
    
% get rectangular coordinates from compositions and plot points
numPoints = length(compA);
for i = 1:numPoints
    fracA = compA(i);
    fracB = compB(i);
    [xCoord, yCoord] = getTernCoord(fracA, fracB, sqrt3Half, sqrt3Inv);
    scatter(xCoord, yCoord, 30, 'filled');
end

end

