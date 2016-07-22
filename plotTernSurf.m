function [] = plotTernSurf(xCoord, yCoord, vals)
%PLOTTERNSURF plots a ternary plot as a surface plot

hold on;
tri = delaunay(xCoord, yCoord);
trisurf(tri, xCoord, yCoord, vals);
view(2);
shading interp;

end

