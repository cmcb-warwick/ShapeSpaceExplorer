function  Pre_ProcessMovies(  )
out= ConfigPane1;
display(out);
folder = out.folder;
files = out.files;
maxFrame=inf;
len = length(files);
h = waitbar(0,'loading next graphical interface...');
for i = 1:len
    path = fullfile(folder, files{i});
    metadat = imreadBFmeta(path);
    frames = metadat.nframes;
    maxFrame=min(frames, maxFrame);
    waitbar(i/len, 'loading next graphical interface...');
end
delete(h)
close all force
 display('after first gui ')
outConfig2=ConfigPane2(maxFrame);
 display(outConfig2);

