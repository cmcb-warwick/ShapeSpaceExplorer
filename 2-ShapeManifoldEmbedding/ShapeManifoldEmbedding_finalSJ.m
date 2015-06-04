function [ CellShapeData ] = ShapeManifoldEmbedding_finalSJ( Frames, savedestination )
%SHAPEMANIFOLDEMBEDDING Frames must be Nx1 Cell Array, N is your sample 
%size, each cell contains the Mx2 Contour outlines (M can vary), corresponding to closed planar curves 
%savedestination should be a string indicating the path to the desired save destination of the
%output file. Default will be the current folder 
%



%CellShapeData is a structure containing information about the dataset, the Diffusion Maps analysis and intermediate steps.

%The main output of this algorithm is the Diffusion Maps embedding of the contour data (Find this at CellShapeData.set.SCORE or CellShapeData.point(i).SCORE for the DM embedding of ith contour)   

%CellShapeData contains two substructures: set and point. 
    %Fields in the set substructure relate to the whole dataset:
    %CellShapeData.set.Long_D:  A long vector of pairwise BAM distances. Equivalent to symmetric distance matrix D, Long_D is arranged: D(1,2),D(1,3), D(2,3), D(1,4), D(2,4), D(3,4), etc...
    %CellShapeData.set.Vect: Matrix whose columns are eigenvectors (if you have RAM trouble, suppress lines 168&169)
    %CellShapeData.set.Val:  Eigenvalues
    %CellShapeData.set.sig_sq: Value used for kernel bandwidth in similarity measure (median(Long_D))
    %CellShapeData.set.SCORE: Final output, DM representation
    
    %Fields in the point substructure relate to the individual curves:
    %CellShapeData.point(i).coords: the original contour coordinates
    %CellShapeData.point(i).coords_interp: interpolated and rescaled coordinates
    %CellShapeData.point(i).original_curve_length: length of original contour
    %CellShapeData.point(i).coords_interp_trans: translated coordinates
    %CellShapeData.point(i).coords_comp: complex coordinate version of contour
    %CellShapeData.point(i).sum_curve: the sum of the squares of the absolute values of the complex coordinates
    %CellShapeData.point(i).fft_conj: the fast fourier transform of the complex conjugate of the coordinates
    %CellShapeData.point(i).fft_flip: the fast fourier transform of the coordinates in reverse order
    %CellShapeData.point(i).SCORE: Final output, DM representation of contour i
    
if ~exist('savedestination','var')
    savedestination=pwd;
end
%number of cells
N=length(Frames);
%waitbar
h = waitbar(0,'Please wait...');
w=0;
waitbar(0,h,sprintf('%5.2f%% completed ..',0));

for i=1:N
    Frames{i}=clockcheck(Frames{i});
end

nodes=512; %This selects the number of vertices for the contours, BAM runs quicker if it's a power of 2.

for i=1:N
    CellShapeData.point(i).coords=Frames{i};
end
%%interpolation
%stack={CellShapeData.point.coords}';
[snakematrix, lengthvec ]=Interpolate_and_rescale(Frames,h,nodes); 
for i=1:N
    CellShapeData.point(i).coords_interp=snakematrix(:,i);
    CellShapeData.point(i).original_curve_length=lengthvec(i);
end

%translate shapes to origin
for i=1:N
    f=CellShapeData.point(i).coords_interp;
    Xf=f(1:nodes);
    Yf=f((nodes+1):end);
    cXf=mean(Xf);
    cYf=mean(Yf);
    CellShapeData.point(i).coords_interp_trans=[(Xf-cXf) ; (Yf-cYf)];
end

%convert to complex representation
for i=1:N
    compvec_temp=CellShapeData.point(i).coords_interp_trans(1:nodes) + 1i*CellShapeData.point(i).coords_interp_trans((nodes+1):end);
    CellShapeData.point(i).coords_comp = compvec_temp(:);
end
    
%diffusion map embedding
new_d=5; %Increase this to generate more new dimensions
CellShapeData=BAM_DM_frame(CellShapeData, new_d,h,nodes);

waitbar((1)/(1),h,sprintf('Complete'));
save([savedestination '/CellShapeData.mat'], 'CellShapeData', '-v7.3');

CellShapeData_slim  = slimCellShapeData( CellShapeData );
clear CellShapeData;
CellShapeData =CellShapeData_slim;
save([savedestination '/CellShapeData_med.mat'], 'CellShapeData', '-v7.3');

CellShapeData_slim  = slimCellShapeData( CellShapeData, 1 );
clear CellShapeData;
CellShapeData =CellShapeData_slim;
save([savedestination '/CellShapeData_slim.mat'], 'CellShapeData', '-v7.3');

close(h);
end

function [ snakemat,lengthvec ] = Interpolate_and_rescale(stack ,h, varargin)
%INTERPOLATE takes a stack of cell outline coords and generates a matrix,
%where each column 600(*) values (300 x-coords followed by 300 y-coords).
%(*) The optional input allows specification of this number.
% h is a handle for a waitbar

nodes=300;

in = size(varargin,2);

if(in == 0),
elseif(in == 1),
    nodes = varargin{1,1};
end

N=size(stack,1);%number of frames
snakemat=zeros(2*nodes,N);%initialise new cell of outline frames


for i=1:N;
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
    waitbar(i/(N),h,sprintf('Step 1. Interpolation: %5.2f%% completed ..',i*100/(N)));
end

end

function [Frame] = BAM_DM_frame(Frame, no_dims,h ,nodes)
%DM Takes some data X, where rows correspond to observations and columns to
%variables and performs a diffusion map embedding, where the similarity
%between x and y is the Gaussian kernel of Best Alignment Metric (BAM) between x and y.
%with sigma chosen to be mean BAM score.
%   Detailed explanation goes here

nobs=size(Frame.point,2);%number of observations


for i=1:nobs
    curve=Frame.point(i).coords_comp;
    Frame.point(i).sum_curve = sum(real(curve).^2+imag(curve).^2);
    Frame.point(i).fft_conj=fft(conj(curve));
    Frame.point(i).fft_flip=fft(flipud(curve));
end

N=nobs*(nobs-1)/2;

%Distance matrix
D=zeros(nobs,nobs);
d=zeros(N,1);
k=1;
for j=2:nobs
    for i=1:(j-1)
        D(i,j)=BAM(Frame.point(i).sum_curve,Frame.point(j).sum_curve,Frame.point(i).fft_conj,Frame.point(j).fft_flip);
        D(j,i)=D(i,j);
        d(k)=D(i,j);
        k=k+1;
    end
    p=j*(j-1)/2;
    waitbar(p/N,h,sprintf('Step 2. Computing distances: %5.2f%% completed ..',100*p/N));
    
end
waitbar(1,h,'Step 3. Embedding, please wait.');
D=D./(sqrt(nodes));
d=d./(sqrt(nodes));
sig_sq=median(d);
Frame.set.Long_D=d;
clear('d')

%distance to similarity
D=D.^2;
D=D/(2*sig_sq);
D=-D;
D=exp(D);

%Normalise matrix (including Laplace-Beltrami Normalisation)
d=sum(D);
d_inv_root=d.^(-1/2);
for i=1:nobs
    D(i,:)=d_inv_root(i)*D(i,:);
end
for i=1:nobs
    D(:,i)=d_inv_root(i)*D(:,i);
end


%Find eigenvectors (V) and values (D)
[Vect,Val]=eig(D); %With large matrices this can be very slow, consider using sparse eigendecomp (eigs, as below) instead.
%[Vect,Val]=eigs(D,(no_dims+1));

Frame.set.Vect=Vect; %With large matrices you might want to suppress this as it will take a lot of RAM
Frame.set.Val=diag(Val);  %ditto
Frame.set.sig_sq=sig_sq;
[~, ind] = sort(abs(diag(Val)), 'descend');
Val=diag(Val);
Val=Val(ind);

phi_min = Vect(:,ind(2:(no_dims+1)));
Val_min = Val(2:(no_dims+1));
for i=1:no_dims
    phi_min(:,i)=d_inv_root'.*phi_min(:,i);
end
% Normalize eigenvectors by their eigenvalue to obtain embedding
SCORE = phi_min .* repmat((Val_min)', [size(phi_min,1) 1]);
Frame.set.SCORE=SCORE;
for i=1:nobs
    Frame.point(i).SCORE=SCORE(i,:);
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
%   Detailed explanation goes here
%CLOCKCHECK Summary of this function goes here
%   Detailed explanation goes here

a=curve(1,1)+1i*curve(1,2);
b=curve(2,1)+1i*curve(2,2);
x=0.5*(a*(1-0.5*1i)+b*(1+0.5*1i));

anticlockwise=inpolygon(real(x),imag(x),curve(:,1),curve(:,2));

if anticlockwise
    curve=flipud(curve);
end

end