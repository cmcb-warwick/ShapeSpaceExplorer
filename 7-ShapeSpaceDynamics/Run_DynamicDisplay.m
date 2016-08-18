function   Run_DynamicDisplay( )

 out=guiDynamicDisplay();
 props ={'speeds' 'average_speed' 'angles' 'av_displacement_direction'};
 close all force
 default.propname =props{out.prop};
 default.minTrackLength=out.minTrackLenght;
 dPath = fullfile(out.path, 'DynamicData.mat');
 % to show it next time we run app.
 global PATH;
 PATH=out.path;
 
 default.path=out.path;
    if exist(dPath, 'file')
        try data = load(dPath);
            default.DynamicData=data.DynamicData;
        catch
            fileHasWrongStructure(dPath);
            return;
        end
    else
        filleDoesNotexist(dPath);
        return;
    end
    
    group.do=0;
%---------------------------------------------
% get group analysis data together.
%---------------------------------------------
if (group.do)
    group.do=1;
    grFile =fullfile(out.path, 'groups.mat');
    if ~exist(grFile,'file')
        group.do=0;
        filleDoesNotexistGroup(grFile)
    else 
        dt=load(grFile);
        group.items=dt.groups;
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
end

Dynamics_display(default, group );
end



% Helper functions
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