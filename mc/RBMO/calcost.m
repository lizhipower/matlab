function [ cost ] = calcost( x, gencost )
%CALCOST Summary of this function goes here
%   Detailed explanation goes here

cost=0;
for i=1:size(x,1)
        cost=cost+(gencost(i,5)+gencost(i,6)*x(i)+gencost(i,7)*x(i).^2);
end
