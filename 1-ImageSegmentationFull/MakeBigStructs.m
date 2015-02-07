%Put me in your contour output folder from CSG

folder = uigetdir(matlabroot,'Select Experiment Folder');
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
    load(char(fileList(i)));
    if ~isempty(fieldnames(CellFrameData))
        BigCellDataStruct=[BigCellDataStruct, CellFrameData];
    end
clear('CellFrameData')
end

sFile = fullfile(folder, 'BigCellDataStruct.mat');
save( sFile, 'BigCellDataStruct', '-v7.3');



L=length(BigCellDataStruct);
BigCellArray=BigCellDataStruct(1).Contours';
cell_indices=ones(length(BigCellDataStruct(1).Contours),1);
for i=2:L
    BigCellArray=[BigCellArray; BigCellDataStruct(i).Contours'];
    cell_indices=[cell_indices; i*ones(length(BigCellDataStruct(i).Contours),1)];
end

sFile = fullfile(folder, 'Bigcellarrayandindex.mat');
save(sFile, 'BigCellArray', 'cell_indices', '-v7.3');

display('Program finished as expected')