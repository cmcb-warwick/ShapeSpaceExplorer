function  RunShapeManifoldEmbedding()
folder = uigetdir(matlabroot,'Select Analysis Folder');
dataFile = fullfile(folder, 'Bigcellarrayandindex.mat');
if exist(dataFile, 'file')
    data = load(dataFile);
    ShapeManifoldEmbedding_finalSJ(data.BigCellArray, folder);
else 
    display('-------')
    display('The file "Bigcellarrayandindex.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end
end

