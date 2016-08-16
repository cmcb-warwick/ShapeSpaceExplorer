function [ curve ] = clockcheck( curve )
%CLOCKCHECK Clockcheck returns a curve that is parameterised clockwise.
%curve should be an Mx2 vector 
%   CLOCKCHECK computes the "sign-area" of a closed curve.
% NOTE: Sign-area equals to the area of the closed curve when it is in anti-clockwise and equals to the negative area when it is in clockwise.
%	Negative area means equal to area in magnitude but is negtive in sign.We can see that this script may also be used to judge the direction of a closed curve.
% 
%  AREA returns the area of the curve(>0) when it is anti-clockwise
%  AREA returns the negtive area of the curve(<0) when it is clockwise
%
% modified from VAREA.m wirtten by Kang Zhao(kangzhao@student.dlut.edu.cn) at DLUT,Dalian,China. $Date: 2002/04/17


num = size(curve,1);
x0 = curve(1,1);
y0 = curve(1,2);
area = 0;
c=curve(2,1)-x0;
d=curve(2,2)-y0;
for k=2:num-1
    a=c;
    b=d;
    c=curve(k+1,1)-x0;
    d=curve(k+1,2)-y0;
    area=area+a*d-c*b;
end

if  area>0                 % if curve is anticlockwise
     curve=flipud(curve);
end

end