function createBargraphs()

path=OoseConfig3();
try if isempty(path.anaFolder) || isempty(path.OosFolder)||...
    strcmp(path.anaFolder,path.OosFolder)==1 ||...
    ~exist(path.anaFolder, 'dir') || ~exist(path.OosFolder, 'dir')
    return;
    end
catch
    return;
end

cPath=fullfile(path.anaFolder, 'CellShapeData.mat');
display('File is loading ... ');
cData= load(cPath);
classes= path.classes;
aData1=load(fullfile(path.anaFolder, 'wish_list.mat'));
oData1=load(fullfile(path.OosFolder, 'Dist_mat.mat'));
oData2=load(fullfile(path.OosFolder, 'OoSE_embedding.mat'));
OoSE_bargraphs(classes,cData.CellShapeData,path.anaFolder,path.OosFolder, aData1.wish_list, oData1.D, oData2.OoSE_emb);
display('OoSE Bargraphs generated successfully');
end