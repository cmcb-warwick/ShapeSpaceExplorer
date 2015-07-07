function  generateShapeFeature(  )
out=ShapeFeatures();
if ~isfield(out,'props')  
        display('canceled');return; end 
folder = out.anaFolder;
props = out.props;
s= size(props);

dataFile = fullfile(folder, 'CellShapeData_slim.mat');
if exist(dataFile, 'file')
    display('File is loading...')
    data = load(dataFile);
else 
    display('-------');
    display('The file "CellShapeData_slim.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');
    return;
end

dataFile = fullfile(folder, 'Morphframe.mat');

if exist(dataFile, 'file')
    mData = load(dataFile);
    display('Figure creation...')
    h=waitbar(0, ['Creating Figure ' num2str(0) +'/' num2str(s(2)) ]);
    for i=1:s(2)
        waitbar(i/s(2), h, ['Creating Figure ' num2str(i) +'/' num2str(s(2)) ]);
        prop = props{i};
        Prop_display( data.CellShapeData,mData.morphframe, prop, folder);
    end
    close(h)
    display('Shape Feature Processing finished successfully');
    display('-------');
else 
    display('-------');
    display('The file "Morphframe.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');
end


    
end

