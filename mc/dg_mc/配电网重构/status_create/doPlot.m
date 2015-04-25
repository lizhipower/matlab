%% doPlot: function description
function [cdf] = doPlot(cdfPLoad)
    cdfPLoadRound = roundn(cdfPLoad,-3);
    a = tabulate(cdfPLoadRound);
    b = [a(:, 1) a(:, 3)];
    c = sortrows(b);
    c(: , 2) =c(: , 2) ./ sum(c(: , 2));
    c(: , 2) = 1 - cumsum(c(: , 2));
    plot(c(: ,1 ), c(: , 2));
