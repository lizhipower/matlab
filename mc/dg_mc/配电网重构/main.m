% function main()
    tic
global bus branch
testof33();
bus_temp = bus;
Vamplitude=zeros(1,35);
Eploss=0;
Network = zeros(1,37);
H_M = zeros(1,5);
% [minPloss,BestVamplitude,Network_structure,BestHM, OPL, HF, DSrslt, MCrslt] = main_1(bus_temp);
[HF, HM, OPL] = main_1(bus_temp);
% for i = 1 : length (OPL)
%     MCrslt(i) = dsMC(OPL(i, :), bus_temp);
% end
% Vamplitude = BestVamplitude
% Eploss = minPloss
% Network = Network_structure
% H_M = BestHM
toc
% time = toc

    

% end
