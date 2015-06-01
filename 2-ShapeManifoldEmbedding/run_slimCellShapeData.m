function   run_slimCellShapeData()

folder = uigetdir(matlabroot,'Select Analysis Folder');
dataFile = fullfile(folder, 'CellShapeData.mat');
if exist(dataFile, 'file')
    display('File is loading ... ');
    data = load(dataFile);
    CellShapeData_slim  = slimCellShapeData( data.CellShapeData );
    clear data;
    CellShapeData =CellShapeData_slim;
    save([folder '/CellShapeData_slim.mat'], 'CellShapeData', '-v7.3');
else 
    display('-------')
    display('The file "CellShapeData.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end

end

