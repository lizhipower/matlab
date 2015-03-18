function [ Best_HM,Best_OPL,Best_HF,Best_V_amplitude] = HS(bus_temp, init_HM,init_OPL,HMS,Dim)
global bus branch round1 round2 round3 round4 round5
%% 数据
%round1=[2 3 4 5 6 7 33 20 19 18];%10
%round2=[8 9 10 11 35 21 33];%7
%round3=[34 14 13 12 11 10 9];%7
%round4=[22 23 24 37 28 27 26 25 5 4 3];%11
%round5=[25 26 27 28 29 30 31 32 36 17 16 15 34 8 7 6];%16

%% 设置参数
%Dim = 5;
%HMS = 100;
HMCR_max = 0.95;  %在和声记忆库中搜索的概率
HMCR_min = 0.65;
PAR_max = 0.55;   %音调微调概率或局部扰动概率
PAR_min = 0.25;
bw = 1;
MaxItr = 100;
[nb,mb] = size(bus);

%% 初始化
HM = init_HM;
OPL = init_OPL;
HF = zeros(HMS,1);
V_amplitude = zeros(HMS,nb+2);
for i = 1:HMS
    [DS,V] = powerflow(bus_temp,OPL(i,:));
    HF(i,:) = real(DS);
    V_amplitude(i,:) = V;
end
%%
for Itr = 1:MaxItr
    HMCR = HMCR_max - (HMCR_max-HMCR_min)/MaxItr*Itr;
    PAR = PAR_min +(PAR_max-PAR_min)/MaxItr*Itr;

    %% 生成一个在全局范围内寻找的和声
    HarmonyIndex = zeros(1,Dim);
    Harmony = zeros(1,Dim);
    Ran_Solution = zeros(1,Dim);
    GenerateNewHarmony;
    [DS,V] = powerflow(bus_temp,New_OPL);
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
   

%% 对最后结果进行排序
[BestFit,BestLock] = min(HF);
Best_HM = HM(BestLock,:)
Best_OPL = OPL(BestLock,:)
Best_HF = BestFit
Best_V_amplitude = V_amplitude(BestLock,:)
%toc;
%%****************************************************************
