function [] = plotTernSurf(xCoord, yCoord, vals)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

tri = delaunay(xCoord, yCoord);
trisurf(tri, xCoord, yCoord, vals);
view(2);
shading interp;

end

