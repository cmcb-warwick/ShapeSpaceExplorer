function [ idx, bounds ] = SpaceSlicer(CellShapeData)
%SPACESLICER Summary of this function goes here
%   Detailed explanation goes here
%

N=length(CellShapeData.point);
if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end

x_slices=2;
y_slices=4;

figure
b1=slicey_magoo( CellShapeData,SCORE, [1 0], x_slices, true);

figure
b2=slicey_magoo( CellShapeData,SCORE, [0 1], y_slices, true);

figure
plot(SCORE(:,1),SCORE(:,2),'.')
hold on
M1=max(SCORE(:,2));
m1=min(SCORE(:,2));
M2=max(SCORE(:,1));
m2=min(SCORE(:,1));
for i=1:(x_slices-1)
   plot(b1(i+1)*ones(1,2),[m1 M1],'color',[1 0.5 0])
end
for i=1:(y_slices-1)
   plot([m2 M2],b2(i+1)*ones(1,2),'color',[1 0 1]) 
end
axis equal; grid on;axis tight

end

function [bounds]=slicey_magoo( CSD,SCORE, vect, num, plotshapes )
N=length(CSD.point);
d=length(vect);
% for i=1:N
%     Score(i,:)=CSD.point(i).SCORE(1:d);
% end
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
        [~,mid]=min(abs(normproj_d(cellset_idx)));
        avshape=shapemean(CSD,cellset_idx,cellset_idx(mid),0)';
        c=princomp([real(avshape) imag(avshape)]);
        theta=atan2(c(2),c(1));
        avshape=avshape*exp(1i*(-theta));
        avshape=-avshape*sign(max(real(avshape))+min(real(avshape)));
        avshape=avshape*exp(1i*(pi/4));
        avshape=0.5*step*avshape/(1.1*max(abs(avshape)));
        plot(avshape+centres(i))
        hold on
    end
    axis equal 
    axis xy off
end

end
