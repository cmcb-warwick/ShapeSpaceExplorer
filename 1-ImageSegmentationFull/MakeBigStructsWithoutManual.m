%Put me in your imagestacks folder from CSG
root =matlabroot;
global PATH
if (length(PATH)>2)
root= PATH;
end
folder = uigetdir(root,'Select Analysis Folder');
PATH=folder;
dirData=dir( fullfile(folder,'ImageStack*CurveData.mat') );
dirIndex = [dirData.isdir];  %# Find the index for directories
fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(folder,x),...  %# Prepend path to files
    fileList,'UniformOutput',false);
end
N = length(fileList);
if N<1, error('No Files found in Analysis folder, stopped without processing');
    exit(0); end
    
BigCellDataStruct=[];
BigCellArray=[];
cell_indices=[];
for i=1:N
    load(fullfile(folder,sprintf('ImageStack%03dCurveData.mat',i)))
    num_cells=max(cell2mat(Cell_numbers));
    num_frames=length(Frame_curves);
    for j=1:num_cells
        CellArray=[];
        for k=1:num_frames
            if ismember(j,Cell_numbers{k})
                BigCellArray=[BigCellArray; Frame_curves{k}(Cell_numbers{k}==j)];
                CellArray=[CellArray Frame_curves{k}(Cell_numbers{k}==j)];
                cell_indices=[cell_indices; j];
            end
            CellDataStruct=struct('Stack_number',i,'Cell_number',j,'Contours',{CellArray}, 'BadFrames', []);
        end
    BigCellDataStruct=[BigCellDataStruct, CellDataStruct];
    end
    

end

sFile = fullfile(folder, 'BigCellDataStruct.mat');
save( sFile, 'BigCellDataStruct', '-v7.3');

sFile = fullfile(folder, 'Bigcellarrayandindex.mat');
save(sFile, 'BigCellArray', 'cell_indices', '-v7.3');