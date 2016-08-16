function [ d ] = BAM( sum_u, sum_v,fft_conj_u, fft_flip_v )
%CURVEMETRIC rapidly computes the distance between curves u & v in the
%plane. u & v are 1xN complex vectors
Xcorr=ifft(fft_conj_u.*fft_flip_v);
Xcorr=abs(Xcorr);
A=max(Xcorr);
d=real(sqrt(sum_u + sum_v - 2*A));
end