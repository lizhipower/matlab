% function main()
global bus branch
testof119();
bus_temp = bus;
Vamplitude=zeros(1,125);
Eploss=0;
Network = zeros(1,length(branch(: , 1)));
H_M = zeros(1,15);
[minPloss,BestVamplitude,Network_structure,BestHM, HM, HF, OPL,HMfirst,HFfirst] = main_1_119(bus_temp);
Vamplitude = BestVamplitude(3 : end);
Eploss = minPloss
Network = Network_structure;
H_M = BestHM


    

% end
