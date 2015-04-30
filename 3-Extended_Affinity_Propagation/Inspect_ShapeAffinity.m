function   Inspect_Shapes()
folder = uigetdir(matlabroot,'Select Analysis Folder');
dataFile = fullfile(folder, 'CellShapeData.mat');
if exist(dataFile, 'file')
    display('File is loading ... ');
    data = load(dataFile);
    CellShapeData= data.CellShapeData;
    unordered_list(CellShapeData, folder)
else 
    display('-------')
    display('The file "Bigcellarrayandindex.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')
    exit(0);
end

end

