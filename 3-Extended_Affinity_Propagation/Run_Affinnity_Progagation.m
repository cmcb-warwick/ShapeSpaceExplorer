function  Run_Affinnity_Progagation( )
folder = uigetdir(matlabroot,'Select Experiment Folder');
dataFile = fullfile(folder, 'CellShapeData.mat');
if exist(dataFile, 'file')
    data = load(dataFile);
    AP_Seriation_analysis_finaledit(data.CellShapeData.set.Long_D, 1, folder)
else 
    display('-------')
    display('The file "Bigcellarrayandindex.mat" does not exist in your Experiment folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end

end

