function [ d, q, sig_naught ] = LP_OoSE_train(trainingCellShapeData, savedestination)
%LAPLACIANPYRAMIDS Summary of this function goes here
%   Detailed explanation goes here

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



dims=size(target_func,2);

for m=1:dims
    f=target_func(:,m);
    f=f';
    Err=1;
    l=-1;

    
    while abs(Err)>Adm_Err
        l=l+1;
        %    [num,l]
        %     clear('D')
        %     load(D_path)

        sig=sig_naught/(2^l);
        D2=D.^2;
        %   D2=D;
        D2=D2./sig;
        D2=-D2;
        D2=exp(D2);
        q{m}{l+1}=sum(D2);
        Q=q{m}{l+1}.^(-1);
        for i=1:nobs
            D2(i,:)=Q(i)*D2(i,:);
        end;
        clear('Q')
        if l==0;
            d_l=f;
        else
            d_l=d{m}{l}-s_l;
        end
        s_l=d_l*D2;
        d{m}{l+1}=d_l;
        Err=norm(d_l-s_l);
    end
    
    
end
filedir = fullfile(savedestination, 'LP_trained.mat');
save(filedir, 'd','q','sig_naught','-v7.3');


end

