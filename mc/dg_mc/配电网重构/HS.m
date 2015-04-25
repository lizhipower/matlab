% function [ Best_HM,Best_OPL,Best_HF,Best_V_amplitude, OPL, HF, DSrslt, MCrslt] = HS(bus_temp, init_HM,init_OPL,HMS,Dim)

function [HF, HM, OPL] = HS(bus_temp, init_HM,init_OPL,HMS,Dim)
global bus branch round1 round2 round3 round4 round5
%% Êý¾Ý
%round1=[2 3 4 5 6 7 33 20 19 18];%10
%round2=[8 9 10 11 35 21 33];%7
%round3=[34 14 13 12 11 10 9];%7
%round4=[22 23 24 37 28 27 26 25 5 4 3];%11
%round5=[25 26 27 28 29 30 31 32 36 17 16 15 34 8 7 6];%16

%% ÉèÖÃ²ÎÊý
%Dim = 5;
%HMS = 100;
HMCR_max = 0.95;  %ÔÚºÍÉù¼ÇÒä¿âÖÐËÑË÷µÄ¸ÅÂÊ
HMCR_min = 0.65;
PAR_max = 0.55;   %Òôµ÷Î¢µ÷¸ÅÂÊ»ò¾Ö²¿ÈÅ¶¯¸ÅÂÊ
PAR_min = 0.25;
bw = 1;
% MaxItr = HMS;

% VOLL = 1e2;
% VOLL = 0;
[nb,mb] = size(bus);

%% ³õÊ¼»¯
HM = init_HM;
OPL = init_OPL;
HF = zeros(HMS,2);
DSrslt = zeros(HMS,1);
MCrslt = zeros(HMS,1);
V_amplitude = zeros(HMS,nb+2);

for i = 1:HMS
    disp('HSstage 1');
    [DS,V] = powerflow(bus_temp,OPL(i,:));
    % 
    % disp(i / HMS);
    % loadRslt = dsMC(OPL(i,:), bus_temp);
    loadRslt = 0;

    % 
    DSrslt(i,:) = real(DS);
    MCrslt(i,:) = real(loadRslt);
    HF(i,:) = [real(DS)  loadRslt];
    


    V_amplitude(i,:) = V;
end
HF
pause
firstLoop = 20;
for Itr = 1: firstLoop
    % if mod(Itr, MaxItr/10)== 0
        % disp('loading...');
        % disp(Itr/firstLoop);
    % end
    % disp('HSstage 2');
    HMCR = HMCR_max - (HMCR_max-HMCR_min)/firstLoop*Itr;
    PAR = PAR_min +(PAR_max-PAR_min)/firstLoop*Itr;

    %% Éú³ÉÒ»¸öÔÚÈ«¾Ö·¶Î§ÄÚÑ°ÕÒµÄºÍÉù

    HarmonyIndex = zeros(1,Dim);
    Harmony = zeros(1,Dim);
    Ran_Solution = zeros(1,Dim);
    GenerateNewHarmony;
    [DS,V] = powerflow(bus_temp,New_OPL);

    % loadRslt = dsMC(New_OPL, bus_temp);
        loadRslt = 0;

    New_HF = [real(DS)  loadRslt] ;
    New_DSrslt = real(DS);
    New_MCrslt = real(loadRslt);
    New_V = V;

     % for j = 1 : length(HM(: ,1))
            [WorstFit,WorstLoc] = max(HF(: , 1));
            if New_HF(1,1) <= WorstFit
                HM(WorstLoc,:) = NewHarmony;
                HF(WorstLoc,:) = New_HF;
                % DSrslt(WorstLoc,:) = New_DSrslt;
                % MCrslt(WorstLoc,:) = New_MCrslt;

                OPL(WorstLoc,:) = New_OPL;
                V_amplitude(WorstLoc,:) = New_V;
            end          
    % end
end
HF
pause


for i = 1:HMS
    disp('HSstage 2');
    [DS,V] = powerflow(bus_temp,OPL(i,:));
    % 
    disp(i / HMS);
    loadRslt = dsMC(OPL(i,:), bus_temp);
    % loadRslt = 0;

    % 
    DSrslt(i,:) = real(DS);
    MCrslt(i,:) = real(loadRslt);
    HF(i,:) = [real(DS)  loadRslt];
    V_amplitude(i,:) = V;
end
HF
pause
%%
MaxItr = 500;
for Itr = 1:MaxItr
    % if mod(Itr, MaxItr/10)== 0
        disp('loading...');
        disp(Itr/MaxItr);
    % end
    % disp('HSstage 2');
    HMCR = HMCR_max - (HMCR_max-HMCR_min)/MaxItr*Itr;
    PAR = PAR_min +(PAR_max-PAR_min)/MaxItr*Itr;

    %% Éú³ÉÒ»¸öÔÚÈ«¾Ö·¶Î§ÄÚÑ°ÕÒµÄºÍÉù

    HarmonyIndex = zeros(1,Dim);
    Harmony = zeros(1,Dim);
    Ran_Solution = zeros(1,Dim);
    GenerateNewHarmony;
    [DS,V] = powerflow(bus_temp,New_OPL);

    loadRslt = dsMC(New_OPL, bus_temp);
        % loadRslt = 0;

    New_HF = [real(DS)  loadRslt] 
    New_DSrslt = real(DS);
    New_MCrslt = real(loadRslt);
    New_V = V;

    j =1 ;
     while j < length(HM(: ,1))
            % dominateRslt =  isDominate(HM, HF , new_x, dim);


            compareLoop = New_HF < HF(j, :);
            dominateRsltLoop = all(all(compareLoop==1));
            notDominateRsltLoop = all(all(compareLoop==0));

            if dominateRsltLoop == 1
                disp('dom');
                HM(j , : ) = [];
                HF(j , :) = [];
                OPL(j ,:) = [];
                V_amplitude(j ,:) = [];
                if length(HM) == 0 
                    HM = NewHarmony;
                    HF = New_HF;
                    OPL = New_OPL;
                    V_amplitude = New_V;
                    break
                end
                j = j -1;
               % length(HM(: , 1));
            end

            j = j + 1;
            
    end

        j =1 ;

    while j < length(HM(: ,1))
            compareLoop = New_HF < HF(j, :);
            dominateRsltLoop = all(all(compareLoop==1));
            notDominateRsltLoop = all(all(compareLoop==0));
            if notDominateRsltLoop == 1
                disp('notdom');
            else
                disp('equal');
                HM = [HM; NewHarmony];
                HF = [HF; New_HF];
                OPL= [OPL; New_OPL];
                V_amplitude = [V_amplitude; New_V];
                break
            end

            j = j + 1;
            
    end

%     [WorstFit,WorstLoc] = max(HF);
%     if New_HF < WorstFit
%         HM(WorstLoc,:) = NewHarmony;
%         HF(WorstLoc,:) = New_HF;
%         DSrslt(WorstLoc,:) = New_DSrslt;
%         MCrslt(WorstLoc,:) = New_MCrslt;

%         OPL(WorstLoc,:) = New_OPL;
%         V_amplitude(WorstLoc,:) = New_V;
%     end
end
   

%% ¶Ô×îºó½á¹û½øÐÐÅÅÐò
% [BestFit,BestLock] = min(HF);
% Best_HM = HM(BestLock,:);
% Best_OPL = OPL(BestLock,:);
% Best_HF = BestFit;
% Best_V_amplitude = V_amplitude(BestLock,:);
%toc;
%%****************************************************************
