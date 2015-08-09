% function main()
global bus branch
testof69();
tic
% OP = ones(1, 73);
% % op(69:73) = 0;
% OP(69) = 0;OP(14) = 0;OP(58) = 0;OP(72) = 0;OP(61) = 0;

% powerflow(bus, OP)
% pause
bus_temp = bus;
Vamplitude=zeros(1, length(bus_temp(: ,1 )));
Eploss=0;
dim = 5;
Network = zeros(1,length(branch(: , 1)));
H_M = zeros(1,dim);
[minPloss,BestVamplitude,Network_structure,BestHM, HM, HF, OPL] = main_1(bus_temp);
Vamplitude = BestVamplitude(3 : end);
Eploss = minPloss
Network = Network_structure;
H_M = BestHM
toc



% end
