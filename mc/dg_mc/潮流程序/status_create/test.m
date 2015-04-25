       % 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39
       % tic
       global bus branch
% OP = [ 1    1   1   1   1   1   0   1   1   0   1   1   1   0   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   0   0];

% initialLoss 202.67 EENS  2.01
% OP = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,             1, 1, 1, 1, 1, 1, 1, 1, 1, 1,             1, 1, 1, 1, 1, 1, 1, 1, 1, 1,             1, 1, 0, 0, 0, 0, 0];

%  testof33();


% % [ds, v] = powerflow(OP)
% disp('1');
% [loadEEns cdfPLoad] = dsMC(OP, bus);
% loadEEns
% % bar(cdfPLoad)
% doPlot(cdfPLoad)
% hold on;
% middleLoss 147.76 EENS 0.93
% OP = [1 1   1   1   1   1   0   1   1   0   1   1   1   0   1   1   0   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   0];
% middleLoss 147.76 EENS 0.86
% OP = [1 1   1   1   1   1   0   1   1   0   1   1   1   0   1   1   0   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   0];
% disp('2');
% [loadEEns2 cdfPLoad] = dsMC(OP, bus);
% loadEEns2
% bar(cdfPLoad)
% doPlot(cdfPLoad)
% bestLoss 139.56 EENS 1.28
% OP = [ 1, 1, 1, 1, 1, 0, 1, 1, 0, 1,             1, 1, 1, 0, 1, 1, 1, 1, 1, 1,             1, 1, 1, 1, 1, 1, 1, 0, 1, 1,             1, 1, 1, 1, 1, 0, 1];

OP = [ 1, 1, 1, 1, 1, 0, 1, 1, 0, 1,             1, 1, 1, 0, 1, 1, 1, 1, 1, 1,             1, 1, 1, 0, 1, 1, 1, 0, 1, 1,             1, 1, 1, 1, 1, 1, 1];

disp('3');
[loadEEns3 cdfPLoad] = dsMC(OP, bus);
loadEEns3
% bar(cdfPLoad)
% doPlot(cdfPLoad)

% hold off;
% [loadEEns1 cdfPLoad1] = dsMC(OP, bus);
% % loadEEns
% % bar(cdfPLoad)
% cdfPLoadRound1 = roundn(cdfPLoad1,-2);
% a1 = tabulate(cdfPLoadRound1);
% b1 = [a1(:, 1) a1(:, 3)];
% c1 = sortrows(b1);
% c1(: , 2) = c1(: , 2) ./ sum(c1(: , 2));
% plot(c1(: ,1 ), c1(: , 2));

% toc
% 