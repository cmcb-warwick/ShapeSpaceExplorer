function  Run_Dendogram_of_Shapes( )
root =matlabroot;
global PATH
if (length(PATH)>2)
root= PATH;
end
folder = uigetdir(root,'Select Analysis Folder');
PATH=folder; % set it for next time.

dataFile = fullfile(folder, 'CellShapeData_slim.mat');
if exist(dataFile, 'file')
     display('File is loading ... ');
    data = load(dataFile);
    display('File loading complete. ');
    ordered_list(0,data.CellShapeData, folder, folder);
else 
    display('-------')
    display('The file "CellShapeData_slim.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end

end


