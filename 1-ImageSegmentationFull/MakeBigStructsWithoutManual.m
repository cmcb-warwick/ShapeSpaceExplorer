%Put me in your imagestacks folder from CSG
root =matlabroot;
global PATH
if (length(PATH)>2)
root= PATH;
end
folder = uigetdir(root,'Select Experiment Folder');
PATH=folder;
dirData=dir( fullfile(folder,'CellFrameData*.mat') );
dirIndex = [dirData.isdir];  %# Find the index for directories
fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(folder,x),...  %# Prepend path to files
    fileList,'UniformOutput',false);
end
N = length(fileList);
if N<1, error('No Files found in Experiment folder, stopped without processing');
    exit(0); end

BigCellDataStruct=[];
for i=1:N
    load(sprintf('ImageStack%03dCurveData.mat',i))
    num_cells=max(cell2mat(Cell_numbers));
    num_frames=length(Frame_curves);
    for j=1:num_cells
        for k=1:num_frames
            CellArray={};
            if ismember(j,Cell_numbers{k})
                BigCellArray=[BigCellArray Frames_curves{k}(Cell_numbers{k}==j)];
                CellArray=[CellArray Frames_curves{k}(Cell_numbers{k}==j)];
                cell_indices=[cell_indices j+running_cell_indices];
            end
            CellDataStruct=struct('Stack_number',i,'Cell_numbers',k,'Contours',CellArray);
        end
        BigCellDataStruct=[BigCellDataStruct, CellFrameData];
    end
    
end

save -v7.3 BigCellDataStruct.mat BigCellDataStruct

save('Bigcellarrayandindex.mat', 'BigCellArray', 'cell_indices', '-v7.3')