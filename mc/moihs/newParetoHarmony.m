%% newParetoHarmony: function description
function [x] = newParetoHarmony(dim, max, min)
    x = zeros(1 , dim);
    for j = 1 : dim
        x(j) = doRand(max, min);
    end
