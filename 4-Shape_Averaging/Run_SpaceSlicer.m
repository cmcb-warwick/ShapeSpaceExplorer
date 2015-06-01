% to run the shape slice program, click
% on Editor-->Run
function  Run_SpaceSlicer( )
    out=guiShapeSlicer();
    if ~isempty(out.handle), delete(out.handle); end
    cellShapePath = fullfile(out.path, 'CellShapeData_slim.mat');
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

    SpaceSlicer(cellShapeData, out.xSlice,out.ySlice, out.path, out.axesEqual);
    display('Cell Slicer run successfully');
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