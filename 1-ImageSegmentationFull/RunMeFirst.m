%function   RunMeFirst( index_of_dv_files, firstframe_in_stack, lastframe_in_stack, dv_filepath_reg_exp, savefolderpath  )
function RunMeFirst(files, framesConfig, msConfig, savefolderpath)
%RUNMEFIRST Summary of this function goes here
%
%   files:- a cell array with the path of movies you wish to load
%
%   framesConfig if of the following fomrat.
%   framesConfig.subSet: if this is 1, then only a subset of all movies
%   will be processed, otherwise, complete movies will be processed.
%   frame.Config.startFrame, frame.Config.lastFrame indicate from where
%   wo where the subset has to processed.
%
%   msConfig is a structure with two elements
%   msConfig.spatialBdw: is the spatial bandwith of the mean shift algo
%   msConfig.rangeBdw:   is the range bandwith of the mean shift algo
%   
%
%   savefolderpath:- this should be the folder path for where you want
%   everything saved.




N=length(files);%number of .dv files
allFrameNum=0;
for i=1:N
   stackName=sprintf('ImageStack%03d.mat',i);
   if framesConfig.subSet 
        stack =imreadBF(files{i},1,framesConfig.firstFrame:framesConfig.lastFrame,1);
        allFrameNum=allFrameNum+(framesConfig.lastFrame-framesConfig.firstFrame+1);
   else
       metadat = imreadBFmeta(files{i});
       framesN = metadat.nframes;
       stack=imreadBF(files{i},1,1:framesN,1); %path, z-plane, t-stack, channel
       allFrameNum=allFrameNum+framesN;
   end
   savefilename=fullfile(savefolderpath, stackName);
   save(savefilename,converVar2Str(stack),'-v7.3');
end

h = waitbar(0,['0 frames of ' num2str(allFrameNum) ' frames segmented.']);
currentFrame=1;
for i=1:N;
   varname=sprintf('ImageStack%03d.mat',i);
   in=load(fullfile(savefolderpath, varname));
   currentFrame=StackCellSeg(in.stack, i, savefolderpath, msConfig.spatialBdw,msConfig.rangeBdw, currentFrame, allFrameNum);
end
delete(h)
close all force
end

function cFrame = StackCellSeg( ImageStack,Stacknumber,savefolderpath,sbw,rbw, currentFrame, allFramNum)
%STACKCELLSEG Summary of this function goes here
%   Detailed explanation goes here
numframes=size(ImageStack,3);
mF=mean(ImageStack(:));
cFrame=currentFrame;
for i=1:numframes
frame=ImageStack(:,:,i);
im=frame-mean(frame(:))+mF;
anustack(:,:,i)=im;
end

clear('ImageStack');


for i=1:numframes
   [Frame_curves{i},Bin_images{i}] =CellSeg(anustack(:,:,i),sbw,rbw);
   msg =[ num2str(cFrame) ' frames of ' num2str(allFramNum) ' frames segmented.'];
   if cFrame==1, msg =[ num2str(currentFrame) ' frame of ' num2str(allFramNum) ' frames segmented.'];end   
   waitbar(cFrame/allFramNum, msg);
   cFrame=cFrame+1;
end





Cell_numbers{1}=1:length(Frame_curves{1});
j=length(Frame_curves{1})+1;
for i=2:numframes
    Cell_numbers{i}=zeros(1,length(Frame_curves{i}));
    for k=1:length(Frame_curves{i})
        frame=Bin_images{i}{k};
        pixels=sum(frame(:));
        %centre=mean(curve);
        
        for m=1:length(Frame_curves{i-1})
            overlap=frame.*Bin_images{i-1}{m};
            %if inpolygon(centre(1),centre(2),Frame_curves{i-1}{m}(:,1),Frame_curves{i-1}{m}(:,2))
            if sum(overlap(:))>0.40*pixels
                Cell_numbers{i}(k)=Cell_numbers{i-1}(m);
            end
        end
        
        if Cell_numbers{i}(k)==0
            Cell_numbers{i}(k)=j;
            j=j+1;
        end
    end
    
    %Remove repeats
    X=Cell_numbers{i};
    Y = arrayfun(@(x) {x find(X==x)},unique(X),'Un',0);% Y{n}{1} is the nth unique element Y{n}{2} is a vector containing all the positions of Y{n}{1}
    for k=1:length(Y)
        if length(Y{k}{2})>1
            for m=Y{k}{2}
                Cell_numbers{i}(m)=j;
                j=j+1;
            end
        end
    end
end

filename=sprintf('ImageStack%03dCurveData.mat', Stacknumber);
path = fullfile(savefolderpath, filename);
save(path,'Frame_curves','Cell_numbers','-v7.3')

end


function [ Image_Cell_Regions,Binary_images ] = CellSeg( GRAYimage,sbw,rbw)
%CELLSEG_TEST Summary of this function goes here
%   Detailed explanation goes here


pretendRGBimage=cat(3,GRAYimage,GRAYimage,GRAYimage);
pretendRGBimage=pretendRGBimage/(max(pretendRGBimage(:)));


cPath=mfilename('fullpath');
[currentfoldername,~,~] = fileparts(cPath);
addpath(fullfile(currentfoldername, '/New_Download/edison_matlab_interface'));
[~, labels,modes] = edison_wrapper(pretendRGBimage,@RGB2Luv, 'SpatialBandWidth',sbw,'RangeBandWidth',rbw);
M=max(labels(:));
for i=1:(M+1)
sizes(i)=sum(sum(labels==(i-1)));
end
I2=find(sizes>122500);
I2=I2-1;
%toc
%I2==I

BINimage=~ismember(labels,I2);
CLOSEDimage=imclose(BINimage,strel('disk',3));
LARGE_REGIONSimage=bwareaopen(CLOSEDimage,10);

newlabels=bwlabel(LARGE_REGIONSimage,8);




regionlist=unique(newlabels(:));
InteriorRegion=true(size(regionlist));
BorderMask=false(size(GRAYimage));
BorderMask(1,:)=true;
BorderMask(end,:)=true;
BorderMask(:,1)=true;
BorderMask(:,end)=true;

for i=regionlist'
    regionmask=newlabels==i;
    Exterior=logical(sum(sum(BorderMask.*regionmask)));
    if Exterior
        InteriorRegion(regionlist==i)=false;
    end
end

Image_Cell_Regions={};
Binary_images={};
for i=regionlist(InteriorRegion)'
    regionmask=newlabels==i;
    nuregionmask=imdilate(regionmask, [0 1 0; 1 1 1; 0 1 0]);
    bound=bwboundaries(nuregionmask,8,'noholes');
    Image_Cell_Regions{end+1}=bound{1};
    Binary_images{end+1}=nuregionmask;
end


end


function out = converVar2Str(var)
  out = char(inputname(1));
end
