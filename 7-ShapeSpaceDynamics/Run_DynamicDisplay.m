function   Run_DynamicDisplay( )

 out=guiDynamicDisplay();
 props ={'speeds' 'average_speed' 'angles' 'av_displacement_direction'};
 close all force
 propname =props{out.prop};
 dPath = fullfile(out.path, 'DynamicData.mat');
 % to show it next time we run app.
 global PATH;
 PATH=out.path;
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
  

Dynamics_display(dynamicData, out.path, propname, out.minTrackLenght);
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