function [Frame] = BAM_DM_frameOoSE(scoress, Frame, no_dims,h ,nodes, doSparse)
%DM Takes some data X, where rows correspond to observations and columns to
%variables and performs a diffusion map embedding, where the similarity
%between x and y is the Gaussian kernel of Best Alignment Metric (BAM) between x and y.
%with sigma chosen to be mean BAM score.
%   Detailed explanation goes here

nobs=size(Frame.point,2);%number of observations

for i=1:nobs
    curve=Frame.point(i).coords_comp;
    Frame.point(i).sum_curve = sum(real(curve).^2+imag(curve).^2);
    Frame.point(i).fft_conj=fft(conj(curve));
    Frame.point(i).fft_flip=fft(flipud(curve));
end

N=nobs*(nobs-1)/2;

%Distance matrix
D=zeros(nobs,nobs);
d=zeros(N,1);
k=1;
for j=2:nobs
    for i=1:(j-1)
        D(i,j)=BAM(Frame.point(i).sum_curve,Frame.point(j).sum_curve,Frame.point(i).fft_conj,Frame.point(j).fft_flip);
        D(j,i)=D(i,j);
        d(k)=D(i,j);
        k=k+1;
    end
    p=j*(j-1)/2;
    waitbar(p/N,h,sprintf('OoSE embedding: %5.2f%% completed ..',100*p/N));
    
end
waitbar(1,h,'Finalising Embedding, please wait.');
D=D./(sqrt(nodes));
d=d./(sqrt(nodes));
sig_sq=median(d);
Frame.set.Long_D=d;
clear('d')

for i=1:nobs
    Frame.point(i).SCORE=scoress.OoSE_emb(i,:);
end
end

