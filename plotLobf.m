function lobf = plotLobf(ax, fig, slope, intercept)
%PLOTLOBF plots a line

    xPoints = [-200, 1000];
    yPoints = xPoints * slope + intercept;
    figure(fig);
    hold on;
    lobf = plot(ax, xPoints, yPoints, 'Color', [0.5 0.5 0.5]);

end

