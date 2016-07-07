function [collcodes, XRDDatabase] = readXRDDatabase(folder)
%READXRDDATABASE reads in all the ICSD database files (translated to .txt
%files using VESTA) from the given folder

% navigate to folder
fileEnding = '*.txt';
codeDir = pwd;
cd(folder);
fileNames = dir(fileEnding);
cd(codeDir);

collcodes = zeros(1, length(fileNames));
XRDDatabase = zeros(100, length(fileNames) * 2);

for k = 1:length(fileNames)
    
    % obtain file collcode
    nameComponents = strsplit(fileNames(k).name, '.');
    filenameEdit = nameComponents(1);
    filenameEdit = filenameEdit{1};
    newString = filenameEdit(18:end);
    collcodes(k) = str2double(newString);
    
    imported = importXRDDatabaseFile(strcat(folder, '/', fileNames(k).name));
    
    % copy data
    angle = imported(:, 1);
    intensity = imported(:, 2);
    XRDDatabase(1:length(angle), 2 * k - 1) = angle;
    XRDDatabase(1:length(intensity), 2 * k) = intensity;
end

end

