function [ output_args ] = Local_direction_rose_plots( DynamicData, varargin )
%AVERAGE_LOCAL_DIRECTION Summary of this function goes here
%   Cell_cell should be a cell array where each cell contains the embedded
%shape space path of one cell through time, this should be a Kx2 matrix, K being the number of time points for the cell.
if ~isempty(varargin)
    Nbins=varargin{1};
else
    Nbins=[10 6];
end
Cell_cell={DynamicData(:).track};

Cell_cell=Cell_cell(:);
SCORE=cell2mat(Cell_cell);
M=max(SCORE);
xM=M(1); yM=M(2);
m=min(SCORE);
xm=m(1); ym=m(2);

dx=xM-xm;
dy=yM-ym;
vecs_in_box=cell(fliplr(Nbins));

N=length(Cell_cell);
for j=1:N
    
    L=size(Cell_cell{j},1);
    for i=1:L
        vec=Cell_cell{j}(i,:);
        xbox=ceil(Nbins(1)*((vec(1)-xm)/dx));
        ybox=ceil(Nbins(2)*((vec(2)-ym)/dy));
        if xbox==0
            xbox=1;
        end
        if ybox==0
            ybox=1;
        end
        if i==1
            vecs_in_box{ybox,xbox}(end+1)=atan2(Cell_cell{j}(2,2)-Cell_cell{j}(1,2),Cell_cell{j}(2,1)-Cell_cell{j}(1,1));
        elseif i==L
            vecs_in_box{ybox,xbox}(end+1)=atan2(Cell_cell{j}(L,2)-Cell_cell{j}(L-1,2),Cell_cell{j}(L,1)-Cell_cell{j}(L-1,1));
        else
            vecs_in_box{ybox,xbox}(end+1)=atan2(Cell_cell{j}(i,2)-Cell_cell{j}(i-1,2),Cell_cell{j}(i,1)-Cell_cell{j}(i-1,1));
            vecs_in_box{ybox,xbox}(end+1)=atan2(Cell_cell{j}(i+1,2)-Cell_cell{j}(i,2),Cell_cell{j}(i+1,1)-Cell_cell{j}(i,1));
        end
    end
end


for j=1:Nbins(2);
    for i=1:Nbins(1);
        
        if ~isempty(vecs_in_box{j,i})
            figure(1)
            h=rose(vecs_in_box{j,i});
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



end
