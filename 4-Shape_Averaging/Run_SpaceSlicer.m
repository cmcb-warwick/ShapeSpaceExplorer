% to run the shape slice program, click
% on Editor-->Run
function  Run_SpaceSlicer( )
    out=guiShapeSlicer();
    try if out==-1,return; end 
       end
    try if strcmp(out.pathAna,'...'), 
            filleDoesNotexist('...');
            return; end
    end
    
    gfile =''; % when group do this.
    if out.Group
    gfile = fullfile(out.pathAna, 'groups.mat');
       if ~exist(gfile, 'file')
           filleDoesNotexist(gfile);
           return;
       end
    end
    
    %when AP lodas those dataﬂ
   
    cellShapePath = fullfile(out.pathAna, 'CellShapeData_med.mat');
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
    
    SpaceSlicer(cellShapeData, out.xSlice,out.ySlice, out.pathAna, out.axesEqual, gfile, out.AP);
    close all force
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