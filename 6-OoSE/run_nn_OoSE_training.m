function   gen_nn_OoSE_training(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
path=OoseConfig();
try if isempty(path.anaFolder) || isempty(path.OosFolder)||...
    strcmp(path.anaFolder,path.OosFolder)==1 ||...
    ~exist(path.anaFolder, 'dir') || ~exist(path.OosFolder, 'dir')
    return;
    end
catch
    return;
end
% now path does exist.
cellShapePath=fullfile(path.anaFolder, 'CellShapeData.mat');
display('File is loading ... ');
data= load(cellShapePath);
LP_OoSE_train(data.CellShapeData, path.OosFolder);
display('Oose training completed sucessfully');
end
