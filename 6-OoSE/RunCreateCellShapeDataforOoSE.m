function RunCreateCellShapeDataforOoSE(folder)


%out=SelectFolder();
dataFile = fullfile(folder, 'Bigcellarrayandindex.mat');

oPath = fullfile(folder, 'OoSE_embedding.mat');
OoSEscores= load(oPath);

global PATH;
PATH=folder;
if exist(dataFile, 'file')
    data = load(dataFile);
    CreatcellShapeDataForOoSE(OoSEscores, data.BigCellArray, folder, 0);
else 
    display('-------')
    display('The file "Bigcellarrayandindex.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end
end
