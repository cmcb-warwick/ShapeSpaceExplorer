function  RunShapeManifoldEmbedding()
folder = uigetdir(matlabroot,'Select Experiment Folder');
dataFile = fullfile(folder, 'Bigcellarrayandindex');
data = load(dataFile);
ShapeManifoldEmbedding_finalSJ(data.BigCellArray, folder);

end

