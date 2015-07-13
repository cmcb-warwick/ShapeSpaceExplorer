% to run the shape slice program, click
% on Editor-->Run
function  Run_SpaceSlicer( )
    out=guiShapeSlicer();
    group.do=false;
    cluster.do=false;
    try if out==-1,return; end 
       end
    try if strcmp(out.pathAna,'...'), 
            filleDoesNotexist('...');
            return; end
    end  
    
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
    
    default.csd=cellShapeData;
    default.xSlices=out.xSlice;
    default.ySlices=out.ySlice;
    default.path=out.pathAna;
    default.axesEqual=out.axesEqual;
    
     if out.Group
    gfile = fullfile(out.pathAna, 'groups.mat');
    group.do=true;
    group.path=gfile;
       if ~exist(gfile, 'file')
           filleDoesNotexist(gfile);
           group.do=false;
       end
     end
    
     
     if out.AP %
         cluster.do=true;
         cluster.number=out.classes;
         % load first file
         path= fullfile(out.pathAna, 'wish_list.mat');   
         if ~exist(path, 'file')
           filleDoesNotexist(path);
           apMissing();
           cluster.do=false;
         else
             try data =load(path);
                 cluster.wish_list=data.wish_list;
             catch
                fileHasWrongStructure(cellShapePath);
                cluster.do=false;
            end   
         end
         % load second file
         path= fullfile(out.pathAna, 'linkagemat.mat');   %APclusterOutput.mat
         if ~exist(path, 'file')
           filleDoesNotexist(path);
           apMissing();
           cluster.do=false;
         else
             try data =load(path);
                 cluster.linkagemat=data.linkagemat;
             catch
                fileHasWrongStructure(cellShapePath);
                cluster.do=false;
            end   
         end
         
         % load second file
         path= fullfile(out.pathAna, 'APclusterOutput.mat');   %APclusterOutput.mat
         if ~exist(path, 'file')
           filleDoesNotexist(path);
           apMissing();
           cluster.do=false;
         else
             try data =load(path);
                 cluster.idx=data.idx;
             catch
                fileHasWrongStructure(cellShapePath);
                cluster.do=false;
            end   
         end
     end
         
    SpaceSlicer(default, group, cluster);
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


function apMissing()
    display('Affinity propagation step files seem to be missing.')    
end