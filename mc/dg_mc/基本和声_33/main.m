clear;
global bus branch
tic
testof33();
bus_temp = bus;
Vamplitude=zeros(1,35);
Eploss=0;
Network = zeros(1,37);
H_M = zeros(1,5);
[minPloss,BestVamplitude,Network_structure,BestHM, HM, HF, OPL,HMfirst,HFfirst] = main_1(bus_temp);
Vamplitude = BestVamplitude
Eploss = minPloss
Network = Network_structure
H_M = BestHM

toc
