function  Run_Affinity_Propagation( )
folder = uigetdir(matlabroot,'Select Analysis Folder');
dataFile = fullfile(folder, 'CellShapeData.mat');
if exist(dataFile, 'file')
    data = load(dataFile);
    AP_Seriation_analysis_finaledit(data.CellShapeData.set.Long_D, 1, folder)
else 
    display('-------')
    display('The file "CellShapeData.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end

end

