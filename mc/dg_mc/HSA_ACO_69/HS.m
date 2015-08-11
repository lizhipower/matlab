function [ Best_HM,Best_OPL,Best_HF,Best_V_amplitude, HM, HF, OPL,HMfirst,HFfirst] = HS(bus_temp, init_HM,init_OPL,HMS,Dim)
global bus branch round1 round2 round3 round4 round5
% length(branch(:, 1))
% pause
%round1=[2 3 4 5 6 7 33 20 19 18];%10
%round2=[8 9 10 11 35 21 33];%7
%round3=[34 14 13 12 11 10 9];%7
%round4=[22 23 24 37 28 27 26 25 5 4 3];%11
%round5=[25 26 27 28 29 30 31 32 36 17 16 15 34 8 7 6];%16


%Dim = 5;
%HMS = 100;
HMCR_max = 0.95;
HMCR_min = 0.65;
PAR_max = 0.55;
PAR_min = 0.25;
bw = 1;
MaxItr = 300;
rate_ACO = 0.8; %1 hsa 0 aco
rate_HM = 0.8; %1 hsa 0 aco
[nb,mb] = size(bus);

%% ³õÊ¼»¯
HM = init_HM;
OPL = init_OPL;
HF = zeros(HMS,1);
V_amplitude = zeros(HMS,nb+2);
for i = 1:HMS
    [DS,V] = powerflow(bus_temp,OPL(i,:));
    HF(i,:) = real(DS);
    V_amplitude(i,:) = V;
end

HMfirst = HM;
HFfirst = HF; %real DS


[ HF, HM, OPL, V ] = initial_ACO( HF, HM, OPL, V, rate_HM );
% pause

%%
branchNum = length(branch(:, 1)); %
busNum = length(bus(:, 1)); %
%%%%%%%%%%%%%%%%%%%%%%%%%
% branchNum
% busNum
% pause
%%%%%%%%%%%%%%%%%%%%%%%%%

OP_ACO = ones(1,branchNum);
tau = ones(1,branchNum);
branch_ACO = decodeOP(OP_ACO);
A = formA(branch_ACO, busNum);
NA = 30;

for Itr = 1:MaxItr
    disp('stage2');
    disp(Itr / MaxItr);

    HMCR = HMCR_max - (HMCR_max-HMCR_min)/MaxItr*Itr;
    PAR = PAR_min +(PAR_max-PAR_min)/MaxItr*Itr;

    HarmonyIndex = zeros(1,Dim);
    Harmony = zeros(1,Dim);
    Ran_Solution = zeros(1,Dim);
    if rand < rate_ACO
        GenerateNewHarmony;
        [DS,V] = powerflow(bus_temp,New_OPL);

    else
        lu = 0.7;
        Q = 200;
        [minDS,minDSIndex] = min(HF);
        f = minDS;
        OPindex = OPL(minDSIndex, :);
        for i = 1 : branchNum
            tau(i) = tau(i) * lu;
            if OPindex(i) == 1
                tau(i) = tau(i) + Q / f;
            end
        end

        DS_ACO = [];
        V_ACO = [];
        HM_ACO = [];
        oprslt_ACO = [];
        for i = 1 : NA
            OP_ACO = ACO(A, tau);
            [ds_ACO v_ACO] = powerflow(bus_temp, OP_ACO);
            ds_ACO = real(ds_ACO);
            v_ACO = min(v_ACO(3 : end));
            DS_ACO = [DS_ACO; ds_ACO];
            V_ACO = [V_ACO; v_ACO];
            oprslt_ACO = [oprslt_ACO; OP_ACO];
            HM_ACO = [HM_ACO; find(OP_ACO == 0)];
        end

        [minDS_ACO index_ACO] = min(DS_ACO);
        Vindex_ACO = V_ACO(index_ACO, :);
        OPindex_ACO = oprslt_ACO(index_ACO, :);
        HMindex_ACO = HM_ACO(index_ACO, :);


        DS = minDS_ACO;
        V = Vindex_ACO;
        NewHarmony = HMindex_ACO;
        New_OPL = OPindex_ACO;


    end
    New_HF = real(DS);
    New_V = V;

    [WorstFit,WorstLoc] = max(HF);
    if New_HF < WorstFit
        HM(WorstLoc,:) = NewHarmony;
        HF(WorstLoc,:) = New_HF;
        OPL(WorstLoc,:) = New_OPL;
        V_amplitude(WorstLoc,:) = New_V;
    end
end

% pause

%% ¶Ô×îºó½á¹û½øÐÐÅÅÐò
[BestFit,BestLock] = min(HF);
Best_HM = HM(BestLock,:);
Best_OPL = OPL(BestLock,:);
Best_HF = BestFit;
Best_V_amplitude = V_amplitude(BestLock,:);
%toc;
%%****************************************************************
