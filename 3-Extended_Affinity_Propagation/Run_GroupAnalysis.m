function   runGroupAnalysis()


inputFolder ='/Users/iasmam/Desktop/Analysis';
number=4;
items={};
str.name = 'Group1';
str.tracks=[1];
str.id=1;
items{1}=str;


s.name = 'Group2';
s.tracks=[2];
s.id=2;
items{2}=s;

t.name = 'Group3';
t.tracks=[3];
t.id=3;
items{3}=t;

%----------------------%
load(fullfile(inputFolder, '/APclusterOutput.mat'));
load(fullfile(inputFolder, '/wish_list.mat'));
load(fullfile(inputFolder, '/linkagemat.mat'));
load(fullfile(inputFolder, '/CellShapeData.mat'));
load(fullfile(inputFolder, '/Bigcellarrayandindex.mat'));
load(fullfile(inputFolder, '/BigCellDataStruct.mat'));

groupPath=fullfile(inputFolder, 'GroupAnalysis');


if ~exist(groupPath,'dir'),mkdir(groupPath);end


N=length(CellShapeData.point);

if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end


for i=1:N
    NewCellArray{i}=CellShapeData.point(i).coords_comp;
end

% check cluster.
figure('visible','off')
[~,T]=dendrogram(linkagemat,number);
if max(T(:))<number
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(2);
    errordlg(msg, 'Error', mode);
    return
end
    



for i =1: length(items)
    item = items{i};
h = plotGroup(BigCellDataStruct, number, wish_list, SCORE, idx, T, item.tracks);
fPath=fullfile(groupPath, [item.name '.fig']);
ePath = fullfile(groupPath, [item.name '.eps']);
savefig(h,fPath);
saveas(h, ePath, 'epsc');
end
end




function h = plotGroup(BigCellDataStruct, number, wish_list, SCORE, idx,T, stacks)
colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);

% prepare T2;
n_exems=length(wish_list);
exem_list=sort(wish_list);  
for i=1:n_exems
T2(i)=T(exem_list==wish_list(i));
end
d=diff([0 T2]);
clust_order=T2(logical(d));


h=figure(10);
clf;
for i=1:number
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    points=ismember(idx,exems);
    plot(SCORE(points,1),SCORE(points,2),'o','Color',colour(i,:), 'MarkerSize', 5)
    hold on
end
axis tight
axis equal
grid on

%now plot the group
    stack_indices=getStackIndices(BigCellDataStruct);
    gIds =getAllIndicesFor(stack_indices, stacks);
    for i=1:number
        clust_idx=clust_order(i);
        exems=wish_list(T2==clust_idx);
        points=ismember(idx.*gIds,exems);
        plot(SCORE(points,1),SCORE(points,2),'.','Color',colour(i,:), 'MarkerSize', 14)
        hold on
    end
% till here we plot all shapes. no group hightlighted.

end


function indices =getAllIndicesFor(stack_indices, stacks)
indices =zeros(size(stack_indices));
    for i=1:length(stacks)
        idx=find(stack_indices==stacks(i));
        indices(idx)=1;
    end
end




function stack_indices=getStackIndices(BigCellDataStruct)
idx=1;
stack_indices=[];
s=size(BigCellDataStruct);
for i =1:s(2)
    item = BigCellDataStruct(i);
    shapes = size(item.Contours);
    stack_indices(idx:idx+shapes(2)-1)=item.Stack_number;
    idx=idx+shapes(2);
end
stack_indices=stack_indices';
end