%% mEuler: function description
function [outputs] = mEuler(arg)
    outputs = 0;
    syms x;
    syms t;
    f(x,t) = 2*t;

    x = [];
    x(1) = 0;
    h = 0.001;
    t = 0;
    xtemp = 0;


    for i = 1:1:1000
        grad_0 = f(x(i),t);
        xtemp = x(i) +  grad_0* h;
        t = t + h;
        grad_1 = ( f(xtemp,t) - grad_0 ) / 2;
        x(i+1) = xtemp + grad_1*h;
    end

    xaxis = 0:0.001:1;
    yaxis = x;
    plot(xaxis,yaxis);