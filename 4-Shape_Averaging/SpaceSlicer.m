function [ idx ] = SpaceSlicer(CellShapeData, x_slices, y_slices, path, axes_equal, gfile)
%SPACESLICER Summary of this function goes here
%   Detailed explanation goes here
%
orangeCol=[237/255 94/255 48/255];
greenCol=[167/255 188/255 68/255];
blueCol= [138/255 164/255 208/255];
N=length(CellShapeData.point);
if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end


p=x_slices+1:(x_slices+1)*(y_slices+1);
idx=find(mod(p,x_slices+1)==0);
p(idx)=[];
figPath = fullfile(path, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end
figure % x figure---------------------
set(gcf,'color','w');
[b1, xShapes]=slicey_magoo( CellShapeData,SCORE, [1 0], x_slices, true, blueCol);
fPath=fullfile(figPath, '4_ShapeSlicer_x_axis_shapes');
saveas(gcf, fPath, 'fig');
saveas(gcf, fPath, 'epsc');
mk = getMarkerSize(N);
figure % y figure---------------------
set(gcf,'color','w');
[b2, yShapes]=slicey_magoo( CellShapeData,SCORE, [0 1], y_slices, true, greenCol);
fPath=fullfile(figPath, '4_ShapeSlicer_y_axis_shapes');
saveas(gcf, fPath, 'fig');
saveas(gcf, fPath, 'epsc');

figure % content figure---------------------
set(gcf,'color','w');
plot(SCORE(:,1),SCORE(:,2),'.', 'color', orangeCol, 'MarkerSize', mk)
if axes_equal, axis equal; axis tight; end
hold on
xlim([b1(1) b1(end)]);
ylim([b2(1) b2(end)]);
xm =xlim;
ym =ylim;
for i=2:x_slices
   plot([b1(i) b1(i)],ym,'color',[0.5,.5,.5]);
end


for i=2:y_slices
   plot(xm,[b2(i) b2(i)],'color',[.5,.5,.5]);
end
plot(SCORE(:,1),SCORE(:,2),'.', 'color', orangeCol, 'MarkerSize', mk)
fPath=fullfile(figPath, '4_ShapeSlicer_content_only');
saveas(gcf, fPath, 'fig');
saveas(gcf, fPath, 'epsc');

%----------------------------------------------------
figure % combined figure
set(gcf,'color','w');
for i=1:x_slices
    subplot(y_slices+1, x_slices+1,i)
    s=xShapes{i};
    if ~isempty(s)
        plot(s, 'color',blueCol);
    end
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
end


for i=1:y_slices
    subplot(y_slices+1, x_slices+1,(i+1)*(x_slices+1));
    idx = y_slices-i+1;
    s=yShapes{idx};
    if ~isempty(s)
        plot(s, 'color', greenCol);
    end
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
end



subplot(y_slices+1, x_slices+1,p);
plot(SCORE(:,1),SCORE(:,2),'.', 'color', orangeCol,'MarkerSize', mk)
if axes_equal, axis equal; end
hold on
xlim([b1(1) b1(end)]);
ylim([b2(1) b2(end)]);
xm =xlim;
ym =ylim;

for i=2:x_slices
   plot([b1(i) b1(i)],ym,'color',blueCol);
end


for i=2:y_slices
   plot(xm,[b2(i) b2(i)],'color',greenCol);
end
plot(SCORE(:,1),SCORE(:,2),'.', 'color', orangeCol)
fPath=fullfile(figPath, '4_ShapeSlicer_combined');
saveas(gcf, fPath, 'fig');
saveas(gcf, fPath, 'epsc');

close all



%----------------------------------------------------
if isempty(gfile), return; end
figure % combined figure with group
set(gcf,'color','w');
for i=1:x_slices
    subplot(y_slices+1, x_slices+1,i)
    s=xShapes{i};
    if ~isempty(s)
        plot(s, 'color',blueCol);
    end
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
end


for i=1:y_slices
    subplot(y_slices+1, x_slices+1,(i+1)*(x_slices+1));
    idx = y_slices-i+1;
    s=yShapes{idx};
    if ~isempty(s)
        plot(s, 'color', greenCol);
    end
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
end


subplot(y_slices+1, x_slices+1,p);
data=load(gfile);
items = data.groups;
s=size(items);
st=load(fullfile(path, 'BigCellDataStruct.mat'));
lgd={};lines=[];
colour=jet(s(2));
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
mk = getMarkerSize(N);
painted=zeros(size(SCORE(:,1)));
for i=1:s(2)
    item =items{i};
    gIds=getIndicesForGroup(st.BigCellDataStruct, item.tracks);
    painted = painted +gIds;
    idx =find(gIds);
    if isempty(idx), continue; end
    lines(end+1)=plot(SCORE(idx,1),SCORE(idx,2),'.','color',colour(i,:), 'MarkerSize', mk);
    lgd{end+1}=char(item.name);
    hold on
end
painted=logical(painted); % just to be sure;
idx =find(painted==0);
if ~isempty(idx)
    lines(end+1)=plot(SCORE(idx,1),SCORE(idx,2),'.','color',[0.5,.5,.5], 'MarkerSize', mk);
    lgd{end+1}='no group';
end
if axes_equal, axis equal; end

xlim([b1(1) b1(end)]);
ylim([b2(1) b2(end)]);
xm =xlim;
ym =ylim;

for i=2:x_slices
   plot([b1(i) b1(i)],ym,'color',blueCol);
end
for i=2:y_slices
   plot(xm,[b2(i) b2(i)],'color',greenCol);
end
legend(gca,lines, lgd);
fPath=fullfile(figPath, '4_ShapeSlicer_combined_withGroups');
saveas(gcf, fPath, 'fig');
saveas(gcf, fPath, 'epsc');



%----------------------------------------------------





%---------------------------------------------------------------
function [bounds, avshapes]=slicey_magoo( CSD,SCORE, vect, num, plotshapes, color )
avshapes={};
d=length(vect); 
Score=SCORE(:,1:d);
vect=vect(:)/norm(vect(:));
proj=Score*vect;
[idx, bounds]=compSliceGrouping(CSD,SCORE, vect, num);

normproj=Score-proj*vect';
normproj_d=sqrt(diag(normproj*normproj'));
if d<=2
    centres=mean([bounds(1:num); bounds(2:(num+1))]);
    centres=centres'*vect';
    centres=centres(:,1)+1i*centres(:,2);
    step=bounds(2)-bounds(1);
else
    centres=1:num;
    step=1;
end
if plotshapes
    for i=1:num
        cellset_idx=find(idx==i);
        if isempty(cellset_idx), 
            avshapes{i}=[];
            continue; end
        [~,mid]=min(abs(normproj_d(cellset_idx)));
        avshape=shapemean(CSD,cellset_idx,cellset_idx(mid),0)';
        c=princomp([real(avshape) imag(avshape)]);
        theta=atan2(c(2),c(1));
        avshape=avshape*exp(1i*(-theta));
        avshape=-avshape*sign(max(real(avshape))+min(real(avshape)));
        avshape=avshape*exp(1i*(pi/4));
        avshape=0.5*step*avshape/(1.1*max(abs(avshape)));
        avshapes{i}=avshape;
        plot(avshape+centres(i), 'color', color);
        hold on
    end
    axis equal
    axis xy off
end

end


function  [idx, bounds]=compSliceGrouping( CSD,SCORE, vect, num)
N=length(CSD.point);
d=length(vect); 
Score=SCORE(:,1:d);
vect=vect(:)/norm(vect(:));
proj=Score*vect;
M=max(proj);
m=min(proj);
bounds=linspace(m,M,num+1);
idx=ones(N,1);
for i=2:num
    idx(proj>bounds(i))=i;
end
end




