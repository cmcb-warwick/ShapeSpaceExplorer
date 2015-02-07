function [ d, R,phi ] = BAMout( u , v )
%CURVEMETRIC rapidly computes the distance between a pair of planar curves
%u & v. u & v are 1xN complex vectors 
%   N.b. To compute all pairwise distances between curves in a set, a more
%   efficient implementation can be achieved by first running lines 9, 11,
%   13, 14 and 15 on each curve (replace either u or v with the curve in
%   each case). Then run lines 18-23 on each pair.

u=u(:);
v=v(:);
sum_u = sum(real(u).^2+imag(u).^2);
sum_v = sum(real(v).^2+imag(v).^2);
v_temp=flipud(v);
fft_conj_u=fft(conj(u));
fft_flip_v=fft(v_temp);


Xcorr=ifft(fft_conj_u.*fft_flip_v);
Xcorr2=abs(Xcorr);
[A,I]=max(Xcorr2);
phi=atan2(imag(Xcorr(I)),real(Xcorr(I)));
R=I-1;
d=sqrt(sum_u + sum_v - 2*A);

end

