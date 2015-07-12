function  Run_Clustered_Dynamics()
    out=ConstrainedClustering();
    close all force
    folder =out.fpath;
    classes = out.classes;    
cellShapePath = fullfile(folder, 'CellShapeData_slim.mat');
if exist(cellShapePath, 'file')
    display('File is loading ... ');
    try data = load(cellShapePath);
        cellShapeData=data.CellShapeData;
    catch
        fileHasWrongStructure(cellShapePath);
        return;
    end
else
    filleDoesNotexist(cellShapePath);
    return;
end

dynamicPath = fullfile(folder, 'DynamicData.mat');
if exist(dynamicPath, 'file')
    try dData = load(dynamicPath);
        dynamicData=dData.DynamicData;
    catch
        fileHasWrongStructure(dynamicPath);
        return;
    end
else
    filleDoesNotexist(dynamicPath);
    return;
end


dynamicPath = fullfile(folder, 'APclusterOutput.mat');
if ~exist(dynamicPath, 'file')
    filleDoesNotexist(dynamicPath);
    return;
end

dynamicPath = fullfile(folder, 'wish_list.mat');
if ~exist(dynamicPath, 'file')
    filleDoesNotexist(dynamicPath);
    return;
end

dynamicPath = fullfile(folder, 'linkagemat.mat');
if ~exist(dynamicPath, 'file')
    filleDoesNotexist(dynamicPath);
    return;
end



Exemplar_direction_rose_plots(dynamicData, cellShapeData, classes, folder);
display('Clustered Dynamic Data run successfully');
display('-------');
end



function filleDoesNotexist(filename)
    display('-------');
    display(['The file "' filename '" does not exist in your Analysis folder.']);
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');
end

function fileHasWrongStructure(filename)
    display('-------');
    display(['The file "' filename '" does not have the expected structure in your Analysis folder.']);
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');
end