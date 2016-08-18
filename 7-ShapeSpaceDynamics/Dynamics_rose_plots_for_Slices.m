function  Dynamics_rose_plots_for_Slices( default, groups)
%shape space path of one cell through time, this should be a Kx2 matrix, K being the number of time points for the cell.
%setup the datas
DynamicData =default.data;
Nbins=[default.xSlice default.ySlice];
minTrackLength=default.minTrackLength;


figPath = fullfile( default.path, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end 
% prepare the data for the box (angles and speed)
[angles_in_box, spiderPlot_in_box] = getDataForPlots(DynamicData, Nbins, minTrackLength);
plotRoses(Nbins, angles_in_box, figPath, 'all_')

% now do the spider graph
gobalMaxVal = getMaxOfAvgSpeeds(Nbins,spiderPlot_in_box);
plotSpiderCharts(Nbins, spiderPlot_in_box, figPath,gobalMaxVal, 'all_')



% get
if ~ groups.do, return; end
for g=1:length(groups.items)
    item =groups.items{g};
    gIds=getIndicesForGroup(groups.BigCellDataStruct, item.tracks);
    finalIds=unique(gIds.*groups.cellIdxes);
    finalIds=finalIds(finalIds~=0);
    groupDynamicData=DynamicData(finalIds);
    [angles_in_box, spiderPlot_in_box] = getDataForPlots(groupDynamicData, Nbins, minTrackLength);
    plotRoses(Nbins, angles_in_box, figPath, ['Group_' char(item.name) '_']);
    % now do the spider graph
    
    plotSpiderCharts(Nbins, spiderPlot_in_box, figPath,gobalMaxVal, ['Group_' char(item.name) '_']);
end
end

%---------------------------------------------------------------
% END of script, beginning of helper function
%---------------------------------------------------------------
function [type]=getAngleType(angle)

angle = mod(angle+360,360);
if (angle>315 || angle <=45)
    type =1;
elseif (angle>45 && angle <=135)
    type=2;
elseif (angle>135 && angle<=225)
    type=3;
elseif(angle>225 && angle<=315)
    type=4;
else
    print('Angle error:')
    angle
end
 
   
end

function [spiderValues]=calculateSpiderWebValues(allSpeeds)
lengthDir = length(allSpeeds);
one=[];
if ((lengthDir>0)&& ~(isempty(allSpeeds{1}))) 
    one=allSpeeds{1}; end

two=[];
if ((lengthDir>1)&&(~isempty(allSpeeds{2}))) 
    two=allSpeeds{2}; end

three=[];
if ((lengthDir>2)&&(~isempty(allSpeeds{3}))) 
    three=allSpeeds{3}; end
four=[];
if ((lengthDir>3)&&(~isempty(allSpeeds{4}))) 
    four=allSpeeds{4}; end
spiderValues=[mean(one); mean(two);...
              mean(three); mean(four)];
    

end

function [m]=getMaxOfAvgSpeeds(Nbins, allspeeds)
m =0;
for j=1:Nbins(2)
    for i=1:Nbins(1)
     for a=1:4 % iterate over angle
        try
        tmp= allspeeds{j,i}{a};
        m= max(m, mean(tmp));
        end
     end
    end
end
end

function [angles_in_box, spiderPlot_in_box]=getDataForPlots(DynamicData, Nbins, minTrackLength)
Cell_track={DynamicData(:).track};
Cell_angle={DynamicData(:).angles};
Cell_speeds={DynamicData(:).speeds};
Cell_track=Cell_track(:);
Cell_angle=Cell_angle(:);
SCORE=cell2mat(Cell_track);
M=max(SCORE);
xM=M(1); yM=M(2);
m=min(SCORE);
xm=m(1); ym=m(2);

dx=xM-xm;
dy=yM-ym;
angles_in_box=cell(fliplr(Nbins));
spiderPlot_in_box=cell(fliplr(Nbins));

% prepare the data
N=length(Cell_track);
for j=1:N
    L=size(Cell_track{j},1);
    if L<minTrackLength, continue; end %  if track smaller than minLength. forget it
    for i=1:L-1 % we have one angle less, than we have points.
        %calculate in which bin the track falls
        vec=Cell_track{j}(i,:);
        xbox=ceil(Nbins(1)*((vec(1)-xm)/dx));
        ybox=ceil(Nbins(2)*((vec(2)-ym)/dy));
        if xbox==0
            xbox=1;
        end
        if ybox==0
            ybox=1;
        end
        % put angle in the right box the angle.
        angles_in_box{ybox,xbox}(end+1)=deg2rad(Cell_angle{j}(i));
        angleType=getAngleType(Cell_angle{j}(i));
        vector =Cell_speeds{j}(i);
        old = [];
        try  % needs try because if it does not exist, failsß
            old=spiderPlot_in_box{ybox, xbox}{angleType};
        end
        spiderPlot_in_box{ybox, xbox}{angleType}=[old; vector];
    end
end



end


function plotRoses(Nbins, angles_in_box, figPath, stringID)
clf

for j=1:Nbins(2);
    for i=1:Nbins(1);
        
        if ~isempty(angles_in_box{j,i})
            gf=figure(1);
            set(gf, 'Visible', 'off');
            h=rose(angles_in_box{j,i});
            x = get(h,'Xdata');
            y = get(h,'Ydata');
            figure(2)
            subplot(Nbins(2),Nbins(1),Nbins(1)*(Nbins(2)-j)+i)
            g=patch(x,y,'y');
            set(g,'FaceColor','b','EdgeColor','k');
            axis equal
            axis xy off
        else
            figure(2)
            subplot(Nbins(2),Nbins(1),Nbins(1)*(Nbins(2)-j)+i)
            axis xy off
            
        end
        %axis xy off
    end
end
name = ['7_SlicedSpacedShape_Dynamics_' char(stringID) num2str(Nbins(1)) '_xSlices_' num2str(Nbins(2)) '_ySlices'];
path = fullfile(figPath, name);
saveas(gcf, path, 'fig');
saveas(gcf, path, 'epsc');
end


function plotSpiderCharts(Nbins, spiderPlot_in_box, figPath, maxVal, stringID)
clf
for j=1:Nbins(2)
    for i=1:Nbins(1)
        if ~isempty(spiderPlot_in_box{j,i})
            plot=subplot(Nbins(2),Nbins(1),Nbins(1)*(Nbins(2)-j)+i);
            spiderValues=calculateSpiderWebValues(spiderPlot_in_box{j,i});
            spider( spiderValues, ' ', [0 maxVal], {'0', '90', '180', '270'}, {''}, plot);
            axis xy off
        else
            
            subplot(Nbins(2),Nbins(1),Nbins(1)*(Nbins(2)-j)+i)
            axis xy off
            
        end
        %axis xy off
    end
end

name = ['7_SlicedSpacedShape_Dynamics_Radar_' char(stringID) num2str(Nbins(1)) '_xSlices_' num2str(Nbins(2)) '_ySlices'];
path = fullfile(figPath, name);
saveas(gcf, path, 'fig');
saveas(gcf, path, 'epsc');
end


function groupDynamicData =getGroupDynamicData(DynamicData, finalIds)



end