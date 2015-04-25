% 随机产生一个未经修复的初始解
% INIT为一个1*s的矩阵，以0-1表明各个开关的开闭状态
% duan_kai为一个1*m的矩阵，储存各个环内的断开开关的编号
%%
%% output: duan_kai INIT;
%% Pram Start！
%round1=[2 3 4 5 6 7 33 20 19 18];%10
%round2=[8 9 10 11 35 21 33];%7
%round3=[34 14 13 12 11 10 9];%7
%round4=[22 23 24 37 28 27 26 25 5 4 3];%11
%round5=[25 26 27 28 29 30 31 32 36 17 16 15 34 8 7 6];%16

% common12 = [18 19 20 21 22 23 24 25 26 27];
common12 = [17  18  19  20  21  22  23  24  25  26];
% common13 = [10 11 18 19 20 21 22 23 24];
common13 = [9   10  17  18  19  20  21  22  23];
% common14 = [40 41 42 43 44 45];
common14 = [39    40    41    42    43    44];
% common17 = [29 30 40 41 42];
common17 = [28    29    39    40    41]; 
% common18 = [4 29 30];
common18 = [3    28    29];
% common1_15 = [10 11 18 19 20 21 22 23 24 25 4 29 30];
common1_15 = [9 10  17  18  19  20  21  22  23  24  3   28  29];
% common23 = [18 19 20 21 22 23 24];
common23 = [17    18    19    20    21    22    23];
% common37 = [5 6 7 8];
common37 = [4     5     6     7];
% common38 = [4];
common38 = [3];
% common3_15 = [4 10 11 18 19 20 21 22 23 24];
common3_15 = [3 9   10  17  18  19  20  21  22  23];
% common45 = [31 32 33 34 35 36 49 50 51];
common45 = [30    31    32    33    34    35    48    49    50];
% common46 = [31];
common46 = [30];
% common47 = [40 41 42];
common47 = [39  40  41];
% common4_15 = [31 32 33 34 35 36];
common4_15 = [30    31    32    33    34    35];
% common56 = [31 58 59 60 61 62 63 64 65];
common56 = [30    57    58    59    60    61    62    63    64];
% common58 = [58 59 60 61];
common58 = [57    58    59    60];
% common5_15 = [31 32 33 34 35 36];
common5_15 = [30    31    32    33    34    35];
% common68 = [58 59 60 61];
common68 = [57    58    59    60];
% common6_15 = [31];
common6_15 = [30];
% common78 = [29 30];
common78 = [28 29];
% common7_15 = [29 30];
common7_15 = [28 29];
% common89 = [93 94 95];
common89 = [92 93 94];
% common8_10 = [68];
common8_10 = [67];
% common8_11 = [93 94 95 100];
common8_11 = [92 93 94 99];
% common8_12 = [66 67];
common8_12 = [65 66];
% common8_13 = [66 67];
common8_13 = [65 66];
% common8_15 = [4 29 30];
common8_15 = [3 28 29];
% common9_10 = [69 70 71 72 73 74 75 76];
common9_10 = [68    69    70    71    72    73    74    75];
% common9_11 = [69 70 71 72 73 74 75 76];
common9_11 = [68    69    70    71    72    73    74    75];
% common10_11 = [69 70 71 72 73 74 75 76 77 78];
common10_11 = [68   69  70  71  72  73  74  75  76  77];
% common10_12 = [81 82];
common10_12 = [80 81];
% common10_13 = [81 82 89];
common10_13 = [80 81 88];
% common12_13 = [66 67 81 82 105 106 107 108 109 110];
common12_13 = [65   66  80  81  104 105 106 107 108 109];
% common12_14 = [106 107 108 109 110 111 112 113];
common12_14 = [105   106   107   108   109   110   111   112];
% common13_14 = [106 107 108 109 110];
common13_14 = [105   106   107   108   109];



%%
s = 132;
m = 15;
INIT = ones(1,s);
duan_kai = zeros(1,m);

%% 取第一个环路的断开开关
x = length(round1).*rand(1);
y1 = round1(ceil(x));
duan_kai(1) = y1;
INIT(y1) = 0;
%% 取第二个环路的断开开关
judge = 0;
for kk = 1:length(common12)
    if common12(kk) == y1
        judge = 1;
        round2 = setdiff(round2,common12);
        break
    end
end


x = length(round2).*rand(1);
y2 = round2(ceil(x));
duan_kai(2) = y2;
INIT(y2) = 0;
%% 取第三个环路开关
judge1 = 0;
judge2 = 0;
for kk = 1:length(common13)
    if common13(kk) == y1
        judge1 = 1;
        round3 = setdiff(round3,common13);
        break
    end
end
for kk = 1:length(common23)
    if common23(kk) == y2
        judge1 = 1;
        round3 = setdiff(round3,common23);
        break
    end
end



x = length(round3).*rand(1);
y3 = round3(ceil(x));
duan_kai(3) = y3;
INIT(y3) = 0;

%% 取第四个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
for kk = 1:length(common14)
   if common14(kk) == y1
       judge1 = 1;
       round4 = setdiff(round4,common14);
       break
   end
end

x = length(round4).*rand(1);
y4 = round4(ceil(x));
duan_kai(4) = y4;
INIT(y4) = 0;

%% 取第五个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;

for kk = 1:length(common45)
    if common45(kk) == y4
        judge4 = 1;
        round5 = setdiff(round5,common45);
        break
    end
end

x = length(round5).*rand(1);
y5 = round5(ceil(x));
duan_kai(5) = y5;
INIT(y5) = 0;

%% 取第6个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;

for kk = 1:length(common46)
    if common46(kk) == y4
        judge4 = 1;
        round6 = setdiff(round6,common46);
        break
    end
end

for kk = 1:length(common56)
    if common56(kk) == y5
        judge5 = 1;
        round6 = setdiff(round6,common56);
        break
    end
end
x = length(round6).*rand(1);
y6 = round6(ceil(x));
duan_kai(6) = y6;
INIT(y6) = 0;
            
%% 取第7个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;

for kk = 1:length(common17)
    if common17(kk) == y1
        judge1 = 1;
        round7 = setdiff(round7,common17);
        break
    end
end
for kk = 1:length(common37)
    if common37(kk) == y3
        judge3 = 1;
        round7 = setdiff(round7,common37);
        break
    end
end
for kk = 1:length(common47)
    if common47(kk) == y4
        judge4 = 1;
        round7 = setdiff(round7,common47);
        break
    end
end

x = length(round7).*rand(1);
y7 = round7(ceil(x));
duan_kai(7) = y7;
INIT(y7) = 0;

%% 取第8个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;
judge7 = 0;

for kk = 1:length(common18)
    if common18(kk) == y1
        judge1 = 1;
        round8 = setdiff(round8,common18);
        break
    end
end
for kk = 1:length(common38)
    if common38(kk) == y3
        judge3 = 1;
        round8 = setdiff(round8,common38);
        break
    end
end
for kk = 1:length(common58)
    if common58(kk) == y5
        judge5 = 1;
        round8 = setdiff(round8,common58);
        break
    end
end
for kk = 1:length(common68)
    if common68(kk) == y6
        judge6 = 1;
        round8 = setdiff(round8,common68);
        break
    end
end
for kk = 1:length(common78)
    if common78(kk) == y7
        judge7 = 1;
        round8 = setdiff(round8,common78);
        break
    end
end
x = length(round8).*rand(1);
y8 = round8(ceil(x));
duan_kai(8) = y8;
INIT(y8) = 0;
            
%% 取第9个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;
judge7 = 0;
judge8 = 0;


for kk = 1:length(common89)
    if common89(kk) == y8
        judge8 = 1;
        round9 = setdiff(round9,common89);
        break
    end
end

x = length(round9).*rand(1);
y9 = round9(ceil(x));
duan_kai(9) = y9;
INIT(y9) = 0;

%% 取第10个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;
judge7 = 0;
judge8 = 0;
judge9 = 0;


for kk = 1:length(common8_10)
    if common8_10(kk) == y8
        judge8 = 1;
        round10 = setdiff(round10,common8_10);
        break
    end
end
for kk = 1:length(common9_10)
    if common9_10(kk) == y9
        judge9 = 1;
        round10 = setdiff(round10,common9_10);
        break
    end
end
x = length(round10).*rand(1);
y10 = round10(ceil(x));
duan_kai(10) = y10;
INIT(y10) = 0;
   
%% 取第11个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;
judge7 = 0;
judge8 = 0;
judge9 = 0;
judge10 = 0;


for kk = 1:length(common8_11)
    if common8_11(kk) == y8
        judge8 = 1;
        round11 = setdiff(round11,common8_11);
        break
    end
end
for kk = 1:length(common9_11)
    if common9_11(kk) == y9
        judge9 = 1;
        round11 = setdiff(round11,common9_11);
        break
    end
end
for kk = 1:length(common10_11)
    if common10_11(kk) == y10
        judge10 = 1;
        round11 = setdiff(round11,common10_11);
        break
    end
end
x = length(round11).*rand(1);
y11 = round11(ceil(x));
duan_kai(11) = y11;
INIT(y11) = 0;
%% 取第12个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;
judge7 = 0;
judge8 = 0;
judge9 = 0;
judge10 = 0;
judge11 = 0;


for kk = 1:length(common8_12)
    if common8_12(kk) == y8
        judge8 = 1;
        round12 = setdiff(round12,common8_12);
        break
    end
end
for kk = 1:length(common10_12)
    if common10_12(kk) == y10
        judge10 = 1;
        round12 = setdiff(round12,common10_12);
        break
    end
end

x = length(round12).*rand(1);
y12 = round12(ceil(x));
duan_kai(12) = y12;
INIT(y12) = 0;

%% 取第13个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;
judge7 = 0;
judge8 = 0;
judge9 = 0;
judge10 = 0;
judge11 = 0;
judge12 = 0;


for kk = 1:length(common8_13)
    if common8_13(kk) == y8
        judge8 = 1;
        round13 = setdiff(round13,common8_13);
        break
    end
end
for kk = 1:length(common12_13)
    if common12_13(kk) == y12
        judge12 = 1;
        round13 = setdiff(round13,common12_13);
        break
    end
end

x = length(round13).*rand(1);
y13 = round13(ceil(x));
duan_kai(13) = y13;
INIT(y13) = 0;

%% 取第14个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;
judge7 = 0;
judge8 = 0;
judge9 = 0;
judge10 = 0;
judge11 = 0;
judge12 = 0;
judge13 = 0;


for kk = 1:length(common12_14)
    if common12_14(kk) == y12
        judge12 = 1;
        round14 = setdiff(round14,common12_14);
        break
    end
end
for kk = 1:length(common13_14)
    if common13_14(kk) == y13
        judge13 = 1;
        round14 = setdiff(round14,common13_14);
        break
    end
end

x = length(round14).*rand(1);
y14 = round14(ceil(x));
duan_kai(14) = y14;
INIT(y14) = 0;

%% 取第15个环路的断开开关
judge1 = 0;
judge2 = 0;
judge3 = 0;
judge4 = 0;
judge5 = 0;
judge6 = 0;
judge7 = 0;
judge8 = 0;
judge9 = 0;
judge10 = 0;
judge11 = 0;
judge12 = 0;
judge13 = 0;
judge14 = 0;

for kk = 1:length(common1_15)
    if common1_15(kk) == y1
        judge1 = 1;
        round15 = setdiff(round15,common1_15);
        break
    end
end
for kk = 1:length(common3_15)
    if common3_15(kk) == y3
        judge3 = 1;
        round15 = setdiff(round15,common3_15);
        break
    end
end
for kk = 1:length(common4_15)
    if common4_15(kk) == y4
        judge4 = 1;
        round15 = setdiff(round15,common4_15);
        break
    end
end
for kk = 1:length(common5_15)
    if common5_15(kk) == y5
        judge5 = 1;
        round15 = setdiff(round15,common5_15);
        break
    end
end
for kk = 1:length(common6_15)
    if common6_15(kk) == y6
        judge6 = 1;
        round15 = setdiff(round15,common6_15);
        break
    end
end
for kk = 1:length(common7_15)
    if common7_15(kk) == y7
        judge7 = 1;
        round15 = setdiff(round15,common7_15);
        break
    end
end
for kk = 1:length(common8_15)
    if common8_15(kk) == y8
        judge8 = 1;
        round15 = setdiff(round15,common8_15);
        break
    end
end


x = length(round15).*rand(1);
y15 = round15(ceil(x));
duan_kai(15) = y15;
INIT(y15) = 0;