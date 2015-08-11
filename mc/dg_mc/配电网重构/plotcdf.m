function plotcdf(cdf, color)
    cdfPLoadRound1 = roundn(cdf,-2);
    a1 = tabulate(cdfPLoadRound1);
    b1 = [a1(:, 1) a1(:, 3)];
    c1 = sortrows(b1);
    c1(: , 2) = c1(: , 2) ./ sum(c1(: , 2));
    plot(c1(: ,1 ), c1(: , 2), 'Color',color);
end