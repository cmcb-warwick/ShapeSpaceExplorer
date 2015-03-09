function  Run_ShapeFeature_Processing()
folder = uigetdir(matlabroot,'Select Analysis Folder');
dataFile = fullfile(folder, 'Bigcellarrayandindex.mat');
if exist(dataFile, 'file')
    data = load(dataFile);
    Morph_Props(data.BigCellArray, folder);
    display('Shape Feature Processing finished successfully');
    display('-------');
else 
    display('-------');
    display('The file "Bigcellarrayandindex.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');

end
end

