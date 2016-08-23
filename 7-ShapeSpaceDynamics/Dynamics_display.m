function   Dynamics_display(default, groups)
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

% get min/max for tracks

%create a fig folder in the path;
figPath = fullfile( default.path, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end 


data=default.DynamicData;
[figInfo.minProp, figInfo.maxProp]=getDataLimitsForProperty(data, default.propname, default.minTrackLength);
[figInfo.minTrack,figInfo.maxTrack]=getDataLimitsForProperty(data, 'tracks', default.minTrackLength);
figInfo.path = figPath;
figInfo.name ='all_';

drawDynamicDisplay(data, default.propname, default.minTrackLength, figInfo );
%get group data

if ~ groups.do, return; end
% there are groups, do plot for groups.
for g=1:length(groups.items)
    item =groups.items{g};
    gIds=getIndicesForGroup(groups.BigCellDataStruct, item.tracks);
    finalIds=unique(gIds.*groups.cellIdxes);
    finalIds=finalIds(finalIds~=0);
    groupDynamicData=data(finalIds);
    figInfo.name=['Group_' char(item.name) '_'];
    drawDynamicDisplay(groupDynamicData, default.propname, default.minTrackLength, figInfo);
end

end


function [minProp, maxProp] =getDataLimitsForProperty(data, propName, minTrackLength)
minProp =1000000000000;
maxProp =-100000000000;
for i=1: length(data)
    s=size(data(i).track);
    L =s(1);
    if (L<minTrackLength), continue; end
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
            minProp=min(minProp,min(data(i).av_displacement_direction));
            maxProp=max(maxProp,max(data(i).av_displacement_direction));
       elseif (strcmp(propName, 'tracks')==1)
            minProp=min(minProp,min(data(i).track));
            maxProp=max(maxProp,max(data(i).track));

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
        prop =[prop; data(i).av_displacement_direction];
     elseif (strcmp(propName, 'track')==1)
        prop =[prop; data(i).track];
    end
    
end
end





function drawLinesForProperty(data,col_res, minTrackLength, propName, fig)
L = length(data);
colourmap=jet(col_res);

for i=1:L
    s = size(data(i).track); % size of array
    np=s(1);
    if (np<minTrackLength) 
        continue; end
    for j=1:np-1
        %normalize value
        X = getDataItemForProperty(data(i), propName, j);
        X_std =  (X - fig.minProp) ./ (fig.maxProp - fig.minProp); % now between [0,1]
        Cidx = round(X_std .* (col_res - 1) + 1); % now bring it into range.
        line([data(i).track(j,1) data(i).track(j+1,1)],[data(i).track(j,2) data(i).track(j+1,2)],'Color',colourmap(Cidx,:), 'LineWidth', 2);
    hold on
    end
end
xlim([fig.minTrack(2) fig.maxTrack(2)]);
ylim([fig.minTrack(1) fig.maxTrack(1)]);

end

% helper method to get data for plotting.
% 
function [X] = getDataItemForProperty(data, propname, idx)
if strcmp('speeds',propname)
    X=data.speeds(idx);
elseif strcmp('angles',propname)
    X=data.angles(idx);
elseif strcmp('average_speed',propname)  
    X=data.average_speed; % we only have a single value;
elseif strcmp('av_displacement_direction',propname) 
    X=data.av_displacement_direction;
end
end






function plotHistogram(data, col_res, minTrackLength, propName, minProp, maxProp)
set(gca,'FontSize',12);
prop =getAllProp(data, propName, minTrackLength);
x=((1:col_res)*(maxProp-minProp)/col_res)+minProp;
y=hist(prop,x);
barh(x,y);
ylim([minProp maxProp]);
set(gca,'XTickLabel','');
end



function drawDynamicDisplay(data, propname,minTrackLength, fig)
clf
h = figure(1);
col_res=512;
% division on subplot size
sb1=9;
sb2=15;
mat=ones(sb1,1)*(1:(sb2))+(sb2+2)*(0:(sb1-1))'*ones(1,sb2);
subplot(sb1,sb2+2,mat(:)');
drawLinesForProperty(data, col_res, minTrackLength, propname, fig);
% use drawing method according to property

% angle, speed are one per point (transistion), while 
% 
axis equal
title( ['Display Shape Dynamics: ' propname]);
set(gca,'FontSize',12);
colorbar
caxis([fig.minProp, fig.maxProp]);
hold on;

subplot(sb1,sb2+2,(sb2+2):(sb2+2):sb1*(sb2+2));
%plot histogram along colorbar
plotHistogram(data, col_res, minTrackLength, propname, fig.minProp, fig.maxProp)
name = ['7_ShapeDynamics_' char(fig.name) propname '.eps'];
path = fullfile(fig.path, name);
saveas(gca, path,'epsc');
close(h);
end

