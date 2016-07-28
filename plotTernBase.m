function plotTernBase(axesHandle, labels)
%PLOTTERNBASE plots the base features of a ternary plot (e.g. guidelines)
% plot settings
    
    % settings
    numTicks = 5;
    labelFontsize = 14;
    
    zMax = [100000 100000]; % so that guidelines are shown above the plot
    
    % precalculated to save time
    global sqrt3Half;
    
    if isempty(sqrt3Half) == 1
        sqrt3Half = sqrt(3) / 2;
    end

    % plot triangle
    plot(axesHandle, [0 1 0.5 0], [0 0 sqrt3Half 0], 'k', 'linewidth', 2);
    set(gca,'XColor','w','YColor','w','TickDir','out'); % eliminate border

    hold on;

    % plot gridlines
    tickBottom = linspace(0, 1, numTicks + 1);
    tickBottom = tickBottom(1:numTicks);
    for i = 1:numTicks
        [xTickLeft(i), yTickLeft(i)] = getTernCoord(0, 1 - tickBottom(i));
        [xTickRight(i), yTickRight(i)] = getTernCoord(1 - tickBottom(i), ...
            tickBottom(i));
    end
    for i = 2:numTicks
        partnerTick = numTicks - i + 2;

        guidelines1 = plot3(axesHandle, ...
            [tickBottom(i) xTickRight(partnerTick)], ...
            [0 yTickRight(partnerTick)], zMax, 'k'); % constant A
        guidelines2 = plot3(axesHandle, ...
            [xTickLeft(i) xTickRight(partnerTick)],...
            [yTickLeft(i) yTickRight(partnerTick)], zMax, 'k'); % constant B
        guidelines3 = plot3(axesHandle, ...
            [xTickLeft(i) tickBottom(partnerTick)],...
            [yTickLeft(i) 0], zMax, 'k'); % constant C

        % make gridlines gray
        set(guidelines1, 'color', [0.5 0.5 0.5]);
        set(guidelines2, 'color', [0.5 0.5 0.5]);
        set(guidelines3, 'color', [0.5 0.5 0.5]);

    end

    % labels
    text(-0.04, -0.02, labels.C, ...
        'FontSize', labelFontsize, ...
        'Rotation', 300, ...
        'FontWeight', 'bold');
    text(0.48, sqrt3Half + 0.03, labels.B, ...
        'FontSize', labelFontsize, ...
        'FontWeight', 'bold');
    text(0.99, -0.06, labels.A, ...
        'FontSize', labelFontsize, ...
        'Rotation', 60, ...
        'FontWeight', 'bold');
    for i = 2:numTicks
        text(xTickRight(i) + 0.03, yTickRight(i), ...
            num2str((i - 1) * 100 / numTicks), ...
            'FontSize', labelFontsize);
        text(tickBottom(i) - 0.01, -0.06, ...
            num2str((i - 1) * 100 / numTicks), ...
            'Fontsize', labelFontsize, ...
            'Rotation', 60);
        text(xTickLeft(i) - 0.07, yTickLeft(i) + 0.01, ...
            num2str((i - 1) * 100 / numTicks), ...
            'FontSize', labelFontsize, ...
            'Rotation', 300);
    end

    % plot stays square even if the size of the figure window changes
    hold off;
    axis image;
    axis off;

end

