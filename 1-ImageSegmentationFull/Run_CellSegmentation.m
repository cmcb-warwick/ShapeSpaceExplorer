function  Run_CellSegmentation(  )
out= ConfigPane1;
try if out==-1, display('canceled');return; end 
end
folder = out.folder;
fls = out.files;
maxFrame=inf;
len = length(fls);
files={};
h = waitbar(0,'loading next graphical interface...');
for i = 1:len
    path = fullfile(folder, fls{i});
    files{i}=path;
    metadat = imreadBFmeta(path);
    frames = metadat.nframes;
    maxFrame=min(frames, maxFrame);
    waitbar(i/len, 'loading next graphical interface...');
end
delete(h)
close all force
framesConfig=ConfigPane2(maxFrame);
try if framesConfig==-1, display('canceled');return; end 
end

 
 out=ConfigPane3();
 try if out==-1, display('canceled');return; end
 end
 display('--> start cell segmentation');
 saveFoler=out.folder;
 msConfig.spatialBdw=out.spatialBdw;
 msConfig.rangeBdw=out.rangeBdw;
 
 
RunMeFirst(files, framesConfig, msConfig, saveFoler);
display('----- Cell Segmentation finished -----');

