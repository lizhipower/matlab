function [minPloss,BestVamplitude,Network_structure,BestHM, OPL, HF, DSrslt, MCrslt] = main_1(bus_temp)
%函数功能：不考虑任何DG并网以及无功优化时的重构
%clear;
%clc;
%tic;
global bus branch round1 round2 round3 round4 round5
%% 各个环中所包含的开关
round1=[2 3 4 5 6 7 33 20 19 18];%10
round2=[8 9 10 11 35 21 33];%7
round3=[34 14 13 12 11 10 9];%7
round4=[22 23 24 37 28 27 26 25 5 4 3];%11
round5=[25 26 27 28 29 30 31 32 36 17 16 15 34 8 7 6];%16
%% 
%tic;
%testof33();
disp('initial');
[init_HM,init_OPL] = initial(15,5);

disp('HS');
[ Best_HM ,Best_OPL, Best_HF, Best_V_amplitude, OPL, HF, DSrslt, MCrslt] = HS( bus_temp,init_HM,init_OPL,15,5);
%toc;
minPloss = Best_HF;
BestVamplitude = Best_V_amplitude;
Network_structure = Best_OPL;
BestHM = Best_HM;




end

