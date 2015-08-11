function [ Best_HM,Best_OPL,Best_HF,Best_V_amplitude, HM, HF, OPL,HMfirst,HFfirst] = HS(bus_temp, init_HM,init_OPL,HMS,Dim)
global bus branch round1 round2 round3 round4 round5 round6 round7 round8 round9 round10 round11 round12 round13 round14 round15

%===========================================
rate_ACO = 0.9; %1 hsa 0 aco
rate_HM = 0.8; %1 hsa 0 aco
MaxItr = 1000;
itrstop = 56;
%==========================================

HMCR_max = 0.95;
HMCR_min = 0.65;
PAR_max = 0.55;
PAR_min = 0.25;
bw = 1;

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
branchNum = length(branch(:, 1)); %37
busNum = length(bus(:, 1)); %33
OP_ACO = ones(1,branchNum);
tau = ones(1,branchNum);
branch_ACO = decodeOP(OP_ACO);
A = formA(branch_ACO, busNum);
NA = 30;

itrHM = [];
itrHF = [];
time1 = toc;
% HF
% pause
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
    [BestFit,BestLoc] = min(HF);

    itrHF = [itrHF; HF(BestLoc, :)];
    itrHM = [itrHM; HM(BestLoc,:)];
    Itr
    if Itr == itrstop
    % if HF(BestLoc, :) < 139.96
        clc
        time1
        time2 = toc
        timetotal = time1/8 + time2
        %======================================
        % itrHF
        % disp('itr');
        % Itr
        % itrHM
        pause
    end

    if New_HF < WorstFit

        HM(WorstLoc,:) = NewHarmony;
        HF(WorstLoc,:) = New_HF;
        OPL(WorstLoc,:) = New_OPL;
        V_amplitude(WorstLoc,:) = New_V;
    end
end

% pause


[BestFit,BestLock] = min(HF);
Best_HM = HM(BestLock,:);
Best_OPL = OPL(BestLock,:);
Best_HF = BestFit;
Best_V_amplitude = V_amplitude(BestLock,:);

