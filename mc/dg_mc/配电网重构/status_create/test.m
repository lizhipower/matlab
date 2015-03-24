%        1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39
% OP = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,             1, 1, 1, 1, 1, 1, 1, 1, 1, 1,             1, 1, 1, 1, 1, 1, 1, 1, 1, 1,             1, 1, 0, 0, 0, 0, 0];

% OP = [ 1, 1, 1, 1, 1, 0, 1, 1, 0, 1,             1, 1, 1, 0, 1, 1, 1, 1, 1, 1,             1, 1, 1, 1, 1, 1, 1, 0, 1, 1,             1, 1, 1, 1, 1, 0, 1];

testof33();


% [ds, v] = powerflow(OP)

% HM = [ 7, 10, 14, 37, 36 ];
% initial
HMa = [ 33, 34, 35, 36, 37 ];
% best without MC
HMb = [ 7, 9, 14, 32, 37 ]; 
% best with MC
HMc = [ 7, 11, 14, 28, 32 ];

HM = [HMa; HMb; HMc];
loadRslt = zeros(1,3);
DS = zeros(1, 3);
V = zeros(1, length(bus(:, 1)) + 2);

for i = 1: 3
    disp(i);

    OP = createOP(HM(i, :));

    [ds, v ] = powerflow(bus , OP);
    DS = [DS ds];
    V = [V; v];
    loadRslt(i) = dsMC(OP, bus) * 1e4;
end

bar(loadRslt)

% 