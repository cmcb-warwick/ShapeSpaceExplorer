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
OoSE_bargraphs(classes,cData.CellShapeData,path.anaFolder,path.OosFolder );
display('OoSE Bargraphs generated successfully');
end