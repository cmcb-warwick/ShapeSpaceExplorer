function Run_GroupSetup()

out=SelectFolder();
maxStackNo = getMaxStackNumber(out.folder);
global PATH;
PATH=out.folder;
if maxStackNo <0, exit(0); end
items =GroupMaking(maxStackNo);
try if items==-1, 
    display('Groups could not be saved correctly');
    end 
end

%save group config in matlab file format
groups=items;
save(fullfile(out.folder, 'groups.mat'), 'groups','-v7.3');
clear groups;
close all;
display('Groups.mat was created successfully');


end




function counter = getMaxStackNumber(folder)
counter=-1;
file = fullfile(folder,'BigCellDataStruct.mat');
if ~exist(file, 'file')
    display(['The file "BigCellDataStruct" is not present in your Analysis folder\n' ...
             'Please check whether you followed all steps as described in the tutorial.'] );
    return
end
data = load(file);
s = size(data.BigCellDataStruct);
for i = 1:s(2)
    tmp = data.BigCellDataStruct(i);
    if tmp.Stack_number>counter
        counter=tmp.Stack_number;
    end
end
end


%hack for dml so that it works for Matlab2012.
function writeGroups2Table(path,groupnames,groupstacks)
header='GroupNames,MovieStacks'; 
dlmwrite(path,header,'delimiter','');
s=size(groupnames);
for i=1:s(2)
    txt = [groupnames{i} ',' groupstacks(i)];
    dlmwrite(path,txt,'delimiter','', '-append');
end

end
