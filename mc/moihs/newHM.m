%% newHM: function description
function [HM, HF] = newHM(dim, max, min, HMS)
    HM = zeros(HMS, dim);
    HF = zeros(HMS, dim);
    x = zeros(1 , dim);
    for i = 1: HMS
        x = zeros(1 , dim);
        for j = 1 : dim
            x(j) = doRand(max, min);
        end
        HM(i , :) = x;
        HF(i , :) = targetFun(x);
    end


