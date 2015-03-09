function  generateShapeFeature(  )
out=ShapeFeatures();
folder = out.anaFolder;
prop = out.Prop;

dataFile = fullfile(folder, 'CellShapeData.mat');
if exist(dataFile, 'file')
    data = load(dataFile);
else 
    display('-------');
    display('The file "CellShapeData.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');
    return;
end

dataFile = fullfile(folder, 'Morphframe.mat');
if exist(dataFile, 'file')
    mData = load(dataFile);
    Prop_display( data.CellShapeData,mData.morphframe, prop, folder);
    display('Shape Feature Processing finished successfully');
    display('-------');
else 
    display('-------');
    display('The file "Morphframe.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');
end


    
end

