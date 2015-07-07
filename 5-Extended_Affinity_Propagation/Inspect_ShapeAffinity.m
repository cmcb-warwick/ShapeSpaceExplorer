function   Inspect_Shapes()
folder = uigetdir(matlabroot,'Select Analysis Folder');
dataFile = fullfile(folder, 'CellShapeData_slim.mat');
if exist(dataFile, 'file')
    display('File is loading ... ');
    data = load(dataFile);
    CellShapeData= data.CellShapeData;
    display('File loaded. ');
    unordered_list(CellShapeData, folder)
else 
    display('-------')
    display('The file "CellShapeData_slim.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')
    
end

end

