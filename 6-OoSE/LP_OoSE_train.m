function [ d, q, sig_naught ] = LP_OoSE_train(trainingCellShapeData, savedestination)
%LP_OoSE_train Train Laplacian Pyramids for original analysis data set
%   Implementation of Laplacian Pyramids method from Rabin and Coifman 2012
%   used to extend current data embedding to new points. This calculate the
%   LPs for original data set.

%trainingCellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code of your training data.

%shape_distance_vector should be a long (Lx1) vector of shape distances
%   (Found in CellShapeData.set.Long_D if ShapeManifoldEmbedding has been
%   run) where L=N(N-1)/2 with N being you sample size.
%   shape_distance_vector should be arranged as the distances between the
%   following pairs (1,2), (1,3), (2,3), (1,4), (2,4), (3,4),.....

%target_func should be a Nxd matrix containing the result of the function
%that you are trying to approximate, on the training data. N is the size of
%your training data set, d is the dimensionality For Out-of-Sample
%Extension embedding, this should be one of the Diffusion dimensions
%(stored as SCORE), created by ShapeManifoldEmbedding. 


shape_distance_vector=trainingCellShapeData.set.Long_D;
target_func=trainingCellShapeData.set.SCORE;

Adm_Err=10^(-8);
sig_naught=1;
D=shape_distance_vector;
clear('shape_distance_vector');

nobs=size(target_func,1);
if size(D,1)~=size(D,2) % when D is not a square matrix
    %D2=D;
    D2=zeros(nobs,nobs);
    k=1;
    for j=2:nobs
        for i=1:(j-1)
            D2(i,j)=D(k);
            D2(j,i)=D2(i,j);
            k=k+1;
        end
    end
    D=D2;
    clear('D2')
end

dist2 = D.^2;

for tfi=1:nobs
    ftrain = target_func(:,tfi);
    %train
    l = -1;
    err = 100;
    sig0 = 1;
    adm_err = 10^-5;
    while err >= adm_err
        l=l+1;
        sig = sig0/(2^l);
        %equation 3.17
        gl = exp(-dist2/sig);
        ql = sum(gl);
        kl = (ql'.^(-1)).*gl;
        if l==0
            fl = sum(kl.*ftrain,2)';
            d = ftrain-fl;
            otherdims = repmat({':'},1,ndims(d));
        else
            fl = fl+sum(kl.*d(otherdims{:},l),2)';
            d(otherdims{:},l+1) = ftrain - fl;
        end
        %mse is half mean square error
        err = mse(d(otherdims{:},l+1))*2;
    end
    LP{tfi}=d;
end
d=LP;

filedir = fullfile(savedestination, 'LP_trained.mat');
save(filedir, 'd','sig0','-v7.3');


end

