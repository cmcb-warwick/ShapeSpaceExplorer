function  Run_ShapeFeature_Processing()
root =matlabroot;
global PATH
if (length(PATH)>2)
root= PATH;
end
folder = uigetdir(root,'Select Analysis Folder');
PATH=folder; % set it for next time.
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

