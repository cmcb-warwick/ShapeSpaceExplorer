function  Run_Dendogram_of_Shapes( )
folder = uigetdir(matlabroot,'Select Experiment Folder');
dataFile = fullfile(folder, 'CellShapeData.mat');
if exist(dataFile, 'file')
    data = load(dataFile);
    ordered_list(0,data.CellShapeData, folder, folder);
else 
    display('-------')
    display('The file "CellShapeData.mat" does not exist in your Experiment folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end

end


