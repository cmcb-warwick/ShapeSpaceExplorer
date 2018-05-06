function RunCreateCellShapeDataforOoSE()


out=SelectFolder();
dataFile = fullfile(out.folder, 'Bigcellarrayandindex.mat');

oPath = fullfile(out.folder, 'OoSE_embedding.mat');
OoSEscores= load(oPath);

global PATH;
PATH=out.folder;
if exist(dataFile, 'file')
    data = load(dataFile);
    CreatcellShapeDataForOoSE(OoSEscores, data.BigCellArray, out.folder, out.sparse);
else 
    display('-------')
    display('The file "Bigcellarrayandindex.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end
end
