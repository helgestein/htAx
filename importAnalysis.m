function [] = importAnalysis(analysisFile, saveFile)
%IMPORTANALYSIS reloads an analysis session

analysis = load(analysisFile, '-mat');

openTernFigs(saveFile, analysis.data, ...
    analysis.A, analysis.B, analysis.C, ...
    analysis.numSelected, analysis.pointInfo);

end

