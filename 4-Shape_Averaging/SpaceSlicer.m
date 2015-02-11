function [ idx, bounds ] = SpaceSlicer(CellShapeData)
%SPACESLICER Summary of this function goes here
%   Detailed explanation goes here
%
close all
N=length(CellShapeData.point);
if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end

x_slices=6;
y_slices=5;
p=x_slices+1:(x_slices+1)*(y_slices+1);
idx=find(mod(p,x_slices+1)==0);
p(idx)=[];


figure % x figure

[b1, xShapes]=slicey_magoo( CellShapeData,SCORE, [1 0], x_slices, true);

figure % y figure
[b2, yShapes]=slicey_magoo( CellShapeData,SCORE, [0 1], y_slices, true);

figure
set(gcf,'color','w');
for i=1:x_slices
    subplot(y_slices+1, x_slices+1,i)
    s=xShapes{i};
    if ~isempty(s)
        plot(s);
    end
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
end


for i=1:y_slices
    subplot(y_slices+1, x_slices+1,(i+1)*(x_slices+1));
    idx = y_slices-i+1;
    s=yShapes{idx};
    if ~isempty(s)
        plot(s);
    end
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
end



subplot(y_slices+1, x_slices+1,p);
plot(SCORE(:,1),SCORE(:,2),'.')
hold on
xlim([b1(1) b1(end)]);
ylim([b2(1) b2(end)]);
xm =xlim;
ym =ylim;

for i=2:x_slices
   plot([b1(i) b1(i)],ym,'color',[1 0.5 0]);
end


for i=2:y_slices
   plot(xm,[b2(i) b2(i)],'color',[1 0 1]);
end

plot(SCORE(:,1),SCORE(:,2),'.')
%axis equal; axis tight

end

function [bounds, avshapes]=slicey_magoo( CSD,SCORE, vect, num, plotshapes )
avshapes={};
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
        plot(avshape+centres(i))
        hold on
    end
    axis equal 
    axis xy off
end

end
