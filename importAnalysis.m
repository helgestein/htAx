function [] = importAnalysis(analysisFile, saveFile)
%IMPORTANALYSIS reloads an analysis session

analysis = load(analysisFile, '-mat');

openFigs(saveFile, analysis.XRDData, ...
    analysis.A, analysis.B, analysis.C, ...
    analysis.numSelected, analysis.pointInfo, ...
    analysis.ECData, analysis.ECPlotInfo);

end

