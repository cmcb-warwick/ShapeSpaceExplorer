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

N=length(stack);%number of frames
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