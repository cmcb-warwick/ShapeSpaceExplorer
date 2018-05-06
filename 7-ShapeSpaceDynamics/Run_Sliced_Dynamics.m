% to run the shape slice program, click
% on Editor-->Run
function  Run_Sliced_Dynamics( )
    out=guiDynamicData();
    % set the path for next use
    global PATH;
    PATH=out.path;
    close all force
    dPath = fullfile(out.path, 'DynamicData.mat');
    if exist(dPath, 'file')
        try data = load(dPath);
            dynamicData=data.DynamicData;
        catch
            fileHasWrongStructure(dPath);
            return;
        end
    else
        filleDoesNotexist(dPath);
        return;
    end
    default.data =dynamicData;
    default.path =out.path;
    default.xSlice=out.xSlice;
    default.ySlice=out.ySlice;
    default.minTrackLength=out.minTrackLength;
    group.do=0;
    
    
    
%---------------------------------------------
% get group analysis data together.
%---------------------------------------------
if (out.groups)
    group.do=1;
    grFile =fullfile(out.path, 'groups.mat');
    if ~exist(grFile,'file')
        group.do=0;
        filleDoesNotexistGroup(grFile)
    else 
        dt=load(grFile);
        group.items=dt.groups.groups;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    end
    
    bigMatrixPath = fullfile(out.path, 'Bigcellarrayandindex.mat');
    if exist(bigMatrixPath, 'file')
        try bigMatrixData = load(bigMatrixPath);
            group.cellIdxes=bigMatrixData.cell_indices;
        catch
            fileHasWrongStructure(bigMatrixPath);
        return;
        end
    else
        group.do=0;
        filleDoesNotexistGroup(bigMatrixPath); return;
    end
    
    stPath=fullfile(out.path, 'BigCellDataStruct.mat');
    if exist(stPath, 'file')
        try st = load(stPath);
            group.BigCellDataStruct=st.BigCellDataStruct;
        catch
            group.do=0;
            fileHasWrongStructure(stPath);
        return;
        end
    else
        group.do=0;
        filleDoesNotexistGroup(stPath); return;
    end
    
% Start method
   
end
Dynamics_rose_plots_for_Slices(default, group);
display('Dynamics for sliced cells shape space has run successfully');
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

function filleDoesNotexistGroup(filename)
    display('-------');
    display(['The file "' filename '" does not exist in your Analysis folder.']);
    display('Please check whether previous steps have been succesfully completed.');
    display('Group Analysis will not be performed.');
    display('-------');
end