global bus branch
testof33();

hf = [
    33 11 14 26 29;
    19 10 12 37 15;
    5 21 14 26 30;
    19 10 34 26 32;
    5 35 34 25 31;
    6 33 12 26 36;
    3 11 13 27 16;
    4 8 14 27 32;
    6 9 14 28 31;
    7 11 13 27 32;
    33 10 34 27 36;
    33 10 34 28 36;
    7 9 14 37 32
    ];
ds = [
    244.37;
    237.99;
    228.13;
    221.17;
    212.00;
    192.70
    189.48;
    169.55;
    156.93;
    149.97;
    148.98;
    145.92;
    139.55
];
loadRslt = [];
for i = 1 : length(hf(:, 1))
    op = ones(1, 37);
    for j = 1 : length(hf(i, :))
        op(hf(i, j)) = 0;
    end
    loadRslt = [loadRslt dsMC(op, bus, branch)]
end
loadRslt = loadRslt';
stem(ds, loadRslt)

