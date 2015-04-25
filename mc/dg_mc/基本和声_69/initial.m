function [init_HM,init_OPL] = initial(HMS,Dim)
%%
global bus branch round1 round2 round3 round4 round5 
%round6 round7 round8 round9 round10 round11 round12 round13 round14 round15
%global bus line round1 round2 round3 round4 round5...
%     common12  common13 common14 common15 common23...
%     common24 common25 common34 common35 common45 

%%
s = length(branch(:,1));
init_HM = ones(HMS,Dim);
init_OPL = [];
%Ploss=zeros(1,HMS);
for i = 1:HMS
    init;
    init_HM(i,:) = duan_kai;
    init_OPL(i,:) = INIT;

    init_OPL(i,:) = Rep(init_OPL(i,:));
%    Ploss(i) = powerflow_1(init_OPL(i,:));
     %init_OPL(i,:) = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
end
%init_OPL(HMS,:) = [1,1,1,1,1,1,0,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1];
%init_HM(HMS,:) = [7,9,14,32,28];
end
    