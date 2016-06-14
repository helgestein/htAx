function [ output_args ] = importAnalysis(analysisFile, saveFile)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

analysis = load(analysisFile, '-mat');

openTernFigs(saveFile, analysis.data, analysis.A, analysis.B, analysis.C, analysis.numSelected, analysis.pointInfo);

end

