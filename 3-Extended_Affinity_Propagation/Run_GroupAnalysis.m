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
    

classes={};
labels={};
groupNames={};
groupStacks={};
for i =1: length(items)
    item = items{i};
    [h, clusters] = plotGroup(BigCellDataStruct, number, wish_list, SCORE, idx, T, item.tracks);
    fPath=fullfile(groupPath, [item.name '_ShapeSpace.fig']);
    ePath = fullfile(groupPath, [item.name '_ShapeSpace.eps']);
    savefig(h,fPath);
    saveas(h, ePath, 'epsc');
    h = plotBars(clusters,number);
    fPath=fullfile(groupPath, [item.name '_barplot.fig']);
    ePath = fullfile(groupPath, [item.name '_barplot.eps']);
    savefig(h,fPath);
    saveas(h, ePath, 'epsc');  
    labels{end+1}=item.name;
    for j =1:length(clusters(:,1))
        if isempty(classes) || isempty(classes{clusters(j,1)})
            classes{clusters(j,1)}=[]; end
        c=classes{clusters(j,1)};
        c(end+1)=clusters(j,2);
        classes{clusters(j,1)}=c;   
    end
    groupNames{end+1}=item.name;
    groupStacks{end+1}=item.tracks;
end
labels{end+1}='all';
plotClusterBars(classes,labels, groupPath)
tableFilename=fullfile(groupPath, 'GroupMapping.csv');
T = table(groupNames', groupStacks');
writetable(T,tableFilename,'Delimiter',',');

end




function plotClusterBars(classes,labels, groupPath)

s = size(classes);
colour=jet(s(2));
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);



for i =1:s(2)
    f=figure(12);
    clf;
    ePath = fullfile(groupPath, ['Cluster_' num2str(i) '_barplot.eps']);
    fPath = fullfile(groupPath, ['Cluster_' num2str(i) '_barplot.eps']);
    array = classes{i};
    array(end+1)=sum(array);
    h=bar(array);
    set(h,'FaceColor',colour(i,:))
    hold on
    set(gca, 'XTick', 1:s(2), 'XTickLabel', labels);
    savefig(f,fPath);
    saveas(f, ePath, 'epsc'); 
end
end


function f = plotBars(clusters,number)
f=figure(11);
clf;

colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
mMax = max(clusters(:,2));
ylim([0, mMax * 1.2]);  %# The 1.2 factor is just an example
for i=1:number
    h=bar(i,clusters(i,2));
    set(h,'FaceColor',colour(clusters(i,1),:))
    hold on
end

set(gca, 'XTick', 1:number, 'XTickLabel', clusters(:,1));
end



function [h, clusters] = plotGroup(BigCellDataStruct, number, wish_list, SCORE, idx,T, stacks)
colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
clusters= zeros(number,2);
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
    plot(SCORE(points,1),SCORE(points,2),'o','Color',colour(clust_idx,:), 'MarkerSize', 5)
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
        clusters(i,1)=clust_idx;
        clusters(i,2)=sum(points);
        plot(SCORE(points,1),SCORE(points,2),'.','Color',colour(clust_idx,:), 'MarkerSize', 14)
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