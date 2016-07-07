function callbackSlopeFit(obj, evt, lower, ECHandles)
%CALLBACKSLOPEFIT fits a line through the selected data in a CV plot

    fECPlot = ECHandles.fECPlot;
    ECInfo = fECPlot.UserData;
    
    valSlider1 = ECInfo.valSliderFit1;
    valSlider2 = ECInfo.valSliderFit2;
    ECData = ECInfo.ECData;
    genIndex = ECInfo.selectedPlotGenIndex;
    dispIndex = ECInfo.selectedPlotDispIndex;
    hEditOffset = ECHandles.editOffset;
    ECPlotInfo = ECInfo.ECPlotInfo;
    
    plotPotential = ECData(:, genIndex * 2 - 1);
    plotCurrent = log10(abs(ECData(:, genIndex * 2))) + ...
        hEditOffset.UserData * (dispIndex - 1);
    waterfallPlot = ECInfo.waterfallPlot;
    lobfData = ECInfo.lobfData;
    
    [slope, intercept] = getFit(valSlider1, valSlider2, ...
        plotPotential, plotCurrent, ECPlotInfo(genIndex, 4));
    
    if lower == 1
        
        if ishandle(ECInfo.lowLobf) == 1
            delete(ECInfo.lowLobf);
        end
        
        ECInfo.lowLobf = ...
            plotLobf(waterfallPlot.dataAxes, ECHandles.fECPlot, ...
            slope, intercept);
        
        lobfData(genIndex, 1) = slope;
        lobfData(genIndex, 2) = intercept;
        lobfData(genIndex, 5) = 1;
        
        set(ECHandles.textLowerSlope, 'String', ...
            strcat({'y = '}, num2str(slope), {'x + '}, num2str(intercept)));
    else
        
        if ishandle(ECInfo.highLobf) == 1
            delete(ECInfo.highLobf);
        end
        
        ECInfo.highLobf = ...
            plotLobf(waterfallPlot.dataAxes, ECHandles.fECPlot, ...
            slope, intercept);
        
        lobfData(genIndex, 3) = slope;
        lobfData(genIndex, 4) = intercept;
        lobfData(genIndex, 6) = 1;
        
        set(ECHandles.textHigherSlope, 'String', ...
            strcat({'y = '}, num2str(slope), {'x + '}, num2str(intercept)));
    end
    
    ECInfo.lobfData = lobfData;
    fECPlot.UserData = ECInfo;
    
    function [slope, intercept] = getFit(valSlider1, valSlider2, ...
            plotPotential, plotCurrent, decrease)
        
        if valSlider1 < valSlider2 
            if decrease == -1
                lowIndex = findClosestPotDecrease(valSlider2, plotPotential);
                highIndex = findClosestPotDecrease(valSlider1, plotPotential);
            else
                lowIndex = findClosestPot(valSlider1, plotPotential);
                highIndex = findClosestPot(valSlider2, plotPotential);
            end
        else
            if decrease == -1
                lowIndex = findClosestPotDecrease(valSlider1, plotPotential);
                highIndex = findClosestPotDecrease(valSlider2, plotPotential);
            else
                lowIndex = findClosestPot(valSlider2, plotPotential);
                highIndex = findClosestPot(valSlider1, plotPotential);
            end
        end
        
        linearFit = polyfit(plotPotential(lowIndex:highIndex), ...
            plotCurrent(lowIndex:highIndex), 1);
        slope = linearFit(1);
        intercept = linearFit(2);
        
    end
end

