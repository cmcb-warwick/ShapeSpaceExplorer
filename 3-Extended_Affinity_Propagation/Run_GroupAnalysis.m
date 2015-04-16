function   runGroupAnalysis()


config1=ConstrainedClustering();
if strcmp(config1.fpath, '...')==1, return; end
inputFolder =  config1.fpath;
number=config1.classes;

maxStackNo = getMaxStackNumber(inputFolder);
items =GroupMaking(maxStackNo);




%----------------------%
load(fullfile(inputFolder, '/APclusterOutput.mat'));
load(fullfile(inputFolder, '/wish_list.mat'));
load(fullfile(inputFolder, '/linkagemat.mat'));
load(fullfile(inputFolder, '/CellShapeData.mat'));
load(fullfile(inputFolder, '/Bigcellarrayandindex.mat'));
load(fullfile(inputFolder, '/BigCellDataStruct.mat'));

formatOut = 'yyyy-mm-dd_HHMMSS';
fname = ['GroupAnalysis_' datestr(now,formatOut)];
groupPath=fullfile(inputFolder, fname);
if ~exist(groupPath,'dir'),mkdir(groupPath);end





N=length(CellShapeData.point);
if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
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

% write avg speed per cluster to file.
writeAverageSpeed2File(items,BigCellDataStruct,cell_indices,SCORE,groupPath);


writePersitanceEucledianPerGroup(items,BigCellDataStruct,cell_indices,SCORE,groupPath);

writeSpatialAutorrelationPerGroup(items,BigCellDataStruct,cell_indices,SCORE,groupPath);
    

classes={};
labels={};
groupNames={};
groupStacks={};
for i =1: length(items)
    item = items{i};
    [h, clusters, mClusters] = plotGroup(BigCellDataStruct, number, wish_list, SCORE, idx, T, item.tracks);   
    fPath=fullfile(groupPath, [char(item.name) '_ShapeSpace.fig']);
    ePath = fullfile(groupPath, [char(item.name) '_ShapeSpace.eps']);
    savefig(h,fPath);
    saveas(h, ePath, 'epsc');
    h = plotBars(clusters,number, mClusters);
    fPath=fullfile(groupPath, [char(item.name) '_barplot.fig']);
    ePath = fullfile(groupPath, [char(item.name) '_barplot.eps']);
    savefig(h,fPath);
    saveas(h, ePath, 'epsc');  
    labels{end+1}=char(item.name);
    s=size(clusters);
    for j =1:s(1)
        if isempty(classes) || isempty(classes{clusters(j,1)})
            classes{s(1)}=[]; end
        c=classes{clusters(j,1)};
        c(end+1)=clusters(j,2);
        classes{clusters(j,1)}=c;   
    end
    groupNames{end+1}=char(item.name);
    groupStacks{end+1}=getCharOf(item.tracks);
end
labels{end+1}='all';
plotClusterBars(classes,labels, groupPath)
tableFilename=fullfile(groupPath, 'GroupMapping.csv');
T = table(groupNames', groupStacks');
T.Properties.VariableNames={'GroupNames', 'MovieStacks'};
writetable(T,tableFilename,'Delimiter',',');

close all

end




function plotClusterBars(classes,labels, groupPath)

s = size(classes);
colour=jet(s(2));
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);



for i =1:s(2)
    f=figure(12);
    clf;
    ePath = fullfile(groupPath, ['Cluster_' num2str(i) '_barplot_count.eps']);
    fPath = fullfile(groupPath, ['Cluster_' num2str(i) '_barplot_count.eps']);
    array = classes{i};
    array(end+1)=sum(array);
    h=bar(array);
    set(h,'FaceColor',colour(i,:))
    hold on
    set(gca, 'XTick', 1:s(2), 'XTickLabel', labels);
    savefig(f,fPath);
    saveas(f, ePath, 'epsc'); 
    
    % percentual
    
    clf;
    ePath = fullfile(groupPath, ['Cluster_' num2str(i) '_barplot_percent.eps']);
    fPath = fullfile(groupPath, ['Cluster_' num2str(i) '_barplot_percent.eps']);
    array=array/array(end);
    h=bar(array);
    set(h,'FaceColor',colour(i,:))
    hold on
    set(gca, 'XTick', 1:s(2), 'XTickLabel', labels);
    savefig(f,fPath);
    saveas(f, ePath, 'epsc'); 
    
end
end


function f = plotBars(clusters,number, mClusters)
f=figure(11);
clf;

colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
mMax = max(clusters(:,2));
ylim([0, mMax * 1.2]);  %# The 1.2 factor is just an example
for i=1:number
    barNum=1/mClusters(i,2)*clusters(i,2);
    h=bar(i,barNum);
    set(h,'FaceColor',colour(clusters(i,1),:))
    hold on
end

set(gca, 'XTick', 1:number, 'XTickLabel', clusters(:,1));
end



function [h, clusters, mClusters] = plotGroup(BigCellDataStruct, number, wish_list, SCORE, idx,T, stacks)
colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
clusters= zeros(number,2);
mClusters= zeros(number,2);
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
    mClusters(i,1)=clust_idx;
    mClusters(i,2)=sum(points);
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

function counter = getMaxStackNumber(folder)
t=dir([folder '/ImageStack*.mat']);
counter=0;
s=size(t);
for i=1:s(1)
   idx= strfind(t(i).name, 'CurveData');
   if isempty(idx), counter=counter+1; end
end
end


function d = getDistancesForId(fId, cell_indices, SCORE)
idxes=find(cell_indices==fId);
d=[];
x=SCORE(idxes,1);
y=SCORE(idxes,2);
if length(x)<2, return; end
d = ones(length(x)-1, 1);
for i=2:length(x)
    d(i-1)=pdist2([x(i-1) x(i)], [y(i-1), y(i)]);
end
end


function d = getAllDistancesForId(fId, cell_indices, SCORE)
distances= getDistancesForId(fId, cell_indices, SCORE);
idxes=find(cell_indices==fId);
x=SCORE(idxes,1);
y=SCORE(idxes,2);
d ={};
if length(x)<2, return; end
d {length(distances)}=[];
for i=1:length(x)-1
    for j=i+1:length(x)
        d1=pdist2([x(i) x(j)], [y(i), y(j)]);  %direct distance
        ac=distances(i:j-1); % accumulated as cell walked in space.
        d{j-i}(end+1)=d1/sum(ac); % ratio
    end
end
end


function allDist=getDistancesForGroup(stacks, BigCellDataStruct, cell_indices, SCORE)


allDist=[];
stack_indices=getStackIndices(BigCellDataStruct);
gIds =getAllIndicesFor(stack_indices, stacks);
cIds = sort(unique(cell_indices.*gIds));
cIds = cIds(2:end);
for i=1:length(cIds)
fId = cIds(i);
d = getDistancesForId(fId, cell_indices, SCORE);
allDist(end+1:end+length(d))=d;
end

end


function c =getCharOf(items)
c='';
for i=1:length(items)
    if i==1, c = [num2str(items(i))]; 
    else 
    c = [c ';' num2str(items(i))];
    end
end
end


function writeAverageSpeed2File(items,BigCellDataStruct,cell_indices,SCORE,groupPath)
s=size(items);
groups={};
avgSpeed=[];
speedStd=[];
speedStE=[];
allSpeed=[];
for i=1:s(2)
    item =items{i};
    d=getDistancesForGroup(item.tracks, BigCellDataStruct, cell_indices, SCORE);
    groups{end+1}=char(item.name);
    avgSpeed(end+1)=sum(d)/length(d);
    allSpeed(end+1:end+length(d))=d;
    speedStd(end+1)=std(d);
    speedStE(end+1)=std(d)/sqrt(length(d));
end
groups{end+1}='All';
avgSpeed(end+1)=sum(allSpeed)/length(allSpeed);
speedStd(end+1)=std(allSpeed);
speedStE(end+1)=std(allSpeed)/sqrt(length(allSpeed));
tableFilename=fullfile(groupPath, 'AvgSpeedPerGroup.csv');
T = table(groups', avgSpeed', speedStd', speedStE');
T.Properties.VariableNames={'Groups', 'AvgSpeed', 'Std', 'StandErr'};
writetable(T,tableFilename,'Delimiter',',');
end


function writePersitanceEucledianPerGroup(items,BigCellDataStruct,cell_indices,SCORE,groupPath)
s=size(items);
for i=1:s(2)
    item =items{i};
    pers=getDistancesEucRatioForGroup(item.tracks, BigCellDataStruct, cell_indices, SCORE);
    s=size(pers);
    pM=ones(s(2),1);
    pSt=ones(s(2),1);
    for j=1:s(2)
        tmp = pers{j};
        pM(j)=mean(tmp);
        pSt(j)=std(tmp);
    end
    figure(21);
    clf;
    x = 1:s(2);
    
    errorbar(x,pM,pSt, 'Color', [156/255,187/255,229/255]);
    hold on
    plot(x,pM, 'Color', [237/255 94/255 48/255], 'LineWidth', 1.5);
    
    ePath = fullfile(groupPath, [char(item.name) '_Persitence_EucledianRatio.eps']);
    fPath = fullfile(groupPath, [char(item.name) '_Persitence_EucledianRatio.fig']);
    savefig(gcf,fPath);
    saveas(gcf, ePath, 'epsc'); 
end 


end


function allDist=getDistancesEucRatioForGroup(stacks, BigCellDataStruct, cell_indices, SCORE)


allDist={};
stack_indices=getStackIndices(BigCellDataStruct);
gIds =getAllIndicesFor(stack_indices, stacks);
cIds = sort(unique(cell_indices.*gIds));
cIds = cIds(2:end);
for i=1:length(cIds)
    fId = cIds(i);
    d=getAllDistancesForId(fId, cell_indices, SCORE);
    s1=size(d);
    s2=size(allDist);
    if s2(2)<s1(2), 
        allDist=resize(allDist, s1(2)); end
    for j=1:s1(2)
        tmp=d{j};
        allDist{j}(end+1:end+length(tmp))=tmp;
    end
end

end





function r = resize(d, num)
r={};
r{num}=[];
s=size(d);
for i=1:s(2)
    r{i}=d{i};
end
end





function d = getAnglesForId(fId, cell_indices, SCORE)
idxes=find(cell_indices==fId);
d=[];
x=SCORE(idxes,1);
y=SCORE(idxes,2);
if length(x)<2, return; end
d = ones(length(x)-1, 1);
for i=2:length(x)
    p= polyfit([x(i-1) x(i)], [y(i-1), y(i)],1);
    d(i-1)=atan(p(1));
end
end


function d = getAllAnglesForId(fId, cell_indices, SCORE)
angles= getAnglesForId(fId, cell_indices, SCORE);
d ={};
if length(angles)<2, return; end
d {length(angles)}=[];
for i=1:length(angles)-1
    for j=i:length(angles)
        y= angles(j);
        x= angles(i);
        a=atan2(sin(x-y), cos(x-y));
        d{j-i+1}(end+1) = abs(cos(a));
    end
end
end


function allAngles=getSpatialAutocorrelationForGroup(stacks, BigCellDataStruct, cell_indices, SCORE)
allAngles={};
stack_indices=getStackIndices(BigCellDataStruct);
gIds =getAllIndicesFor(stack_indices, stacks);
cIds = sort(unique(cell_indices.*gIds));
cIds = cIds(2:end);
for i=1:length(cIds)
    fId = cIds(i);
    d=getAllAnglesForId(fId, cell_indices, SCORE);
    s1=size(d);
    s2=size(allAngles);
    if s2(2)<s1(2), 
        allAngles=resize(allAngles, s1(2)); end
    for j=1:s1(2)
        tmp=d{j};
        allAngles{j}(end+1:end+length(tmp))=tmp;
    end
end

end



function writeSpatialAutorrelationPerGroup(items,BigCellDataStruct,cell_indices,SCORE,groupPath)
s=size(items);
for i=1:s(2)
    item =items{i};
    pers=getSpatialAutocorrelationForGroup(item.tracks, BigCellDataStruct, cell_indices, SCORE);
    s=size(pers);
    pM=ones(s(2),1);
    pSt=ones(s(2),1);
    for j=1:s(2)
        tmp = pers{j};
        pM(j)=mean(tmp);
        pSt(j)=std(tmp);
    end
    figure(25);
    clf;
    x = 1:s(2);
    errorbar(x,pM,pSt, 'Color', [156/255,187/255,229/255]);
    hold on
    plot(x,pM, 'Color', [237/255 94/255 48/255], 'LineWidth', 1.5);
    
    ePath = fullfile(groupPath, [char(item.name) '_Persitence_SpatialAutocorrelation.eps']);
    fPath = fullfile(groupPath, [char(item.name) '_Persitence_SpatialAutocorrelation.fig']);
    savefig(gcf,fPath);
    saveas(gcf, ePath, 'epsc'); 
end 


end
