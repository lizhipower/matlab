% function main()
global bus branch 
testof69();
bus_temp = bus;
Vamplitude=zeros(1, length(bus_temp(: ,1 )));
Eploss=0;
dim = 5;
Network = zeros(1,length(branch(: , 1)));
H_M = zeros(1,dim);
[minPloss,BestVamplitude,Network_structure,BestHM, HM, HF, OPL,HMfirst,HFfirst] = main_1(bus_temp);
Vamplitude = BestVamplitude(3 : end);
Eploss = minPloss
Network = Network_structure;
H_M = BestHM


    

% end
