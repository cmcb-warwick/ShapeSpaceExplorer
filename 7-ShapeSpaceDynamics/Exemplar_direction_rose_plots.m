function   Exemplar_direction_rose_plots( DynamicData, CellShapeData, number,APe_output_foldername, minTrackLength)
%AVERAGE_LOCAL_DIRECTION Summary of this function goes here
%   Cell_cell should be a cell array where each cell contains the embedded
%shape space path of one cell through time, this should be a Kx2 matrix, K being the number of time points for the cell.
% if ~isempty(varargin)
%     Nbins=varargin{1};
% else
%     Nbins=[100 50];
% end

cw=load( fullfile(APe_output_foldername, 'wish_list.mat'));
cl=load( fullfile(APe_output_foldername, 'linkagemat.mat'));
ci=load([APe_output_foldername '/APclusterOutput.mat']);


figPath = fullfile( APe_output_foldername, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end 
Cell_cell={DynamicData(:).track};

Cell_cell=Cell_cell(:);
SCORE=cell2mat(Cell_cell);
M=max(SCORE);
xM=M(1); yM=M(2);
m=min(SCORE);
xm=m(1); ym=m(2);

dx=xM-xm;
dy=yM-ym;

exemplars=cw.wish_list;
exL=length(exemplars);

vecs_in_cluster=cell(exL,1);

N=length(Cell_cell);
k=1;
for j=1:N
    
    L=size(Cell_cell{j},1);
    for i=1:L
        clust = exemplars==ci.idx(k);
        k=k+1;
        if L>minTrackLength % here we filter that the track is larger...
            if i==1
                vecs_in_cluster{clust}(end+1)=atan2(Cell_cell{j}(2,2)-Cell_cell{j}(1,2),Cell_cell{j}(2,1)-Cell_cell{j}(1,1));
            elseif i==L
                vecs_in_cluster{clust}(end+1)=atan2(Cell_cell{j}(L,2)-Cell_cell{j}(L-1,2),Cell_cell{j}(L,1)-Cell_cell{j}(L-1,1));
            else
                vecs_in_cluster{clust}(end+1)=atan2(Cell_cell{j}(i,2)-Cell_cell{j}(i-1,2),Cell_cell{j}(i,1)-Cell_cell{j}(i-1,1));
                vecs_in_cluster{clust}(end+1)=atan2(Cell_cell{j}(i+1,2)-Cell_cell{j}(i,2),Cell_cell{j}(i+1,1)-Cell_cell{j}(i,1));
            end
        end
    end
end

scale_fac=(max(SCORE(:,1))-min(SCORE(:,1)))/(2*exL);
%plot shape
colours=jet(number);
colours=flipud(colours);
colours=colours.*repmat((1-0.25*colours(:,2)),1,3);
[colour_idx, success]=ordered_list_edit(number,cw.wish_list, cl.linkagemat, CellShapeData);

if ~ success, return; end
h1=figure(50);
%subplot(number,1,2)
%number
%for i=1:exL
for i=1:number
       subplot(number,number,i)
    %h=rose(vecs_in_cluster{i});
    %%
    cc=colours(i,:);
%   h=plot(vecs_in_cluster{i});
            polarhistogram(vecs_in_cluster{i},'FaceColor',cc);
            rticklabels({})
            rticks([])
%             % ax=gca;
%             % ax = 'none';
              ax = gca;
%             %d = ax.ThetaDir;
%             ax.ThetaGrid = 'off';
%             ax.RGrid = 'off';
%             ax.ThetaMinorGrid = 'off';
%             ax.RMinorGrid = 'off';
             ax.GridLineStyle = 'none';
%             ax.MinorGridLineStyle = 'none';
             ax.FontSize = 7;
    %%
  %  h=rose(vecs_in_cluster{i});
 %   x = get(h,'Xdata');
 %   y = get(h,'Ydata');
    %[x,y] = rose(vecs_in_cluster{i})
 %   m=sqrt(x.^2+y.^2);
 %   m=max(m(:));
   %subplot(2,1,2)
 %   c=scale_fac/m;
    %v=SCORE(exemplars(i),[1 2]);
    %g=patch(c*x+v(1),c*y+v(2),'y');
    %set(g,'FaceColor','b','EdgeColor','k');
    hold on
    
end
name = ['7_ClusteredSpaceShape_Dynamics_1_' num2str(number) '_clusters'];
path = fullfile(figPath, name);
saveas(h1, path, 'fig');
saveas(h1, path, 'epsc');
%axis equal
hold off
h2=figure(60);
%subplot(number,1,1)


for i=1:exL
    v=SCORE(exemplars(i),[1 2]);
    c=scale_fac*10;
    plot(c*CellShapeData.point(exemplars(i)).coords_comp+v(1)+1i*v(2),'Color',colours(colour_idx(i),:),'LineWidth',1)
    hold on
end
%axis equal
%linkaxes
%hold off

 

% set(ha_axes, 'Parent', h)
% set(hb_axes, 'Parent', h)
% set(ha_axes, 'Position', [0.1300    0.1100    0.3347    0.8150])
% set(hb_axes, 'Position', [0.5703    0.1100    0.3347    0.8150])
name = ['7_ClusteredSpaceShape_Dynamics_2_' num2str(number) '_clusters'];
path = fullfile(figPath, name);
saveas(h2, path, 'fig');
saveas(h2, path, 'epsc');
end


function [clusterIdx, success]=ordered_list_edit(number, wish_list, linkagemat,CellShapeData)
%ORDERED_LIST generates a number of figures bringing together BAM DM and
%APe. APe is a hierarchical clustering extension to Affinity Propagation
%using Wishart Seriation, this should have been executed using
%AP_Seriation_analysis_finaledit prior to running this code. 

%number is the number of clusters you wish to view in your generated images,
%if you haven't yet decided you can enter 0 to display the just the
%dendrogram to aid your decision. 

%CellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code

success=0;
N=length(CellShapeData.point);

if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end
clusterIdx=zeros(N,1);


for i=1:N
    NewCellArray{i}=CellShapeData.point(i).coords_comp;
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

if number>n_exems
    display('There are more desired cluster than maximal clusters available in data set.');
    display('Please enter an appropriate number of clusters.');
    return
end

figure
[~,T]=dendrogram(linkagemat,number);
close

for i=1:n_exems
clusterIdx(i)=T(exem_list==wish_list(i));
end
success=1;

end

