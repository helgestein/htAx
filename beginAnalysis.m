function [] = beginAnalysis(XRDFolder, EDXFile, saveFile, ...
    ECFolder1, ECFolder2, ECFolder3)
%BEGINANALYSIS takes in the name of a folder that contains XRD data, the
%name of a file with EDX data, and the name of a file to which the analysis
%can be saved and begins a new analysis session with the data
%   example call:
%   beginAnalysis('/Users/sjiao/Documents/summer_2016/data/CoFeMnO-mapcorr',
%   '/Users/sjiao/Documents/summer_2016/data/MnFeCoO-EDX',
%   '/Users/sjiao/Documents/summer_2016/code/testFiles/testSave.txt')

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
ATemp = zeros(lengthNew, 1);
BTemp = zeros(lengthNew, 1);
CTemp = zeros(lengthNew, 1);
for i = (rowsToRemove + 1):length(A)
    ATemp(i - rowsToRemove) = A(i);
    BTemp(i - rowsToRemove) = B(i);
    CTemp(i - rowsToRemove) = C(i);
end    
A = ATemp;
B = BTemp;
C = CTemp;

% read in EC data

ECData = readECData(ECFolder1, ECFolder2, ECFolder3, xCoord, yCoord);

pointInfo = zeros(1, 11);
numSelected = 0;

openTernFigs(saveFile, data, A, B, C, numSelected, pointInfo, ECData);

end

