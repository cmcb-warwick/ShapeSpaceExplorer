function [ idx ] = SpaceSlicer(default, group, cluster)
% this comes from old structure
CellShapeData =default.csd;
x_slices=default.xSlices;
y_slices=default.ySlices;
path=default.path;
axes_equal=default.axesEqual;

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
[h,p]=plotFigureGrid(x_slices, y_slices, xShapes,yShapes, blueCol, greenCol);
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

[squareNames, groupNames, matrix, scoreIdx]=calculateAllHistos(CellShapeData,SCORE, x_slices, y_slices);
writeToFile(matrix, squareNames, {'Squares'}, 'Square_Histograms', figPath);
write2HistOverview(matrix, groupNames, 'Square_Histograms', figPath);
writeAvgShape(scoreIdx, SCORE, CellShapeData, figPath, 'all');
%----------------------------------------------------

if group.do
data=load(group.path);
items = data.groups;
plotFigureGrid(x_slices, y_slices, xShapes,yShapes, blueCol, greenCol);
subplot(y_slices+1, x_slices+1,p);

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
if axes_equal, axis equal; end % 

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

%figure % group and histogram
[squareNames, groupNames, matrix, scoreIdx]=calculateHistos(CellShapeData,SCORE, x_slices, y_slices, items, st);
writeToFile(matrix, squareNames, groupNames, 'Group_Histograms', figPath);
write2Histo(matrix, groupNames,  'Group', figPath); %
for i=1:length(items)
    group =items{i};
    idxMatrix =scoreIdx(:,:,i);
    writeAvgShape(idxMatrix, SCORE, CellShapeData, figPath, ['group_' char(group.name)]);
end



end % END OF GROUP ----------------------------------





   

    

end





function [cx, cy, idx] =getCenterCoordinate(x,y)
cDist = Inf;
idx=-1;
for i=1:length(x)
    cd=0;
    for j=1:length(x)
         cd =cd+ sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
    end
    if cd<cDist,
        cx=x(i);
        cy=y(i);
        cDist=cd;
        idx=i;
    end
end
end

function write2HistOverview(matrix, groupNames, prefix, folder)
s=size(matrix);
if length(s)<3, s(3)=1; end
sumGroup = sum(matrix(:));

h=figure();
clf;
h=subplot(s(1), s(2),1);
idx=1;
for j=1:s(1)
    idx = s(1)-j+1; %
    idx = idx *s(2)-s(2)+1;
    for i=1:s(2)
        h=subplot(s(1), s(2),idx);
        if sumGroup==0
            num =0;
        else
            num =matrix(j,i, 1)/sumGroup;
        end
        bar(idx, num); idx=idx+1;
        ylim([0 1.0]);
        hold on
        end
end
name = char(['4_Histo_' prefix '_square']);
title('Distribution across squares');
set(gca, 'XTick', 1:s(2)*s(1), 'XTickLabel', groupNames);
ylim([0 1.2]);
fPath = fullfile(folder, name);
saveas(h, fPath, 'fig');
saveas(h, fPath, 'epsc');
        
close all
end % end of the if condition...


function writeAvgShape(idxMatrix, SCORE, CellShapeData,folder, prefix)
s=size(idxMatrix);
col=[0.5,0.5,0.5];
figure
clf
set(gcf,'color','white');
h=subplot(s(1), s(2),1);
for j=1:s(1)
    idx = s(1)-j+1; %
    idx = idx *s(2)-s(2)+1;
    for i=1:s(2)
        h=subplot(s(1), s(2),idx);
        ax=idxMatrix{j,i};
        if ~isempty(ax)
            x=SCORE(ax,1);
            y=SCORE(ax,2);
            [~, ~, ix] =getCenterCoordinate(x,y);
            avshape=shapemean(CellShapeData,ax,ax(ix),0);
            plot(avshape, 'color', col,'LineWidth',2)
        else
            plot(0,0, 'color', 'w');
        end
        axis equal
        axis off
        idx=idx+1;
        end
end
name = char(['4_Histo_Groups_AvgShapes_' prefix]);
fPath = fullfile(folder, name);
saveas(h, fPath, 'fig');
saveas(h, fPath, 'epsc');
close all




end



function write2Histo(matrix, groupNames, prefix, folder)
s=size(matrix);
sumGroup = calculateSumOfGroups(matrix);   % for all 
colour=jet(s(3));
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
figure
clf
h=subplot(s(1), s(2),1);
for j=1:s(1)
    idx = s(1)-j+1; %
    idx = idx *s(2)-s(2)+1;
    for i=1:s(2)
        h=subplot(s(1), s(2),idx);
        for k=1:s(3)
            if sumGroup(k)==0
                num =0;
            else
                num =matrix(j,i, k)/sumGroup(k);
            end
            h=bar(k, num);
            set(h,'FaceColor',colour(k,:));
            hold on
        end
        set(gca, 'XTick', 1:length(groupNames), 'XTickLabel', groupNames);
        ylim([0 1.0]);
        idx=idx+1;
        end
end
name = char(['4_Histo_' prefix  '_square']);
        fPath = fullfile(folder, name);
        saveas(h, fPath, 'fig');
        saveas(h, fPath, 'epsc');
close all
end % end of the if condition...





% matlab 2012 hack for cvs with strings;
function writeToFile(matrix, squareNames, groupNames, prefix, folder)
name = char(['4_Table_' prefix '.csv']);
path = fullfile(folder, name);
header =char(' ');
for i =1:length(groupNames)
    header =char( [ header ', ' groupNames{i}]);
end
dlmwrite(path,header,'delimiter','');
s=size(matrix);
if length(s)<3, s(3)=1; end % if there is only one group.
    
for j=1:s(1)
    for i=1:s(2)
        line =char([squareNames{j}{i} ',']);
        for k=1:s(3)
            line=char([line num2str(matrix(j,i,k)) ',']);
        end
        dlmwrite(path,line,'delimiter','', '-append');
    end
end
end



function sumG = calculateSumOfGroups(matrix)
s=size(matrix);
if s<3, s(3)=1; end % for single group.
sumG =zeros(s(3),1);
for i=1:s(3)
    tmp = matrix(:,:,i);
    sumG(i)=sum(tmp(:));
end
end


%-----------
% we get a 3 dim matrix back
% y,x plane defines the square of the sliciing
% the z dimension lists the groups for the y_j,x_i square.
function [squareNames, groupNames, matrix, scoreIdx]=calculateHistos(CellShapeData,SCORE, x_slices, y_slices, items, st)

squareNames={};
groupNames={};
scoreIdx={};
[xIds, ~]=compSliceGrouping( CellShapeData,SCORE,[1,0], x_slices); % compute x slices.
[yIds, ~]=compSliceGrouping( CellShapeData,SCORE,[0,1], y_slices); % compute y slices.
s=size(items);
matrix=zeros(y_slices,x_slices,s(2));
%------- how the squares are sliced.
% group2_1 group2_2 group2_3
% group1_1 group1_2 group1_3
%-----

for k = 1:y_slices
    yInd=find(yIds==k);
for j =1:x_slices
    xInd=find(xIds==j);
    ind =intersect(yInd, xInd); % ids that are in both slices.
    
    for i=1:s(2)
        item =items{i};
        gIds=getIndicesForGroup(st.BigCellDataStruct, item.tracks);
        matrix(k,j,i)= sum(gIds(ind));
        %find group indices=intersection of being in this slice, and belong
        %to the corerct group.
        a=gIds(ind);
        gIx=a.*ind;
        zIx=gIx==0;
        gIx(zIx)=[];
        scoreIdx{k,j,i}=gIx;
        if (k==1 & j==1),groupNames{end+1}=char(item.name);end
    end
    squareNames{k}{j}=char([ 'y_' num2str(k) '_x_' num2str(j)]);
end

end

end







function [squareNames, groupNames, matrix, idxMatrix]=calculateAllHistos(CellShapeData,SCORE, x_slices, y_slices)
squareNames={};
groupNames={};
idxMatrix={};
[xIds, ~]=compSliceGrouping( CellShapeData,SCORE,[1,0], x_slices); % compute x slices.
[yIds, ~]=compSliceGrouping( CellShapeData,SCORE,[0,1], y_slices); % compute y slices.
matrix=zeros(y_slices,x_slices,1);

for k = 1:y_slices
    yInd=find(yIds==k);
for j =1:x_slices
    xInd=find(xIds==j);
    
    ind =intersect(yInd, xInd); % ids that are in both slices.
    idxMatrix{k,j}=ind;
    matrix(k,j,1)= length(ind); 
    groupNames{end+1}=char([ 'y_' num2str(k) '_x_' num2str(j)]);  
    squareNames{k}{j}=char([ 'y_' num2str(k) '_x_' num2str(j)]);
end

end
end



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




function [clusterIdx, success]=ordered_list_edit(number, cIdx, linkagemat,wish_list,CellShapeData)
%ORDERED_LIST generates a number of figures bringing together BAM DM and
%APe. APe is a hierarchical clustering extension to Affinity Propagation
%using Wishart Seriation, this should have been executed using
%AP_Seriation_analysis_finaledit prior to running this code. 

%number is the number of clusters you wish to view in your generated images,
%if you haven't yet decided you can enter 0 to display the just the
%dendrogram to aid your decision. 

%CellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code

success=0;
N=length(CellShapeData.point);
clusterIdx=zeros(N,1);

n_exems=length(wish_list);

if number>n_exems
    display('There are more desired cluster than maximal clusters available in data set.');
    display('Please enter an appropriate number of clusters.');
    return
end

figure
[~,T]=dendrogram(linkagemat,number);
close
for i=1:n_exems
    idx=find(cIdx==wish_list(i));
    clusterIdx(idx)=T(i);
end
success=1;

end


function [h, p] = plotFigureGrid(x_slices, y_slices, xShapes,yShapes, blueCol, greenCol)
figure % combined figure with group
h=gcf;
set(gcf,'color','w');
p=x_slices+1:(x_slices+1)*(y_slices+1);
idx=find(mod(p,x_slices+1)==0);
p(idx)=[];
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

end


