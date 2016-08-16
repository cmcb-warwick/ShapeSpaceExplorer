function   run_slimCellShapeData()
root =matlabroot;
global PATH
if (length(PATH)>2)
root= PATH;
end
folder = uigetdir(root,'Select Analysis Folder');
PATH=folder;
dataFile = fullfile(folder, 'CellShapeData.mat');
if exist(dataFile, 'file')
    display('File is loading ... ');
    data = load(dataFile);
    CellShapeData_slim  = slimCellShapeData(data.CellShapeData);
    clear data;
    CellShapeData =CellShapeData_slim;
    save([folder '/CellShapeData_med.mat'], 'CellShapeData', '-v7.3');
    
    CellShapeData_slim  = slimCellShapeData( CellShapeData, 1 );
    clear CellShapeData;
    CellShapeData =CellShapeData_slim;
    save([folder '/CellShapeData_slim.mat'], 'CellShapeData', '-v7.3');
    
else 
    display('-------')
    display('The file "CellShapeData.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end

end

