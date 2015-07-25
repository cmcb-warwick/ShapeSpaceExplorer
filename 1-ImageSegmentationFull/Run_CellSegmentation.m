function  Run_CellSegmentation(  )
out= ConfigPane1;
if ~isfield(out,'files')  
        display('canceled');return; end 
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
if ~isfield(framesConfig,'firstFrame')  
        display('canceled');return; 
end

 
 out=ConfigPane3();
 if ~isfield(out,'folder')  
        display('canceled');return; end 
 display('--> start cell segmentation');
 saveFoler=out.folder;
 msConfig.spatialBdw=out.spatialBdw;
 msConfig.rangeBdw=out.rangeBdw;
 msConfig.minArea=out.minArea;
 
CellSegmentation(files, framesConfig, msConfig, saveFoler);
display('----- Cell Segmentation finished -----');

