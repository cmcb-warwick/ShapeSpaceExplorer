function  generate_OoSe_distMatrix_new( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
K=3;
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

%%
bPath1 = fullfile(path.OosFolder, 'Bigcellarrayandindex.mat');
bData= load(bPath1);

lPath=fullfile(path.OosFolder, 'LP_trained.mat');
LP_OoSE_run(cData.CellShapeData, bData.BigCellArray, lPath, path.OosFolder)
display('distance matrix sucessfully generated');
%%


bPath = fullfile(path.OosFolder, 'Dist_mat.mat');
DIST= load(bPath);


%lPath=fullfile(path.OosFolder, 'LP_trained.mat');
LP_OoSE_run_new(cData.CellShapeData, DIST, path.OosFolder,K)
display('Oose distance matrix sucessfully generated');

%%%%%%%%%%%%%%%%%%
% oPath = fullfile(path.OosFolder, 'OoSE_embedding.mat');
% OoSEscores= load(oPath);
% 
% iPath = fullfile(path.OosFolder, 'Bigcellarrayandindex.mat');
% OoSEcellarrayandindex= load(iPath);
% 
% sPath = fullfile(path.OosFolder, 'BigCellDataStruct.mat');
% OoSECellDataStruct= load(sPath);
% 
% 
% CreateCDS_OoSE_run_new(OoSEscores, OoSEcellarrayandindex.BigCellArray, OoSECellDataStruct, path.OosFolder)
% display('Oose CDS is sucessfully generated');

%%%%%%%%%%%
RunCreateCellShapeDataforOoSE()
%%%%%%%%%%%

end
