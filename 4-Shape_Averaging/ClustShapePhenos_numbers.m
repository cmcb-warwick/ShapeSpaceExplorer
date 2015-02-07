function [ output_args ] = ClustShapePhenos_numbers(number,CellShapeData, APe_output_foldername )
%ClustShapePhenos_numbers will create the average shape of clusters
%(specifed by number) as defined by Affinity Propagation with seriation
%extension (APe). 



load([APe_output_foldername '/APclusterOutput.mat'])
load([APe_output_foldername '/wish_list.mat'])
load([APe_output_foldername '/linkagemat.mat'])

N=length(CellShapeData.point);

if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end

% colour_idx(colour_idx==5)=4;
% colour_idx(colour_idx==6)=4;
% colour=[1 0 0; 0 0.75 0.75; 0.75 0.75 0; 0 0 1];
colour=jet(number);

exem_list=sort(wish_list);
[~,T]=dendrogram(linkagemat,number);
close

wish_pos=zeros(1,number);

for i=1:number
    example_exemplar=find(T==i,1,'first');
    wish_pos(i)=find(wish_list==exem_list(example_exemplar));
end

[~,~,clust_order]=unique(wish_pos);
clust_order=clust_order(:)';
figure
for i=1:number
    idx=clust_order(i);
    exems=exem_list(T==idx);
    subplot(1,number,i)
    shapemean_out=shapemean(CellShapeData,exems,exems(floor(length(exems)/2)),0);
    plot(shapemean_out,'Color',colour(i,:),'LineWidth',3)
    axis equal
    axis tight
    axis xy off
    %bar([Kcount(i)/5009 Ccount(i)/2836])
end

end

