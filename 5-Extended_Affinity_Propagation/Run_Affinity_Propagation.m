function  Run_Affinity_Propagation( )
root =matlabroot;
global PATH
if length(PATH>2)
root= PATH;
end
folder = uigetdir(root,'Select Analysis Folder');
PATH=root;
dataFile = fullfile(folder, 'CellShapeData_slim.mat');
if exist(dataFile, 'file')
    display('File is loading ... ');
    data = load(dataFile);
    AP_Seriation_analysis_finaledit(data.CellShapeData.set.Long_D, 1, folder)
else 
    display('-------')
    display('The file "CellShapeData_slim.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')
end

end

