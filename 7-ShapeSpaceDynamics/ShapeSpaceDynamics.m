function [ DynamicData ] = ShapeSpaceDynamics( cell_idx, CellShapeData,savedestination )
%SHAPESPACE Summary of this function goes here
%   Detailed explanation goes here
% cell_idx is inside Bigcellarrayandindex from your segmentation output
if ~exist('savedestination','var')
    savedestination=pwd; 
end

L=max(cell_idx);
DynamicData=struct([]);
for i=1:L
   track =CellShapeData.set.SCORE(cell_idx==i,1:2);
   if isempty(track), continue; end
   DynamicData(i).track=track;
   temp=diff(DynamicData(i).track,1,1);
   DynamicData(i).speeds=sqrt(sum(temp.^2,2));
   DynamicData(i).average_speed=mean(DynamicData(i).speeds);
   
   DynamicData(i).angles=180*atan2(temp(:,2),temp(:,1))/pi;
   DynamicData(i).av_displacement_direction=180*atan2(DynamicData(i).track(end,2)-DynamicData(i).track(1,2),DynamicData(i).track(end,1)-DynamicData(i).track(1,1))/pi;
   DynamicData(i).trackId=i;
end
path = fullfile(savedestination, 'DynamicData.mat');
save(path,'DynamicData','-v7.3');

end

