%% targetFun: function description
function [funRslt] = targetFun(x)
    funRslt1 = fun1(x);
    funRslt2 = fun2(x);
    funRslt = [funRslt1 funRslt2];
