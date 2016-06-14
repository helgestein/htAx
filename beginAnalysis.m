function [ output_args ] = beginAnalysis(XRDFolder, EDXFile, saveFile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% import and read XRD and EDX data
[xCoord, yCoord, data] = readXRDData(XRDFolder);
[A, B, C] = ...
    importEDXFile(EDXFile);

% convert EDX data to percents
A = A ./ 100;
B = B ./ 100;
C = C ./ 100;

% FOR TEST FILE ONLY remove first five rows of EDX data
rowsToRemove = 5;
lengthNew = length(A) - rowsToRemove;
ATemp = zeros(lengthNew);
BTemp = zeros(lengthNew);
CTemp = zeros(lengthNew);
for i = (rowsToRemove + 1):length(A)
    ATemp(i - rowsToRemove) = A(i);
    BTemp(i - rowsToRemove) = B(i);
    CTemp(i - rowsToRemove) = C(i);
end    
A = ATemp;
B = BTemp;
C = CTemp;

pointInfo = zeros(1, 11);
numSelected = 0;

openTernFigs(saveFile, data, A, B, C, numSelected, pointInfo);

end

