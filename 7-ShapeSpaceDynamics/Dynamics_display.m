function   Dynamics_display(DynamicData , folder, propname, minTrackLength)
%DYNAMICS_DISPLAY To plot colour-coded tracks of cells through shape space.
%   Detailed explanation goes here
%
%DynamicData shuld be generated first using Run_DynamicData_Generation.m

%propname should be the desired property to view, the options are:
    %0==speeds
    %1==average_speed
    %2==angles
    %3==av_displacement_direction

%cell_numbers is an optional argument that allows you to specify a sublist
%of cells to plot, the default is all cells.

if ~exist('cell_numbers','var')
    cell_numbers=1:length(DynamicData);
end
%create a fig folder in the path;
figPath = fullfile( folder, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end 
fig=figure(100);

col_res=512;% how many colors the colormap has
data=DynamicData(cell_numbers);


% division on subplot size
sb1=9;
sb2=15;
mat=ones(sb1,1)*(1:(sb2))+(sb2+2)*(0:(sb1-1))'*ones(1,sb2);
subplot(sb1,sb2+2,mat(:)');
% use drawing method according to property
if strcmp('speeds',propname)
    drawLinesForSpeeds(data,col_res, minTrackLength)
elseif strcmp('angles',propname)
    drawLinesForAngles(data,col_res, minTrackLength)
elseif strcmp('average_speed',propname)  
    drawLinesForAvgSpeed(data,col_res, minTrackLength)
elseif strcmp('av_displacement_direction',propname) 
    drawLinesForAvgDisplacement(data,col_res, minTrackLength)
end
% angle, speed are one per point (transistion), while 
% 

[minProp, maxProp]=getDataForProperty(data, propname, minTrackLength);
axis equal
title( ['Display Shape Dynamics: ' propname]);
set(gca,'FontSize',12);
colorbar
caxis([minProp, maxProp]);
hold on;


subplot(sb1,sb2+2,(sb2+2):(sb2+2):sb1*(sb2+2));
%plot histogram along colorbar
plotHistogram(data, col_res, minTrackLength, propname)
name = ['7_ShapeDynamics_' propname '.eps'];
path = fullfile(figPath, name);
saveas(gca, path,'epsc');
close(fig);

end


function [minProp, maxProp] =getDataForProperty(data, propName, minTrackLength)
minProp =1000000000000;
maxProp =0;
for i=1: length(data)
    s=size(data(i).track);
    L =s(1);
    if (L>minTrackLength)
        if (strcmp(propName, 'speeds')==1)
            minProp=min(minProp,min(data(i).speeds));
            maxProp=max(maxProp,max(data(i).speeds));
        elseif (strcmp(propName, 'average_speed')==1)
            minProp=min(minProp,min(data(i).average_speed));
            maxProp=max(maxProp,max(data(i).average_speed));
        elseif (strcmp(propName, 'angles')==1)
            minProp=min(minProp,min(data(i).angles));
            maxProp=max(maxProp,max(data(i).angles));
        
        
        elseif (strcmp(propName, 'av_displacement_direction')==1)
            minProp=min(minProp,min(data(i).angles));
            maxProp=max(maxProp,max(data(i).angles));
        
end

    end
end
end

function [prop] =getAllProp(data, propName, minTrackLength)
prop=[];
for i=1: length(data)
    s=size(data(i).track);
    L =s(1);
    if (L<minTrackLength) continue; end
    if (strcmp(propName, 'speeds')==1)
        prop =[prop; data(i).speeds];
    elseif (strcmp(propName, 'average_speed')==1)
        prop =[prop; data(i).average_speed];
    elseif (strcmp(propName, 'angles')==1)
        prop =[prop; data(i).angles];
    elseif (strcmp(propName, 'av_displacement_direction')==1)
        prop =[prop; data(i).angles];
    end
    
end
end


function drawLinesForSpeeds(data,col_res, minTrackLength)
L = length(data);
colourmap=jet(col_res);
[minProp, maxProp]=getDataForProperty(data, 'speeds', minTrackLength);
for i=1:L
    s = size(data(i).track); % size of array
    np=s(1);
    if (np<minTrackLength) 
        continue; end
    for j=1:np-1
        c = round((data(i).speeds(j)-minProp)/(maxProp-minProp)*(col_res-1)) +1; % plus one,because index starts at one
        line([data(i).track(j,1) data(i).track(j+1,1)],[data(i).track(j,2) data(i).track(j+1,2)],'Color',colourmap(c,:), 'LineWidth', 2);
    hold on
    end
end

end


function drawLinesForAngles(data,col_res, minTrackLength)
L = length(data);
colourmap=jet(col_res);
[minProp, maxProp]=getDataForProperty(data, 'angles', minTrackLength);
for i=1:L
    s = size(data(i).track); % size of array
    np=s(1);
    if (np<minTrackLength) 
        continue; end
    for j=1:np-1
        c = round((data(i).angles(j)-minProp)/(maxProp-minProp)*(col_res-1)) +1; % plus one,because index starts at one
        line([data(i).track(j,1) data(i).track(j+1,1)],[data(i).track(j,2) data(i).track(j+1,2)],'Color',colourmap(c,:), 'LineWidth', 2);
    hold on
    end
end
end


function drawLinesForAvgSpeed(data,col_res, minTrackLength)
L = length(data);
colourmap=jet(col_res);
[minProp, maxProp]=getDataForProperty(data, 'average_speed', minTrackLength);
for i=1:L
    s = size(data(i).speeds); % size of array
    np=s(1);
    if (np<minTrackLength) 
        continue; end
    for j=1:np-1
        colorIndex = round((data(i).average_speed-minProp)/(maxProp-minProp)*(col_res-1)) +1; % plus one,because index starts at one
        line([data(i).track(j,1) data(i).track(j+1,1)],[data(i).track(j,2) data(i).track(j+1,2)],'Color',colourmap(colorIndex,:), 'LineWidth', 2);
    hold on
    
    end
end

end


function drawLinesForAvgDisplacement(data,col_res, minTrackLength)
L = length(data);
colourmap=jet(col_res);
[minProp, maxProp]=getDataForProperty(data, 'av_displacement_direction', minTrackLength);
for i=1:L
    s = size(data(i).speeds); % size of array
    np=s(1);
    if (np<minTrackLength) 
        continue; end
    for j=1:np-1
        colorIndex = round((data(i).av_displacement_direction-minProp)/(maxProp-minProp)*(col_res-1)) +1; % plus one,because index starts at one
        line([data(i).track(j,1) data(i).track(j+1,1)],[data(i).track(j,2) data(i).track(j+1,2)],'Color',colourmap(colorIndex,:), 'LineWidth', 2);
    hold on
    end
end
end

function plotHistogram(data, col_res, minTrackLength, propName)
set(gca,'FontSize',12);

[minProp, maxProp]=getDataForProperty(data, propName, minTrackLength);
prop =getAllProp(data, propName, minTrackLength);
x=((1:col_res)*(maxProp-minProp)/col_res)+minProp;
y=hist(prop,x);
barh(x,y);
ylim([minProp maxProp]);
set(gca,'XTickLabel','');
end