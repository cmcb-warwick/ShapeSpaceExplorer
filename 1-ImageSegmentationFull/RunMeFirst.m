function [ output_args ] = RunMeFirst( index_of_dv_files, firstframe_in_stack, lastframe_in_stack, dv_filepath_reg_exp, savefolderpath  )
%RUNMEFIRST Summary of this function goes here
%
%   index_of_dv_files:- should be a vector containing the of image files 
%   indices that you wish to load
%
%   firstframe_in_stack:- the first frame in the dv file stack that you want
%   to look at, typically this is 1.
%
%   lastframe_in_stack:- the last frame in the dv file stack that you want 
%   to look at, typically this is the last frame in the stack, but you can 
%   optionally import less.
%
%   dv_filepath_reg_exp:- this is a regular expression for the path to find
%   each image file. Typically, this will be: containing folder, most of
%   the file name followed by the regular expression for the index
%   (usually %02d or %03d, depending on the number of files output by the
%   microscope(%02d if numbers don't go past 99, %03d if they go to 100, 
%   %04d if they go to 1000)) and finally the file suffix. For example:
%   '/Desktop/imagefolder/GLA6_010114_exp1_%02d_R3D.dv'
%
%   savefolderpath:- this should be the folder path for where you want
%   everything saved.

sbw=5;% Spatial Bandwidth
rbw=3;% Range Bandwidth

if ~strcmp(savefolderpath(end),'/')
    savefolderpath=[savefolderpath '/'];
end
N=length(index_of_dv_files);%number of .dv files
frame1=firstframe_in_stack;%first frame to take
frameend=lastframe_in_stack; %last frame to take
for i=index_of_dv_files
    varname=sprintf('ImageStack%03d',i);
   filepath=sprintf(dv_filepath_reg_exp,i);
   eval([varname '=imreadBF(filepath,1,frame1:frameend,1);']);
   savefilename=[savefolderpath varname];
   save(savefilename,varname);
   clear(varname);
   
end


for i=index_of_dv_files;
   varname=sprintf('ImageStack%03d',i);
   load(sprintf([savefolderpath 'ImageStack%03d'],i))
   eval(['StackCellSeg(' varname sprintf(', %d, savefolderpath,sbw,rbw);',i) ]);
   clear(varname);
   
end

end

function [ ] = StackCellSeg( ImageStack,Stacknumber,savefolderpath,sbw,rbw)
%STACKCELLSEG Summary of this function goes here
%   Detailed explanation goes here

numframes=size(ImageStack,3);
mF=mean(ImageStack(:));

for i=1:numframes
frame=ImageStack(:,:,i);
im=frame-mean(frame(:))+mF;
anustack(:,:,i)=im;
end

clear('ImageStack');

parfor i=1:numframes
   [Frame_curves{i},Bin_images{i}] =CellSeg(anustack(:,:,i),sbw,rbw);
end



%save('FrameCurves','Frame_curves')

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

save(sprintf([savefolderpath 'ImageStack%03dCurveData'],Stacknumber),'Frame_curves','Cell_numbers')

end


function [ Image_Cell_Regions,Binary_images ] = CellSeg( GRAYimage,sbw,rbw)
%CELLSEG_TEST Summary of this function goes here
%   Detailed explanation goes here


pretendRGBimage=cat(3,GRAYimage,GRAYimage,GRAYimage);
pretendRGBimage=pretendRGBimage/(max(pretendRGBimage(:)));

currentfoldername=cd; 
addpath([currentfoldername '/New_Download/edison_matlab_interface'])
[~, labels,modes] = edison_wrapper(pretendRGBimage,@RGB2Luv, 'SpatialBandWidth',sbw,'RangeBandWidth',rbw);
% tic
% for i=unique(labels(:))'
%      RegionArea(i+1)=bwarea(labels==i);
%  end
%  [~,I]=max(RegionArea);
%  I=I-1;
%  toc
%  tic
%mode_channels=cat(3,modes(1,:),modes(2,:),modes(3,:));
%colours=Luv2RGB(mode_channels);
%colours2=[colours(:,:,1);colours(:,:,2);colours(:,:,3)];
%[~,I2]=min(mean(colours2));
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
