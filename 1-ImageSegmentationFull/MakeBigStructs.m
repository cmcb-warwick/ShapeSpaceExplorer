%Put me in your contour output folder from CSG

N=1; %Number of stacks

load('CellFrameData001.mat')
BigCellDataStruct=CellFrameData;
for i=2:N
    load(sprintf('CellFrameData%03d',i))
    if ~isempty(fieldnames(CellFrameData))
        BigCellDataStruct=[BigCellDataStruct, CellFrameData];
    else
    i
    end
clear('CellFrameData')
end

save -v7.3 BigCellDataStruct.mat BigCellDataStruct

L=length(BigCellDataStruct);
BigCellArray=BigCellDataStruct(1).Contours';
cell_indices=ones(length(BigCellDataStruct(1).Contours),1);
for i=2:L
    BigCellArray=[BigCellArray; BigCellDataStruct(i).Contours'];
    cell_indices=[cell_indices; i*ones(length(BigCellDataStruct(i).Contours),1)];
end

save('Bigcellarrayandindex.mat', 'BigCellArray', 'cell_indices', '-v7.3')