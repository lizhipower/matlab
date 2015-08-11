function [minPloss,BestVamplitude,Network_structure,BestHM, HM, HF, OPL,HMfirst,HFfirst] = main_1(bus_temp)
%函数功能：不考虑任何DG并网以及无功优化时的重构
%clear;
%clc;
%tic;
global bus branch round1 round2 round3 round4 round5
%% 各个环中所包含的开关

round1 = [3 4 5 6 7 8 9 10 69 42 41 40 39 38 37 36 35];
round2 = [11 12 13 14 71 45 44 43 69];
round3 = [13 14 15 16 17 18 19 20 70];
round4 = [9 10 11 12 70 21 22 23 24 25 26 73 64 63 62 61 60 59 58 57 56 55 54 53 52];
round5 = [4 5 6 7 8 52 53 54 55 56 57 58 72 49 48 47 46];
%%
%tic;
%testof33();
HMS = 25;
Dim = 5;
[init_HM,init_OPL] = initial(HMS,Dim);
% pause
[ Best_HM,Best_OPL,Best_HF,Best_V_amplitude, HM, HF, OPL,HMfirst,HFfirst] = HS( bus_temp,init_HM,init_OPL,HMS,Dim);
%toc;
minPloss = Best_HF;
BestVamplitude = Best_V_amplitude;
Network_structure = Best_OPL;
BestHM = Best_HM;




end

