function  generate_OoSe_distMatrix_new( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
K=5; %Nearest neighbers using K=5
LP=0; %Don't use LPs
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

BAM_for_OoSE(cData.CellShapeData, bData.BigCellArray, path.OosFolder)
display('BAM values calculated');

if LP
lPath=fullfile(path.OosFolder, 'LP_trained.mat');
LP_OoSE_run(cData.CellShapeData, bData.BigCellArray, lpath, path.OosFolder)
else
%%

bPath = fullfile(path.OosFolder, 'Dist_mat.mat');
DIST= load(bPath);


%lPath=fullfile(path.OosFolder, 'LP_trained.mat');
nn_OoSE_run(cData.CellShapeData, DIST, path.OosFolder,K)
display('Oose distance matrix sucessfully generated');
end

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
RunCreateCellShapeDataforOoSE(path.OosFolder)
%%%%%%%%%%%

end
