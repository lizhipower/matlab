function [minPloss,BestVamplitude,Network_structure,BestHM, HM, HF, OPL,HMfirst,HFfirst] = main_1(bus_temp)

%clear;
%clc;
%tic;
global bus branch round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 round11 round12 round13 round14 round15


round1 = [3 28  29  3-9  38  39  40  41  42  43  4-6  4-7  1--18 26  25  24  23  22  21  20  19  18  17  10  9];
round2 = [11  12  13  14  15  16  1--19 26  25  24  23  22  21  20  19  18  17];
round3 = [3  4  5  6  7  1--20 23  22  21  20  19  18  17  10  9];
round4 = [29    30  31  32  33  34  4-8  4-9  5-0  5-1  5-2  5-3  5-4  5-5  1--21 42  41  40  39  38  3-9];
round5 = [29    30  31  32  3-4  3-5  4-8  4-9  5-0  1--22 6-4  6-3  6-2  6-1  6-0  5-9  5-8  5-7];
round6 = [29    35  36  1--23 6-4  6-3  6-2  6-1  6-0  5-9  5-8  5-7];
round7 = [4 5   6   7   8   1--24 39  38  37  28  27];
round8 = [1 3   27  28  5-7  5-8  5-9  6-0  1--25 9-9  9-4  9-3  9-2  6-7  6-6  6-5];
round9 = [6-8    6-9  7-0  7-1  7-2  7-3  7-4  7-5  1--26 9-4  9-3  9-2];
round10 = [6-7   6-8  6-9  7-0  7-1  7-2  7-3  7-4  7-5  7-6  7-7  1--27 9-0  8-9  8-8  8-1  8-0];
round11 = [6-8   6-9  7-0  7-1  7-2  7-3  7-4  7-5  7-6  7-7  7-8  7-9  1--28 1-02 1-01 1-00 9-9  9-4  9-3  9-2];
round12 = [6-5   6-6  8-0  8-1  8-2  8-3  8-4  8-5  1--29 1-12 1-11 1-10 1-09 1-08 1-07 1-06 1-05 1-04];
round13 = [6-5   6-6  8-0  8-1  8-8  1--30 1-09 1-08 1-07 1-06 1-05 1-04];
round14 = [105  1-06 1-07 1-08 1-09 1-10 1-11 1-12 1-13 1-14 1--31 1-22 1-21 1-20 1-19 1-18];
round15 = [9    10  17  18  19  20  21  22  23  24  1--32 3-5  3-4  32  31  30  29  28  27  3];


%% 
%tic;
%testof33();
[init_HM,init_OPL] = initial_119(25,15);

[ Best_HM,Best_OPL,Best_HF,Best_V_amplitude, HM, HF, OPL,HMfirst,HFfirst] = HS_119( bus_temp,init_HM,init_OPL,25,15);
%toc;
minPloss = Best_HF;
BestVamplitude = Best_V_amplitude;
Network_structure = Best_OPL;
BestHM = Best_HM;




end

