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
    Local_direction_rose_plots(dynamicData, out.path,[out.xSlice out.ySlice], out.minTrackLength);
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