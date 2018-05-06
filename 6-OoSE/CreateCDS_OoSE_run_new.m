function CreateCDS_OoSE_run_new(scores, OoSE_fra, OoSECellDataStruct, new_unique_savedestination)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OoSE_frames =OoSE_fra.BigCellArray;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=length(OoSE_frames);
%waitbar
 h = waitbar(0,'Please wait...');
 waitbar(0,h,sprintf('%5.2f%% completed ..',0));

for i=1:N
    OoSE_frames{i}=clockcheck(OoSE_frames{i});
end

nodes=512; %This selects the number of vertices for the contours, BAM runs quicker if it's a power of 2.
for i=1:N
    CSD.point(i).coords=OoSE_frames{i};
end
%%interpolation
%stack={CellShapeData.point.coords}';
[snakematrix, lengthvec ]=Interpolate_and_rescale(OoSE_frames,h,nodes); 
delete(h);
for i=1:N
    CSD.point(i).coords_interp=snakematrix(:,i);
    CSD.point(i).original_curve_length=lengthvec(i);
end

%translate shapes to origin
for i=1:N
    f=CSD.point(i).coords_interp;
    Xf=f(1:nodes);
    Yf=f((nodes+1):end);
    cXf=mean(Xf);
    cYf=mean(Yf);
    CSD.point(i).coords_interp_trans=[(Xf-cXf) ; (Yf-cYf)];
end

%convert to complex representation
for i=1:N
    compvec_temp=CSD.point(i).coords_interp_trans(1:nodes) + 1i*CSD.point(i).coords_interp_trans((nodes+1):end);
    CSD.point(i).coords_comp = compvec_temp(:);
end
    
%diffusion map embedding
%new_d=5; %Increase this to generate more new dimensions

% for i=1:N
%     curve=CSD.point(i).coords_comp;
%     CSD.point(i).sum_curve = sum(real(curve).^2+imag(curve).^2);
%     CSD.point(i).fft_conj=fft(conj(curve));
%     CSD.point(i).fft_flip=fft(flipud(curve));
% end
% 
% 
% train_nobs=length(trainingCellShapeData.point);
% D=zeros(train_nobs,N);
% for i=1:train_nobs
%     for j=1:N
%         D(i,j)=BAM(trainingCellShapeData.point(i).sum_curve,CSD.point(j).sum_curve,trainingCellShapeData.point(i).fft_conj,CSD.point(j).fft_flip);
%     end
%     waitbar(i/N,h,sprintf('OoSE Step 2. Computing distances: %5.2f%% completed ..',100*i/N));
%     
% end


% OoSE_CellShape=[];
% 
% L=length(OoSE_frames);
% OoSE_CellShape=scores.OoSE_emb(1,:);
% %cell_indices=ones(length(BigCellDataStruct(1).Contours),1);
% for i=2:L
%     OoSE_CellShape = [OoSE_CellShape; scores.OoSE_emb(i,:)];
%     %BigCellArray=[BigCellArray; BigCellDataStruct(i).Contours'];
%     %cell_indices=[cell_indices; i*ones(length(BigCellDataStruct(i).Contours),1)];
% end


%OoSE_CellShape=struct();

OoSE_CellShape=struct('OoSE_SCORES',[scores.OoSE_emb],'OoSE_coords_comp',[CSD.point.coords_comp],'OoSE_cellindices',[OoSE_fra.cell_indices],'OoSE_CellDataStruct',[OoSECellDataStruct.BigCellDataStruct]);
% OoSE_CellShape.point.SCORE=struct();
% OoSE_CellShape.point.coords_comp=struct();
% OoSE_CellShape.point.SCORE=scores.OoSE_emb;
% OoSE_CellShape.point.coords_comp=CSD.point.coords_comp;

h = waitbar(0,'Please wait...');
 save([new_unique_savedestination '/OoSE_CellShape.mat'], 'OoSE_CellShape','-v7.3');
 h=waitbar(1,h,'Complete');
 delete(h);













end


function [ snakemat,lengthvec ] = Interpolate_and_rescale(stack ,h, varargin)
%INTERPOLATE takes a stack of cell outline coords and generates a matrix,
%where each column 600(*) values (300 x-coords followed by 300 y-coords).
%(*) The optional input allows specification of this number.
% h is a handle for a waitbar

nodes=300;

in = size(varargin,2);

if(in == 0)
elseif(in == 1)
    nodes = varargin{1,1};
end

N=size(stack,1);%number of frames
snakemat=zeros(2*nodes,N);%initialise new cell of outline frames


for i=1:N
    %L=length(stack{i}(:,1))+1;%old number of nodes plus one to plug the hole
    dx=[stack{i}(2:end,1); stack{i}(1,1)]-stack{i}(:,1);
    dy=[stack{i}(2:end,2); stack{i}(1,2)]-stack{i}(:,2);
    dl=sqrt(dx.^2 + dy.^2);%euclidean distance between nodes
    P=[0; cumsum(dl)];%old node indices
    lengthvec(i)=P(end);
    k=(P(end))/nodes;%new interval for interpolation vector
    newP=(0:k:P(end))';%new node indices
    x=[stack{i}(:,1); stack{i}(1,1)];%old node Xcoords
    y=[stack{i}(:,2); stack{i}(1,2)];%old node Ycoords
    %patch (because diff(v)~=0 never includes v(end), for a vector v)
    xend=x(end); yend=y(end); Pend=P(end);
    x=x(diff(P)~=0); y=y(diff(P)~=0);P=P(diff(P)~=0);%remove repeated nodes
    x=[x; xend]; y=[y; yend]; P=[P; Pend];
    x=x/lengthvec(i); y=y/lengthvec(i); %%THIS IS THE SCALE %STANDARDISATION STEP 
    Xi=interp1(P,x,newP,'spline');%new node Xcoords
    Yi=interp1(P,y,newP,'spline');%new node Ycoords
    snakemat(:,i)=[Xi(1:nodes); Yi(1:nodes)];
 
    waitbar(i/(N),h,sprintf('OoSE Step 1. Interpolation: %5.2f%% completed ..',i*100/(N)));
end

end


function [ d ] = BAM( sum_u, sum_v,fft_conj_u, fft_flip_v )
%CURVEMETRIC rapidly computes the distance between curves u & v in the
%plane. u & v are 1xN complex vectors
Xcorr=ifft(fft_conj_u.*fft_flip_v);
Xcorr=abs(Xcorr);
A=max(Xcorr);
d=real(sqrt(sum_u + sum_v - 2*A));
end

function [ curve ] = clockcheck( curve )
%CLOCKCHECK Clockcheck returns a curve that is parameterised clockwise.
%curve should be an Mx2 vector 

a=curve(1,1)+1i*curve(1,2);
b=curve(2,1)+1i*curve(2,2);
x=0.5*(a*(1-0.5*1i)+b*(1+0.5*1i));

anticlockwise=inpolygon(real(x),imag(x),curve(:,1),curve(:,2));

if anticlockwise
    curve=flipud(curve);
end

end










% 
% %Put me in your contour output folder from CSG
% clear all
% folder = uigetdir(matlabroot,'Select Analysis Folder');
% dirData=dir( fullfile(folder,'CellFrameData*.mat') );
% dirIndex = [dirData.isdir];  %# Find the index for directories
% fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
% if ~isempty(fileList)
%     fileList = cellfun(@(x) fullfile(folder,x),...  %# Prepend path to files
%     fileList,'UniformOutput',false);
% end
% N = length(fileList);
% if N<1, error('No Files found in Analysis folder, stopped without processing');
%     exit(0); end
% 
% BigCellDataStruct=[];
% for i=1:N
%     load(char(fileList(i)));
%     if ~isempty(fieldnames(CellFrameData))
%         BigCellDataStruct=[BigCellDataStruct, CellFrameData];
%     end
% clear('CellFrameData')
% end
% 
% sFile = fullfile(folder, 'BigCellDataStruct.mat');
% save( sFile, 'BigCellDataStruct', '-v7.3');
% 
% 
% 
% L=length(BigCellDataStruct);
% BigCellArray=BigCellDataStruct(1).Contours';
% cell_indices=ones(length(BigCellDataStruct(1).Contours),1);
% for i=2:L
%     BigCellArray=[BigCellArray; BigCellDataStruct(i).Contours'];
%     cell_indices=[cell_indices; i*ones(length(BigCellDataStruct(i).Contours),1)];
% end
% 
% sFile = fullfile(folder, 'Bigcellarrayandindex.mat');
% save(sFile, 'BigCellArray', 'cell_indices', '-v7.3');
% 
% display('Program finished as expected')