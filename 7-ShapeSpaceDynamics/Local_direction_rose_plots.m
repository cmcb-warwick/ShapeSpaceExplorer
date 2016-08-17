function  Local_direction_rose_plots( DynamicData, folder, varargin )
%AVERAGE_LOCAL_DIRECTION Summary of this function goes here
%   Cell_track should be a cell array where each cell contains the embedded
%shape space path of one cell through time, this should be a Kx2 matrix, K being the number of time points for the cell.
if ~isempty(varargin)
    Nbins=varargin{1};
else
    Nbins=[10 6];
end

figPath = fullfile( folder, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end 
Cell_track={DynamicData(:).track};
Cell_angle={DynamicData(:).angles};
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

dicrection_in_box=cell(fliplr(Nbins));

spiderMax=0;
N=length(Cell_track);
for j=1:N
    L=size(Cell_track{j},1);
    if L<2, continue; end %  if track smaller than minLength. forget it
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
        vector =Cell_track{j}(i+1,:)-Cell_track{j}(i,:);
        % get the max values for spider web;
        tmp=max(abs(vector(1)), abs(vector(2)));
        spiderMax=max(spiderMax, tmp);
        old = [];
        try  % needs try because if it does not exist, failsß
            old=dicrection_in_box{ybox, xbox}{angleType};
        end
        dicrection_in_box{ybox, xbox}{angleType}=[old; vector];
        %angles_in_box{ybox,xbox}(end+1)=atan2(Cell_track{j}(2,2)-Cell_track{j}(1,2),Cell_track{j}(2,1)-Cell_track{j}(1,1));
        
        %if i==1
        %    angles_in_box{ybox,xbox}(end+1)=atan2(Cell_track{j}(2,2)-Cell_track{j}(1,2),Cell_track{j}(2,1)-Cell_track{j}(1,1));
        %elseif i==L
        %    angles_in_box{ybox,xbox}(end+1)=atan2(Cell_track{j}(L,2)-Cell_track{j}(L-1,2),Cell_track{j}(L,1)-Cell_track{j}(L-1,1));
        %else
        %    angles_in_box{ybox,xbox}(end+1)=atan2(Cell_track{j}(i,2)-Cell_track{j}(i-1,2),Cell_track{j}(i,1)-Cell_track{j}(i-1,1));
        %    angles_in_box{ybox,xbox}(end+1)=atan2(Cell_track{j}(i+1,2)-Cell_track{j}(i,2),Cell_track{j}(i+1,1)-Cell_track{j}(i,1));
        %end
        
    end
end

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
name = ['7_SlicedSpacedShape_Dynamics_' num2str(Nbins(1)) '_xSlices_' num2str(Nbins(2)) '_ySlices'];
path = fullfile(figPath, name);
saveas(gcf, path, 'fig');
saveas(gcf, path, 'epsc');

% now do the spider graph
clf
for j=1:Nbins(2);
    for i=1:Nbins(1);
        
        if ~isempty(dicrection_in_box{j,i})
            plot=subplot(Nbins(2),Nbins(1),Nbins(1)*(Nbins(2)-j)+i);
            %set(gcf, 'Visible', 'off');
            spiderValues=calculateSpiderWebValues(dicrection_in_box{j,i});
            spider( spiderValues, ' ', [0 spiderMax/2], {'0', '90', '180', '270'}, {''}, plot);
           
            
            %g=patch(x,y,'y');
            %set(g,'FaceColor','b','EdgeColor','k');
            %axis equal
            axis xy off
        else
            
            subplot(Nbins(2),Nbins(1),Nbins(1)*(Nbins(2)-j)+i)
            axis xy off
            
        end
        %axis xy off
    end
end

name = ['7_SlicedSpacedShape_Dynamics_Radar_' num2str(Nbins(1)) '_xSlices_' num2str(Nbins(2)) '_ySlices'];
path = fullfile(figPath, name);
saveas(gcf, path, 'fig');
saveas(gcf, path, 'epsc');

% now draw the spider web.




end


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

function [spiderValues]=calculateSpiderWebValues(allDirections)
lengthDir = length(allDirections);
one=[];
if ((lengthDir>0)&& ~(isempty(allDirections{1}))) 
    one=allDirections{1}; end

two=[];
if ((lengthDir>1)&&(~isempty(allDirections{2}))) 
    two=allDirections{2}; end

three=[];
if ((lengthDir>2)&&(~isempty(allDirections{3}))) 
    three=allDirections{3}; end
four=[];
if ((lengthDir>3)&&(~isempty(allDirections{4}))) 
    four=allDirections{4}; end
spiderValues=[getMagnitudeDirection(one); getMagnitudeDirection(two);...
              getMagnitudeDirection(three); getMagnitudeDirection(four)];
    

end

%% calculate the mean vector of a series of vectors
%  and return the Magnitude of the average Direction.
function [value]=getMagnitudeDirection(directions)
if (isempty(directions)) 
    value=0; return; 
end
s=size(directions);
if (s(1)>1)
    avg_direction=mean(directions);
else
    avg_direction=directions;
end
value=sqrt(avg_direction(1)^2+avg_direction(2)^2);
end