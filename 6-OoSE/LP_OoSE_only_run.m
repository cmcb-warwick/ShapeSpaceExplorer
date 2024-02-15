function [ OoSE_emb ] = LP_OoSE_only_run(trainingCellShapeData, OoSE_dist, path_to_LPtrained, new_unique_savedestination )

load(path_to_LPtrained);
ndims=length(d);

D=OoSE_dist'.^2;

target_func=trainingCellShapeData.set.SCORE;
for n=1:length(d)
[l,~]=size(d{n});
ftrain = target_func(:,n)';
for m=0:l
%for m=0:12
    sig = sig0/(2^m);
    %equation 3.17
    gly = exp(-D/sig);
    qly = sum(gly,2);
    kly = (qly.^(-1)).*gly;
   if m==0
       fy{n} = sum(kly.*ftrain,2)';
   else
        fy{n} = fy{n}+sum(kly.*d{n}(m,:),2)';
   end
end
end

OoSE_emb=fy;

save([new_unique_savedestination '/OoSE_embedding_scaledsig04.mat'], 'OoSE_emb','-v7.3');
end