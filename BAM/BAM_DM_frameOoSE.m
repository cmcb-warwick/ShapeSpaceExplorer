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
    waitbar(p/N,h,sprintf('Step 2. Computing distances: %5.2f%% completed ..',100*p/N));
    
end
waitbar(1,h,'Step 3. Embedding, please wait.');
D=D./(sqrt(nodes));
d=d./(sqrt(nodes));
sig_sq=median(d);
Frame.set.Long_D=d;
clear('d')
% 
% %distance to similarity
% D=D.^2;
% D=D/(2*sig_sq);
% D=-D;
% D=exp(D);
% 
% %Normalise matrix (including Laplace-Beltrami Normalisation)
% d=sum(D);
% d_inv_root=d.^(-1/2);
% for i=1:nobs
%     D(i,:)=d_inv_root(i)*D(i,:);
% end
% for i=1:nobs
%     D(:,i)=d_inv_root(i)*D(:,i);
% end
% 
% 
% %Find eigenvectors (V) and values (D)
% if doSparse
%     [Vect,Val]=eig(D); %With large matrices this can be very slow, consider using sparse eigendecomp (eigs, as below) instead.
% else
%     [Vect,Val]=eigs(D,(no_dims+1));
% end
% 
% Frame.set.Vect=Vect; %With large matrices you might want to suppress this as it will take a lot of RAM
% Frame.set.Val=diag(Val);  %ditto
% Frame.set.sig_sq=sig_sq;
% [~, ind] = sort(abs(diag(Val)), 'descend');
% Val=diag(Val);
% Val=Val(ind);
% 
% phi_min = Vect(:,ind(2:(no_dims+1)));
% Val_min = Val(2:(no_dims+1));
% for i=1:no_dims
%     phi_min(:,i)=d_inv_root'.*phi_min(:,i);
% end
% % Normalize eigenvectors by their eigenvalue to obtain embedding
% SCORE = phi_min .* repmat((Val_min)', [size(phi_min,1) 1]);
% Frame.set.SCORE=SCORE;
for i=1:nobs
    Frame.point(i).SCORE=scoress.OoSE_emb(i,:);
end
end

