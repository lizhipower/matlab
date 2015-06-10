% function main()
tic
% round1=[2 3 4 5 6 7 33 20 19 18];%10
% round2=[2 3 4 5 6 7 8 9 10 11 35 21 20 19 18];%15
% round3=[34 14 13 12 11 10 9];%7
% round4=[22 23 24 37 28 27 26 25 5 4 3];%11
% round5=[25 26 27 28 29 30 31 32 36 17 16 15 14 13 12 11 10 9 8 7 6 ];%21

% common12 = [33];
% common13 = [];
% common14 = [3,4,5];
% common15 = [6,7];
% common23 = [9,10,11];
% common24 = [];
% common25 = [8];
% common34 = [];
% common35 = [34];
% common45 = [25,26,27,28];
clear
clc
global bus branch
testof33();
bus_temp = bus;
branch_temp = branch;

r(1).round = [2 3 4 5 6 7 33 20 19 18];
r(2).round = [34 14 13 12 11 10 9];
r(3).round = [2 3 4 5 6 7 8 9 10 11 35 21 20 19 18];
r(4).round = [25 26 27 28 29 30 31 32 36 17 16 15 14 13 12 11 10 9 8 7 6 ];
r(5).round = [22 23 24 37 28 27 26 25 5 4 3];
rNum = length(r);

o_index = 0;
c_index = 0;

c = [];
for i = 1 : nchoosek(rNum, 2)
    c(i).common = [];
end

c = getCommon(r, rNum);

% ========================
OP = ones(1, length(branch(: , 1)));
Open = 33: 37;

for i = 1 : length(Open)
    OP(Open(i)) = 0;
end

[ds v] = powerflow(OP);
DSList = [ real( ds)];
VList  = [min(v(3:end))];
OpenList = [];
% ========================

% ========================
Open = [6    34     8    36    37];
 r = formRound(Open, bus, branch);

    for i = 1 : 5
        r(i).round
    end

    pause
% =========================

for i = 1 : 3
    r = [];
    r = formRound(Open, bus, branch);
    disp('round');
    for i = 1 : 5
        r(i).round
    end

    [DS Open  V] = branch_exchange(Open, r)
    DSList = [DSList; DS];
    OpenList = [OpenList; Open];
    VList = [VList; V];
    Open
end

pause

INDEX = [OP_open];

[DS_index1 index1 OP_open1 Circle_Exchange V_index1] = branch_exchange(OP_open, r, OP);
DS = [DS; DS_index1];
INDEX = [INDEX; OP_open1];
V = [V; V_index1];
% pause
% r(1).round = [8 9 10 11 35 21 33];
% r(Circle_Exchange).round = 
r(4).round = [2 3 4 5 25 26 27 28 29 30 31 32 36 17 16 15 14 13 12 35 21 20 19 18];
OP(index1) = 0;
OP(OP_open(Circle_Exchange)) = 1;
[DS_index2 index2 OP_open2 Circle_Exchange V_index2] = branch_exchange(OP_open1, r, OP);
DS = [DS; DS_index2];
INDEX = [INDEX; OP_open2];
V = [V; V_index2];


r(1).round = [2 3 4 5 6 7 33 20 19 18];
r(3).round = [8 9 10 11 35 21 33];
OP(index2) = 0;
OP(OP_open1(Circle_Exchange)) = 1;
[DS_index3 index3 OP_open3 Circle_Exchange V_index3] = branch_exchange(OP_open2, r, OP);
DS = [DS; DS_index3];
INDEX = [INDEX; OP_open3];
V = [V; V_index3];


r(2).round = [33 8 34 14 13 12 35 21];
OP(index3) = 0;
OP(OP_open2(Circle_Exchange)) = 1;
[DS_index4 index4 OP_open4 Circle_Exchange V_index4] = branch_exchange(OP_open3, r, OP);
DS = [DS; DS_index4];
INDEX = [INDEX; OP_open4];
V = [V; V_index4];


OP(index4) = 0;
OP(OP_open3(Circle_Exchange)) = 1;
[DS_index5 index5 OP_open5 Circle_Exchange V_index5] = branch_exchange(OP_open4, r, OP);
DS = [DS; DS_index5];
INDEX = [INDEX; OP_open5];
V = [V; V_index5];


OP(index5) = 0;
OP(OP_open4(Circle_Exchange)) = 1;
[DS_index6 index6 OP_open6 Circle_Exchange V_index6] = branch_exchange(OP_open5, r, OP);
DS = [DS; DS_index6];
INDEX = [INDEX; OP_open6];
V = [V; V_index6];


r(4).round = [2 3 4 5 25 26 27 28 29 30 31 32 36 17 16 15 34 8 33 20 19 18];
OP(index6) = 0;
OP(OP_open5(Circle_Exchange)) = 1;
[DS_index7 index7 OP_open7 Circle_Exchange V_index7] = branch_exchange(OP_open6, r, OP);
DS = [DS; DS_index7];
INDEX = [INDEX; OP_open7];
V = [V; V_index7];


OP(index7) = 0;
OP(OP_open6(Circle_Exchange)) = 1;
[DS_index8 index8 OP_open8 Circle_Exchange V_index8] = branch_exchange(OP_open7, r, OP);
DS = [DS; DS_index8];
INDEX = [INDEX; OP_open8];
V = [V; V_index8];

subplot(2,1,1);
plot(DS);
subplot(2,1,2);
plot(V);

V
DS
INDEX

toc 
% OP_rslt = [];
% DS_rslt = [];
% for i= 1:5
%     OP_temp = OP;
%     OP_temp(OP_open(i) ) = 1;
%     [OP_Index, DS_min ]  = minPF(OP_temp, r(i).round);
%     OP_rslt = [OP_rslt OP_Index];
%     DS_rslt = [DS_rslt DS_min];
% end
% [DS_index1 index1 ] = min(DS_rslt);
% index1 = OP_rslt(index1)

% OP_rslt
% DS_rslt
% pause
% clc

% if any(common12 == index1) == 1
%     % 1
%     round2 = union(round2, round1);
%     round2 = setxor(round2, index1);
% end
% OP(35) = 1;
% % round2
% % OP
% index2 = minPF(OP,round2);
% OP(index2) = 0;
% index2
% % pause

% if any (common23 == index2) == 1
%     round3 = union(round3, round2);
%     round3 = setxor(round3, common23);
% end
% OP(34) = 1;
% index3 = minPF(OP, round3);
% OP(index3) = 0;
% index3


% if any (common14 == index1) == 1
%     round4 = union(round4, round1);
%     round4 = setxor(round4, index1);
% end
% OP(37) = 1;
% index4 = minPF(OP, round4);
% OP(index4) = 0;
% index4

% round1=[2 3 4 5 6 7 33 20 19 18];%10
% round2=[8 9 10 11 35 21 33];%7
% round3=[34 14 13 12 11 10 9];%7
% round4=[22 23 24 37 28 27 26 25 5 4];%11
% round5=[25 26 27 28 29 30 31 32 36 17 16 15 34 8 7 6];%16

% common12 = [33];
% common13 = [];
% common14 = [4,5];
% common15 = [6,7];
% common23 = [9,10,11];
% common24 = [];
% common25 = [8];
% common34 = [];
% common35 = [34];
% common45 = [25,26,27,28];
% round5  = union(round5, round1);
% round5 = union(round5, round4);
% round5 = setxor(round5, common14);
% round5 = setxor(round5, common15);
% round5 = setxor(round5, common45);
% OP(36) = 1;
% index5 = minPF(OP, round5);
% OP(index5) = 0;
% index5
% [DS, V] = powerflow(bus, OP);
% real(DS)


% % OP(OP_1) = 0;
% % if any(common12 == OP_1) == 1
% %     round2 = union(round2, round1);
% %     round2 = setxor(round2, OP_1);
% % end







    

% end
