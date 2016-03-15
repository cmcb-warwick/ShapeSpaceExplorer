function  generate_OoSe_distMatrix( )
%UNTITLED2 Summary of this function goes here
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


cPath=fullfile(path.anaFolder, 'CellShapeData.mat');
cData= load(cPath);

bPath = fullfile(path.OosFolder, 'Bigcellarrayandindex.mat');
bData= load(bPath);

lPath=fullfile(path.OosFolder, 'LP_trained.mat');
LP_OoSE_run(cData.CellShapeData, bData.BigCellArray, lPath, path.OosFolder)
display('Oose distance matrix sucessfully generated');
end

