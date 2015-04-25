%% ½Å±¾ÎÄ¼þ
% ¹¦ÄÜ£ºÉú³ÉÒ»¸öÐÂºÍÉù
% output:NewHarmony
% output:New_OPL
% output£ºNew_HF

%% Êý¾Ý
%round1=[2 3 4 5 6 7 33 20 19 18];%10
%round2=[8 9 10 11 35 21 33];%7
%round3=[34 14 13 12 11 10 9];%7
%round4=[22 23 24 37 28 27 26 25 5 4 3];%11
%round5=[25 26 27 28 29 30 31 32 36 17 16 15 34 8 7 6];%16

%% Éú³ÉÐÂºÍÉù
init;

Ran_Solution = duan_kai;
HarmonyIndex = fix(rand(1,Dim)*HMS)+1;
Harmony = diag(HM(HarmonyIndex,1:Dim))';
CMMask = (rand(1,Dim) < HMCR);
NHMask = (1-CMMask);
PAMask = (rand(1,Dim) < PAR) .* (CMMask);
CMMask = (CMMask).* (1-PAMask);
Tubian = bw*(2*floor(rand(1,Dim)*2)-ones(1,Dim));
HarmonyIndex_1 = HarmonyIndex + Tubian;
for kk = 1:Dim
    if HarmonyIndex_1(kk) > HMS
        HarmonyIndex_1(kk) = HMS;
    elseif HarmonyIndex_1(kk) < 1
        HarmonyIndex_1(kk) = 1;
    end
end
Harmony_Tubian = diag(HM(HarmonyIndex_1,1:Dim))';

NewHarmony = CMMask .* Harmony + PAMask.* Harmony_Tubian + NHMask.* Ran_Solution;
New_OPL = ones(1,length(branch(: , 1)));
New_HF = 0;
New_V = [];
for kk = 1:Dim
    duan_kai_num = NewHarmony(kk);
    New_OPL(duan_kai_num) = 0;
end
New_OPL = Rep(New_OPL);


    

    

