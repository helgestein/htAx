function [] = beginAnalysis(XRDFolder, EDXFile, saveFile, ...
    ECFolder, XRDDatabaseFolder)
%BEGINANALYSIS takes in the name of a folder that contains XRD data, the
%name of a file with EDX data, and the name of a file to which the analysis
%can be saved and begins a new analysis session with the data
%   example call:
%   beginAnalysis('/Users/sjiao/Documents/summer_2016/data/CoFeMnO-mapcorr',
%   '/Users/sjiao/Documents/summer_2016/data/MnFeCoO-EDX',
%   '/Users/sjiao/Documents/summer_2016/code/testFiles/testSave.txt')

% import and read XRD and EDX data
[xCoord, yCoord, XRDData] = readXRDData(XRDFolder);
[A, B, C] = ...
    importEDXFile(EDXFile);

% convert EDX data to percents
A = A ./ 100;
B = B ./ 100;
C = C ./ 100;

% FOR TEST FILE ONLY remove first five rows of EDX data
%{
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
%}

% read in EC data
if ECFolder ~= 1
    ECData = readECData(ECFolder, xCoord, yCoord);
else
    ECData = 1;
end

if XRDDatabaseFolder ~= 1
    [collcodes, XRDDatabase] = readXRDDatabase(XRDDatabaseFolder);
else
    collcodes = 1;
    XRDDatabase = 1;
end

pointInfo = zeros(1, 11);
numSelected = 0;
ECPlotInfo = zeros(342, 4);

openFigs(saveFile, XRDData, A, B, C, numSelected, pointInfo, ECData, ...
    ECPlotInfo, collcodes, XRDDatabase);

end

