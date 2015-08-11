clear;
global bus branch
testof69();
% length(branch(:, 1))
% pause
bus_temp = bus;
bestDS = [];
bestHM = [];
time = [];
for i = 1 : 20
    disp(i);
    disp('iteratoin');
    tic
    Vamplitude=zeros(1,length(bus(:, 1)) + 2);
    Eploss=0;
    Network = zeros(1,length(branch(:, 1)));
    H_M = zeros(1,5);
    [minPloss,BestVamplitude,Network_structure,BestHM, HM, HF, OPL,HMfirst,HFfirst] = main_1(bus_temp);
    Vamplitude = BestVamplitude;
    Eploss = minPloss;
    Network = Network_structure;
    H_M = BestHM;
    bestDS = [bestDS; Eploss];
    bestHM = [bestHM; H_M];
    time = [time; toc];
end
bestDS
bestHM
time
