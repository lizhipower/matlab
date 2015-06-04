r = 300;
a1 = 50;
a2 = 2;
sigma1 = 0.4*  r;
sigma2 = 0.05 * r;
vd = 30;
a = 11;
b =-18;
x= 0;
y= 0;
xlist = [];
ylist = [];
vlist = [];
xlist = linspace(0,150, 1000);
ylist = linspace(0,150, 1000);
% [xlist, ylist] = meshgrid(x,y);
for i= 1: length(xlist)
    for j = 1 : length(ylist)
        x = xlist(i);
        y = ylist(j);
v =  (a1 * exp(-(x ^ 2 + y ^ 2) / (2 *sigma1^2))  - a2 * exp(-(x ^ 2 + y ^ 2) / (2* sigma2^2) ));
vlist(i,j) = v;

p(i,j) = exp(11 * v /30 -18);
% if (p(i,j)  < 5e-1)
%     p(i,j)  = 0;
% end


end
end
% vlist
mesh (xlist, ylist, p);