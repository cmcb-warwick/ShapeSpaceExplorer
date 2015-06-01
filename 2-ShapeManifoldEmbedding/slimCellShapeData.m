% slims down the huge CellShapeData.mat output to 
% what is necessary in the rest of the analysis.
% if true is added
function [ CellShapeData_slim ] = slimCellShapeData( CellShapeData, XtraSlim )
CellShapeData_slim.set={};
CellShapeData_slim.point={};
CellShapeData_slim.set.SCORE=CellShapeData.set.SCORE;
CellShapeData_slim.set.Long_D=CellShapeData.set.Long_D;
N = length(CellShapeData.point);
for i =1:N
    CellShapeData_slim.point(i).SCORE =CellShapeData.point(i).SCORE;
    CellShapeData_slim.point(i).coords_comp= CellShapeData.point(i).coords_comp;
    if nargin<2 % no extra slim
    CellShapeData_slim.point(i).sum_curve= CellShapeData.point(i).sum_curve;
    CellShapeData_slim.point(i).fft_flip= CellShapeData.point(i).fft_flip;
    CellShapeData_slim.point(i).fft_conj= CellShapeData.point(i).fft_conj;
    end
end

end

