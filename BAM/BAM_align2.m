function [ d, R,phi ] = BAM_align2( A,B )
%BAM_ALIGN2 Presents an illustration of what BAM does to a pair of curves
%that must be Mx2 (M can be different for A and B).
%   Detailed explanation goes here
st_A=Interpolate5(A); %Interpolate curves to standardise number of points on the curve and introduce arclength parameterisation
st_B=Interpolate5(B);
complex_A=comp_prep_z(st_A); %convert to complex representation and translate to origin
complex_B=comp_prep_z(st_B);

[d,R,phi]=BAMout( complex_A , complex_B ); %perform BAM alignment, d is the shape difference measured, R is the best index shift, phi is the best planar rotation.
rotated_A=exp(1i*phi)*complex_A;
rotated_and_cycled_A=rotated_A([(1+R):end 1:R]);

figure
subplot(2,2,1) 
plot(A(:,1),A(:,2)) %plot original A
hold on
plot(A(:,1),A(:,2),'x','MarkerSize',5) %plot x at ticks
plot(A(1,1),A(1,2),'.','MarkerSize',30) %Mark the first point
axis equal
subplot(2,2,2)
plot(B(:,1),B(:,2),'r') %plot original B
hold on
plot(B(:,1),B(:,2),'rx','MarkerSize',5) %plot x at ticks
plot(B(1,1),B(1,2),'r.','MarkerSize',30) %Mark the first point
axis equal
subplot(2,2,3)
plot(complex_B,'r') %plot complex B
hold on
plot(complex_B,'rx','MarkerSize',5)
plot(complex_B(1),'r.','MarkerSize',30)
plot(rotated_A) %plot optimally rotated A
plot(rotated_A,'x','MarkerSize',5)
plot(rotated_A(1),'.','MarkerSize',30)
axis equal
subplot(2,2,4)
plot(complex_B,'r') %plot complex B
hold on
plot(complex_B,'rx','MarkerSize',5)
plot(complex_B(1),'r.','MarkerSize',30)
plot(rotated_and_cycled_A) %plot optimally rotated and cyclically reordered A
plot(rotated_and_cycled_A,'x','MarkerSize',5)
plot(rotated_and_cycled_A(1),'.','MarkerSize',30)
axis equal

end

function [ comp_curve_trans ] = comp_prep_z( curve )
%comp_prep_z curve must be Nx2


comp_curve=curve(:,1)+1i*curve(:,2);
cf=mean(comp_curve);
comp_curve_trans=comp_curve-cf;


end

function [ d, R,phi ] = BAMout( u , v )
%CURVEMETRIC rapidly computes the distance between curves u & v in the
%plane. u & v are 1xN complex vectors
%   Detailed explanation goes here
u=u(:);
v=v(:);
sum_u = sum(real(u).^2+imag(u).^2);
sum_v = sum(real(v).^2+imag(v).^2);
v_temp=flipud(v);
Xcorr=ifft(fft(conj(u)).*fft(v_temp));

Xcorr2=abs(Xcorr);
[A,I]=max(Xcorr2);
phi=atan2(imag(Xcorr(I)),real(Xcorr(I)));
R=I-1;
d=sqrt(sum_u + sum_v - 2*A);
end

function [ snakeout ] = Interpolate5(snake , varargin)
%INTERPOLATE takes a stack of cell outline coords and generates a matrix,
%where each column 600 values (300 x coords followed by 300 y coords).

nodes=300;

in = size(varargin,2);

if(in == 0),
elseif(in == 1),
    nodes = varargin{1,1};
end

%N=size(stack,1);%number of frames
%snakemat=zeros(2*nodes,N);%initialise new cell of outline frames
snakeout=zeros(2*nodes,1);

%for i=1:N;
    %L=length(stack{i}(:,1))+1;%old number of nodes plus one to plug the hole
    dx=[snake(2:end,1); snake(1,1)]-snake(:,1);
    dy=[snake(2:end,2); snake(1,2)]-snake(:,2);
    dl=sqrt(dx.^2 + dy.^2);%euclidean distance between nodes
    P=[0; cumsum(dl)];%old node indices
    k=(P(end))/nodes;%new interval for interpolation vector
    newP=(0:k:P(end))';%new node indices
    x=[snake(:,1); snake(1,1)];%old node Xcoords
    y=[snake(:,2); snake(1,2)];%old node Ycoords
    %patch (because diff(v)~=0 never includes v(end), for a vector v)
    xend=x(end); yend=y(end); Pend=P(end);
    x=x(diff(P)~=0); y=y(diff(P)~=0);P=P(diff(P)~=0);%remove repeated nodes
    x=[x; xend]; y=[y; yend]; P=[P; Pend];
    Xi=interp1(P,x,newP,'spline');%new node Xcoords
    Yi=interp1(P,y,newP,'spline');%new node Ycoords
    snakeout=[Xi(1:nodes) Yi(1:nodes)];
    
%end

end