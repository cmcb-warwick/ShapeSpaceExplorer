function  Run_constrained_Clustering()
    out=ConstrainedClustering();
    folder =out.fpath;
    global PATH;
    PATH =out.fpath;
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
ordered_list(classes, cellShapeData, folder, folder);
display('Constrained Clustering run successfully');
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