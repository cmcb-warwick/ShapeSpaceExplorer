function [ output_args ] = Exemplar_direction_rose_plots( DynamicData, CellShapeData, number,APe_output_foldername)
%AVERAGE_LOCAL_DIRECTION Summary of this function goes here
%   Cell_cell should be a cell array where each cell contains the embedded
%shape space path of one cell through time, this should be a Kx2 matrix, K being the number of time points for the cell.
% if ~isempty(varargin)
%     Nbins=varargin{1};
% else
%     Nbins=[100 50];
% end

load([APe_output_foldername '/APclusterOutput.mat'])
load([APe_output_foldername '/wish_list.mat'])

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

exemplars=wish_list;
exL=length(exemplars);

vecs_in_cluster=cell(exL,1);

N=length(Cell_cell);
k=1;
for j=1:N
    
    L=size(Cell_cell{j},1);
    for i=1:L
        clust=exemplars==idx(k);
        k=k+1;
        if L>1
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

figure
for i=1:exL
    subplot(2,1,1)
    h=rose(vecs_in_cluster{i});
    x = get(h,'Xdata');
    y = get(h,'Ydata');
    m=sqrt(x.^2+y.^2);
    m=max(m(:));
    subplot(2,1,2)
    c=scale_fac/m;
    v=SCORE(exemplars(i),[1 2]);
    g=patch(c*x+v(1),c*y+v(2),'y');
    set(g,'FaceColor','b','EdgeColor','k');
    hold on
end
axis equal
subplot(2,1,1)
%colours='rcybgm';
%colours=[1 0 0; 0 0.75 0.75; 0.75 0.75 0; 0 0 1; 0 1 0; 1 0 1];

[colour_idx,colours]=ordered_list_edit(number,CellShapeData,APe_output_foldername);

for i=1:exL
    v=SCORE(exemplars(i),[1 2]);
    c=scale_fac;
    plot(c*CellShapeData.point(exemplars(i)).coords_comp+v(1)+1i*v(2),'Color',colours(colour_idx(i),:),'LineWidth',2)
    hold on
end
axis equal
linkaxes

name = ['7_ClusteredSpacedShape_Dynamics_' num2str(number) '_clusters.fig'];
path = fullfile(figPath, name);
savefig(path);
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

end

