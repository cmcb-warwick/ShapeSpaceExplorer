function [ output_args ] = OoSE_bargraphs( number,trainingCellShapeData,APe_output_foldername,OoSE_experiment_folder )
%OOSE_HISTOGRAMS Summary of this function goes here
%   Detailed explanation goes here


load(fullfile(OoSE_experiment_folder, '/OoSE_embedding.mat'));
load(fullfile(OoSE_experiment_folder, '/Dist_mat.mat'))
load(fullfile(APe_output_foldername, '/wish_list.mat'))
figPath = fullfile( OoSE_experiment_folder, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end 

figure(12)
clf;
[T2,colour]=ordered_list_edit(number,trainingCellShapeData,APe_output_foldername,0);
if number==0
    return
end
hold on
exem_D=D(wish_list,:);
[~,wish_idx]=min(exem_D);

over_clusters=T2(wish_idx);

for i=unique(over_clusters)
    plot(OoSE_emb(over_clusters==i,1),OoSE_emb(over_clusters==i,2),'.','color',colour(i,:), 'MarkerSize', 10);
    if i==1; hold on; end
end
fPath=fullfile(figPath,'5_OsSE_dots');
saveas(gcf, fPath, 'fig');
saveas(gcf, fPath, 'epsc');



%---- mono
figure(12)
clf;
N=length(trainingCellShapeData.point);
mk=getMarkerSize(N);
[T2,colour]=ordered_list_edit(number,trainingCellShapeData,APe_output_foldername,1);
if number==0
    return
end
hold on
exem_D=D(wish_list,:);
[~,wish_idx]=min(exem_D);

over_clusters=T2(wish_idx);

for i=unique(over_clusters)
    plot(OoSE_emb(over_clusters==i,1),OoSE_emb(over_clusters==i,2),'.','color',colour(i,:), 'MarkerSize', mk);
    if i==1; hold on; end
end
fPath=fullfile(figPath,'5_OsSE_dots_mono');
saveas(gcf, fPath, 'fig');
saveas(gcf, fPath, 'epsc');


figure(12)
clf;

num=size(colour,1);
array=[];
for i=1:num
    n = sum(over_clusters==i);
    h=bar(i,n);
    set(h,'FaceColor',colour(i,:))
     if i == 1, hold on, end
    array(end+1)=n;
end
fPath=fullfile(figPath, '5_OsSE_bargraph');
tPath=fullfile(figPath, '5_OsSE_bargraph.txt');
saveas(gcf, fPath, 'fig');
saveas(gcf, fPath, 'epsc');
dlmwrite(tPath ,array, '\t');
close all
end

function [T2,colour]=ordered_list_edit(number,CellShapeData,APe_output_foldername, gray)
%ORDERED_LIST generates a number of figures bringing together BAM DM and
%APe. APe is a hierarchical clustering extension to Affinity Propagation
%using Wishart Seriation, this should have been executed using
%AP_Seriation_analysis_finaledit prior to running this code. 

%number is the number of clusters you wish to view in your generated images,
%if you haven't yet decided you can enter 0 to display the just the
%dendrogram to aid your decision. 

%CellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code

%savedestination should be the same as for AP_Seriation_analysis_finaledit


load([APe_output_foldername '/APclusterOutput.mat'])
load([APe_output_foldername '/wish_list.mat'])
load([APe_output_foldername '/linkagemat.mat'])
T2=[];


N=length(CellShapeData.point);
mk = getMarkerSize(N);
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


% colour
colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);

n_exems=length(wish_list);
exem_list=sort(wish_list);
figure('visible', 'off')
dendrogram(linkagemat,0);
if number==0
    return
else
    close
end

figure('visible', 'off')
[~,T]=dendrogram(linkagemat,number);
close

for i=1:n_exems
T2(i)=T(exem_list==wish_list(i));
end

d=diff([0 T2]);
clust_order=T2(logical(d));
%subplot(2,number,1:number)
for i=1:number
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    points=ismember(idx,exems);
    alpha(0.9);
    if ~gray
        plot(SCORE(points,1),SCORE(points,2),'o','Color',colour(clust_order(i),:), 'MarkerSize', 5)
    else
        plot(SCORE(points,1),SCORE(points,2),'.','Color',[0.5 0.5 0.5], 'MarkerSize', mk);
    end
    hold on
end
 alpha(1.0);
%axis tight
axis equal
grid on




end



function mk = getMarkerSize(N)
mk = 10;
if N>10000, mk =7; end
if N>20000, mk =3; end
end

