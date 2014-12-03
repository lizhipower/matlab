function mpc = case24_to_opf;
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%本程序是基于IEEE RTS79系统的可靠性分析
%在发生线路故障或者发电机故障时需要进行切负荷分析
%在利用matpower进行潮流分析时可以调用的函数有runpf和runopf
%runpf—分析时发电机的出力是不变的，除平衡节点可以变动
%runopf—分析时发电机的额定出力是无意义的，发电机的出力会在min和max之间变动
%切负荷处理时往往是把负荷写作负的发电机形式


%% dataformat
%% bus data
%     1       2     3   4   5   6     7    8   9   10     11   12    13
%	bus_i	type	Pd	Qd	Gs	Bs	area   Vm  Va baseKV zone Vmax	Vmin
%% generator data
%    1    2   3    4     5      6     7       8      9       10     11   12  13
%	bus	  Pg  Qg  Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf	%	Unit Code
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
%% branch data
%     1       2     3   4   5     6       7       8       9       10     11        12    13
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
%% 将原数据中的节点负荷置0
mpc=loadcase('case24_ieee_rts');
j=1;
n=length(mpc.bus);
for i=1:n
    if (mpc.bus(i,3)~=0)
       bus_temp(j,:)= mpc.bus(i,:);%记录下那些带负荷的节点
       j=j+1;
    end
end

mpc.bus(:,3:4)=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%修改负荷总量%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%系统总的装机容量3450MW，总负荷2850MW%%%%%%%%%%%%%%%%%%%%%%%%
bus_temp(:,3)=bus_temp(:,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 修改原来的发电机数据
%确定要添加的发电机列
n=length(mpc.gen);
j=j-1;
for i=1:j
   a=find(mpc.gen(:,1)>=bus_temp(i,1),1);%找到负荷所在节点的发电机数据行
   amax=mpc.gen(n,1);%最后一台发电机所在的节点位置
   if (length(a)==0)
       gen_add(i,:)= mpc.gen(amax,:)
   else
       gen_add(i,:)= mpc.gen(a,:);
   end

end

    gen_add(:,1)=bus_temp(:,1);

%将gen_add对应项修改
for i=1:j
    gen_add(i,4) = 0; % Qmax
    gen_add(i,5) = -bus_temp(i,4); % Qmin
    gen_add(i,9 )= 0; %Pmax
    gen_add(i,10)= -bus_temp(i,3); %Pmin

    gen_add(i,2) = -bus_temp(i,3); %factor - P
    gen_add(i,3) = -bus_temp(i,4); %factor - Q
end

mpc.gen = [mpc.gen;gen_add];

%% 修改对应gencost信息
m=length(mpc.gen);
n=length(mpc.gencost);

for i=n+1:m
   mpc.gencost(i,:)= mpc.gencost(1,:);
end

for i=1:n
    mpc.gencost(i,5)= 0;
    mpc.gencost(i,6)= 0;
    mpc.gencost(i,7)= 0;
end

for i=n+1:m
    mpc.gencost(i,5)= 0;
    mpc.gencost(i,6)= 1;
    mpc.gencost(i,7)= 0;
end


end

