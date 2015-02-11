function [ shapemean_out ] = shapemean( CSD, cellset_idx, middle_idx, ploton )
%SHAPEMEAN Summary of this function goes here
%   Detailed explanation goes here
if isempty(cellset_idx)
    shapemean_out=[];
    return
end

N=length(CSD.point);
n=length(cellset_idx);

newcellarray=zeros(n,512);
sc=CSD.point(middle_idx).sum_curve;
ff=CSD.point(middle_idx).fft_flip;
for i=1:n
    idx=cellset_idx(i);
    [~,R,phi]=BAM(CSD.point(idx).sum_curve,sc,CSD.point(idx).fft_conj,ff);
    complex_A=CSD.point(idx).coords_comp;
    rotated_A=exp(1i*phi)*complex_A;
    rotated_and_cycled_A=rotated_A([(1+R):end 1:R]);
    
    newcellarray(i,:)=rotated_and_cycled_A;
end

shapemean_out=mean(newcellarray,1);

if ploton
   plot(CSD.point(middle_idx).coords_comp,'g')
   hold on
   plot(shapemean_out,'r','LineWidth',3)
    axis equal
end


end


function [ d, R,phi ] = BAM( sum_u, sum_v,fft_conj_u, fft_flip_v )
%CURVEMETRIC rapidly computes the distance between curves u & v in the
%plane. u & v are 1xN complex vectors
%   Detailed explanation goes here
%sum_u = sum(real(u).^2+imag(u).^2);
%sum_v = sum(real(v).^2+imag(v).^2);
%v_temp=flipud(v);
Xcorr=ifft(fft_conj_u.*fft_flip_v);
Xcorr2=abs(Xcorr);
[A,I]=max(Xcorr2);
phi=atan2(imag(Xcorr(I)),real(Xcorr(I)));
R=I-1;
d=sqrt(sum_u + sum_v - 2*A);
end
