function unordered_list(CellShapeData,APe_output_foldername)
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
%colours='grbym';
colours=[0 255 0; 255 0 0 ; 0 0 255; 255 140 0 ; 187.5 187.5 0; 255 0 255]./255;
colours=[colours; 0.5*colours];
figure
disp_num=max(a-1,10);
%clust_num=12;
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
    plot(real(NewCellArray{ex}),imag(NewCellArray{ex}),'color',colours(i,:),'LineWidth',2)
        %axis tight
%         axis square
         axis equal
        axis([-0.4 0.4 -0.4 0.4])
        axis xy off
    for j=2:(length(disp)+1)
        subplot(clust_num,disp_num,disp_num*(i-1)+j)
        plot(real(NewCellArray{disp(j-1)}),imag(NewCellArray{disp(j-1)}),'color',colours(i,:),'LineWidth',2)

        %axis tight
%         axis square
         axis equal
        axis([-0.4 0.4 -0.4 0.4])
        axis xy off
    end
end
%linkaxes
%xlim([-0.3 0.3])
% a=10; % Number of row
% b=20;   %and column of subplot
% [Y,I]=sort(rand(1,a*b));
% figure;
% t0=clock;

% create axes in a grid
figure
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
%set(h,'XtickLabel','','YTickLabel','','nextplot','add');

for i=1:(a*b)
    %subplot(a,b,i)
    if i<=L
        if ismember(i,EG)
            plot(real(NewCellArray{exems(i)}),imag(NewCellArray{exems(i)}),'color',colours(EG==i,:),'LineWidth',2,'parent',h(i))
        else
            plot(real(NewCellArray{exems(i)}),imag(NewCellArray{exems(i)}),'k','LineWidth',2,'parent',h(i))
        end
%         if rem(i,10)==0
%             drawnow % only do this every 10th time to increase speed
%         end
%        axis(h(i), 'tight')
%         axis(h(i), 'square')
         axis(h(i), 'equal')
        axis(h(i),[-0.4 0.4 -0.4 0.4])
    end
    axis(h(i), 'xy','off')
end
% linkaxes
% xlim([-0.3 0.3])
end
