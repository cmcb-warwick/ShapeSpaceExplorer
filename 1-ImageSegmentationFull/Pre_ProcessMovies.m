function  Pre_ProcessMovies(  )
% out= ConfigPane1;
% folder = out.folder;
% files = out.files;
folder='/Users/iasmam/Desktop/Sam_Project/DV_Files/';
files ={'GLA6_siKif1C45_siCon88_54hRNAi_exp1_08_R3D.dv'};
maxFrame=1;
for i = 1:length(files)
    path = fullfile(folder, files{i});
    metadat = imreadBFmeta(path);
    frames = metadat.nframes;
    maxFrame=max(frames, maxFrame);
end

display('Now we know max frames:');
display(maxFrame)

