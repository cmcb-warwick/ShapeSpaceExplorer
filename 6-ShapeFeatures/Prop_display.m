function [ output_args ] = Prop_display( CellShapeData,morphframe, propname , folder, cell_numbers)
%PROP_DISPLAY Summary of this function goes here
%   Detailed explanation goes here
%
%CellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code of your training data.

%morphframe can be generated using Morph_Props

%propname should be the desired property to view, the options are:
    %Area
    %Circularity
    %ConvexArea
    %Dist_max
    %Dist_min
    %Dist_ratio
    %Eccentricity
    %EquivDiameter
    %Extent
    %Irregularity
    %Irregularity2
    %MajorAxisLength
    %MinorAxisLength
    %Orientation
    %Perimeter
    %Solidity
    %Symmetry

%cell_numbers is an optional argument that allows you to specify a sublist
%of cells to plot, the default is all cells.
if ~exist('cell_numbers','var')
    cell_numbers=1:length(CellShapeData.point);
end
figPath = fullfile( folder, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end 

L=length(cell_numbers);
col_res=512;
colourmap=jet(col_res);

newDM_pointframe=CellShapeData.point(cell_numbers);
newMorph_props_struct=morphframe(cell_numbers);
if (~strcmp(class(newMorph_props_struct(1).(propname)),'double'))||(numel(newMorph_props_struct(1).(propname))~=1)
    disp([propname ' not scalar'])
    return
end
for i=1:L
    SCORE(i,:)=newDM_pointframe(i).SCORE;
    prop(i)=newMorph_props_struct(i).(propname);
end

%chop outliers
std_dev=std(prop);
med_prop=median(prop);
prop(prop>(med_prop+3.5*std_dev))=med_prop+3.5*std_dev;
prop(prop<(med_prop-3.5*std_dev))=med_prop-3.5*std_dev;

if std_dev==0
   disp([propname ' constant'])
   return
end


norm_prop=prop-min(prop);
norm_prop=norm_prop/max(norm_prop);
norm_prop=(col_res-1)*norm_prop+1;
norm_prop=round(norm_prop);

sb1=9;
sb2=15;
mat=ones(sb1,1)*(1:(sb2))+(sb2+2)*(0:(sb1-1))'*ones(1,sb2);
subplot(sb1,sb2+2,mat(:)');

for i=1:L
    plot(SCORE(i,1),SCORE(i,2),'.','Color',colourmap(norm_prop(i),:), 'MarkerSize', 6);
    hold on
end
axis equal
title( ['Display Shape Feature:' propname]);
%sb=6;
set(gca,'FontSize',12);
subplot(sb1,sb2+2,(sb2+1):(sb2+2):(sb1*(sb2+2)-1));
set(gca,'FontSize',12);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
xlabel({['max:',sprintf('%2.2f',max(prop))],['min:',sprintf('%2.2f',min(prop))]});
hold on;
for kl=1:512
    s=(kl*(max(prop)-min(prop))/512)+min(prop);
    c=colourmap(kl,:);
    plot(0,s,'s','MarkerSize',20,'MarkerFaceColor',c,'MarkerEdgeColor',c);
end
axis xy off

subplot(sb1,sb2+2,(sb2+2):(sb2+2):sb1*(sb2+2));
set(gca,'FontSize',12);
set(gca,'XTickLabel','');
x=((1:512)*(max(prop)-min(prop))/512)+min(prop);
y=hist(prop,x);
barh(x,y);
set(gca,'YAxisLocation','right');
ax=get(gca,'Xtick');
set(gca,'Xtick',ax([1 end]));




name = ['6_ShapeFeature_' propname '.fig'];
path = fullfile(figPath, name);
savefig(path);


end

