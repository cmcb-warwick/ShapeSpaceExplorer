function [ OoSE_emb ] = LP_OoSE_run(trainingCellShapeData, OoSE_frames, path_to_LPtrained, path_to_dist, new_unique_savedestination )
%LAPLACIANPYRAMIDS_OOSE Summary of this function goes here
%   Detailed explanation goes here
%trainingCellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code of your training data.

%OoSE_frames should be your segmented cells from your out of sample data
%set, this is called BigCellArray and can found Bigcellarrayandindex.mat in
%your contour output folder from 1-ImageSegmentationFull

%LP_OoSE_train should be run before this one, path_to_LPtrained should be
%the path to its output

%new_unique_savedestination should be a path to a chosen folder. N.b. any
%repeated runs of this code to the the same destination will over-write
%previous runs.
%

DIST= load(bPath);
load(path_to_LPtrained);
ndims=length(d);

dist2=DIST.D'.^2;

OoSE_emb=[];
target_func=trainingCellShapeData.set.SCORE;
for n=1:length(d)
    [l,~]=size(d{n});
    ftrain = target_func(:,n)';
    for m=0:l
        %for m=0:12
        sig = sig0/(2^m);
        %equation 3.17
        gly = exp(-dist2/sig);
        qly = sum(gly,2);
        kly = (qly.^(-1)).*gly;
        if m==0
            fy{n} = sum(kly.*ftrain,2)';
        else
            fy{n} = fy{n}+sum(kly.*d{n}(m,:),2)';
        end
    end
    OoSE_emb=[OoSE_emb;fy{n}];
end

OoSE_emb=OoSE_emb';

save([new_unique_savedestination '/OoSE_embedding.mat'], 'OoSE_emb','-v7.3');
h=waitbar(1,h,'Complete');
delete(h);

end
