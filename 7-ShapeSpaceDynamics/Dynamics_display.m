function [ output_args ] = Dynamics_display( DynamicData, propname , folder, cell_numbers)
%DYNAMICS_DISPLAY To plot colour-coded tracks of cells through shape space.
%   Detailed explanation goes here
%
%DynamicData shuld be generated first using Run_DynamicData_Generation.m

%propname should be the desired property to view, the options are:
    %speeds
    %average_speed
    %angles
    %av_displacement_direction

%cell_numbers is an optional argument that allows you to specify a sublist
%of cells to plot, the default is all cells.

if ~exist('cell_numbers','var')
    cell_numbers=1:length(DynamicData);
end
figPath = fullfile( folder, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end 
h=figure(100);
L=length(cell_numbers);
col_res=512;
colourmap=jet(col_res);

data=DynamicData(cell_numbers);

for i=1:L
    prop=[prop; data(i).(propname)];
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

pos = 0;

for i=1:L
    np = length(data(i).speeds);
    for j=1:np
    line([data(i).track(j,1) data(i).track(j+1,1)],[data(i).track(j,2) data(i).track(j+1,2)],'Color',colourmap(norm_prop(pos+j),:), 'LineWidth', 2);
    hold on
    end
    pos = pos + np;
end

axis equal
title( ['Display Shape Dynamics: ' propname]);
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




name = ['7_ShapeDynamics_' propname '.eps'];
path = fullfile(figPath, name);
saveas(gca, path,'epsc');
close(h);

end

