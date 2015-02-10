function [ output_args ] = OoSE_bargraphs( number,trainingCellShapeData,APe_output_foldername,OoSE_experiment_folder )
%OOSE_HISTOGRAMS Summary of this function goes here
%   Detailed explanation goes here


load(fullfile(OoSE_experiment_folder, '/OoSE_embedding.mat'));
load(fullfile(OoSE_experiment_folder, '/Dist_mat.mat'))
load(fullfile(APe_output_foldername, '/wish_list.mat'))


[T2,colour]=ordered_list_edit(number,trainingCellShapeData,APe_output_foldername);
if number==0
    return
end
hold on
exem_D=D(wish_list,:);
[~,wish_idx]=min(exem_D);

over_clusters=T2(wish_idx);

for i=unique(over_clusters)
    plot(OoSE_emb(over_clusters==i,1),OoSE_emb(over_clusters==i,2),'.','color',colour(i,:))
    if i==1; hold on; end
end

num=size(colour,1);
figure
for i=1:num
    h=bar(i,sum(over_clusters==i));
    set(h,'FaceColor',colour(i,:))
     if i == 1, hold on, end
end

end

function [T2,colour]=ordered_list_edit(number,CellShapeData,APe_output_foldername)
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

% colour_idx(colour_idx==5)=4;
% colour_idx(colour_idx==6)=4;
if number==4
    colour=[1 0 0; 0 0.75 0.75; 0.75 0.75 0; 0 0 1];
elseif number==6
    colour=[1 0 0; 0 0.75 0.75; 0.75 0.75 0; 0 0 1; 0 0.5 0; 0.75 0 0.75];
else
    %     colour=hsv(number*6/5);
    %     colour=colour(1:number,:);
    %     %colour=flipud(colour);
    %     colour_norm=colour*colour';
    %     colour_norm2=repmat(sqrt(diag(colour_norm)),1,3);
    %     colour=0.75*colour./(colour_norm2);
    colour=jet(number);
    colour=flipud(colour);
    colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
end
n_exems=length(wish_list);
exem_list=sort(wish_list);
figure
dendrogram(linkagemat,0);
if number==0
    return
else
    close
end

figure
[~,T]=dendrogram(linkagemat,number);
close

for i=1:n_exems
T2(i)=T(exem_list==wish_list(i));
end

d=diff([0 T2]);
clust_order=T2(logical(d));
%subplot(2,number,1:number)
figure
for i=1:number
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    points=ismember(idx,exems);
    plot(SCORE(points,1),SCORE(points,2),'x','Color',colour(clust_order(i),:))
    hold on
end
%axis tight
axis equal
grid on


% L=length(wish_list);
% 
% b=floor(sqrt(L));
% a=ceil(L/b);
% 
% figure
% h = [];
% t = 1;
% A = 0.9/a;
% B=0.9/b;
% for i=1:b
%     y = (b-i)/b;
%     for j=1:a
%         x = (j-1)/a;
%         h(t) = axes('units','norm','pos',[x y A B]);
%         t = t+1;
%     end
% end
% 
% c=1;
% for i=1:number
% %    clust_num=clust_order(i);
%     clust_idx=clust_order(i);
%     exems=wish_list(T2==clust_idx);
%     for j=1:length(exems)
%         plot(real(NewCellArray{exems(j)}),imag(NewCellArray{exems(j)}),'color',colour(i,:),'LineWidth',2,'parent',h(c))
%         axis(h(c), 'equal')
%         axis(h(c),[-0.4 0.4 -0.4 0.4])
%         axis(h(c), 'xy','off')
%         c=c+1;
%     end
%     
% end
% while c<=a*b
%     delete(h(c))
%     c=c+1;
% end

end

