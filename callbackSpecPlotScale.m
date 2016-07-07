function [ output_args ] = callbackSpecPlotScale(obj, evt, plotScale, ternHandles, specHandles, ECHandles)
%CALLBACKSPECPLOTSCALE changes the scale for the z-values on the spec. plot
    
    fSpecPlot = specHandles.fSpecPlot;
    specInfo = fSpecPlot.UserData;
    specInfo.scaleType = plotScale;
    fSpecPlot.UserData = specInfo;
    
    plotSpecData(ternHandles, specHandles, ECHandles);

end

