function  Run_DynamicData_Generation( )
folder = uigetdir(matlabroot,'Select Analysis Folder');
if folder==0, return; end
cellShapePath = fullfile(folder, 'CellShapeData.mat');
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


bigMatrixPath = fullfile(folder, 'Bigcellarrayandindex.mat');
if exist(bigMatrixPath, 'file')
    try bigMatrixData = load(bigMatrixPath);
        cellIndices=bigMatrixData.cell_indices;
    catch
        fileHasWrongStructure(bigMatrixPath);
        return;
    end
else
    filleDoesNotexist(bigMatrixPath); return;
end
ShapeSpaceDynamics(cellIndices, cellShapeData, folder);
display('Dynamic Data successufully generated');
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