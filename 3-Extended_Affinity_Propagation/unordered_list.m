function unordered_list(CellShapeData, APe_output_foldername)
%This shows the unordered AP clusters and a few example exemplars and
%example members of each corresponding cluster

%CellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code

%savedestination should be the same as for AP_Seriation_analysis_finaledit


%NOTE: This can be very slow if there are many clusters, this code could be
%sped up a lot by changing subplot, go here: http://uk.mathworks.com/matlabcentral/newsreader/view_thread/16962

load([APe_output_foldername '/APclusterOutput.mat'])
load([APe_output_foldername '/wish_list.mat'])
load([APe_output_foldername '/linkagemat.mat'])
figPath=fullfile(APe_output_foldername, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end

N=length(CellShapeData.point);
for i=1:N
    NewCellArray{i}=CellShapeData.point(i).coords_comp;
end
exems=unique(idx);
L=length(exems);
%L=10;
b=floor(sqrt(L));
a=ceil(L/b);
if L>10
    clust_num=10;
    EG = randsample(L,clust_num);
    EG=sort(EG);
else
    clust_num=L;
    EG=1:L;
end
% colours=[0 255 0; 255 0 0 ; 0 0 255; 255 140 0 ; 187.5 187.5 0; 255 0 255]./255;
% colours=[colours; 0.5*colours];

colour=jet(clust_num);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
%--------------------------------
figure
set(gcf,'color','w');
disp_num=max(a-1,10);
for i=1:clust_num
    ex=exems(EG(i));
    clust=find(idx==ex);
    clust(clust==ex)=[];
    if length(clust)>disp_num-1
        disp=randsample(clust,disp_num-1);
    else
        disp=clust;
    end
    subplot(clust_num,disp_num,disp_num*(i-1)+1)
    plot(real(NewCellArray{ex}),imag(NewCellArray{ex}),'color',colour(i,:),'LineWidth',2)
         axis equal
        axis([-0.4 0.4 -0.4 0.4])
        axis xy off
    for j=2:(length(disp)+1)
        subplot(clust_num,disp_num,disp_num*(i-1)+j)
        plot(real(NewCellArray{disp(j-1)}),imag(NewCellArray{disp(j-1)}),'color',colour(i,:),'LineWidth',2)
         axis equal
        axis([-0.4 0.4 -0.4 0.4])
        axis xy off
    end
end
fPath=fullfile(figPath, '3_AllShapes_10_Examples_foreach_Cluster.fig');
savefig(fPath);

% --------------------
% create axes in a grid
figure
set(gcf,'color','w');
h = [];
t = 1;
A = 0.9/a;
B=0.9/b;
for i=1:b
    y = (b-i)/b;
    for j=1:a
        x = (j-1)/a;
        h(t) = axes('units','norm','pos',[x y A B]);
        t = t+1;
    end
end


for i=1:(a*b)
    if i<=L
        if ismember(i,EG)
            plot(real(NewCellArray{exems(i)}),imag(NewCellArray{exems(i)}),'color',colour(EG==i,:),'LineWidth',2,'parent',h(i))
        else
            plot(real(NewCellArray{exems(i)}),imag(NewCellArray{exems(i)}),'k','LineWidth',2,'parent',h(i))
        end
        axis(h(i), 'equal')
        axis(h(i),[-0.4 0.4 -0.4 0.4])
    end
    axis(h(i), 'xy','off')
end
fPath=fullfile(figPath, '3_AllShapes_Example_foreach_Cluster.fig');
savefig(fPath);
end

