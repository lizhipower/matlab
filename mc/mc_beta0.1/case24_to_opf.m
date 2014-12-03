function mpc = case24_to_opf;
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%�������ǻ���IEEE RTS79ϵͳ�Ŀɿ��Է���
%�ڷ�����·���ϻ��߷��������ʱ��Ҫ�����и��ɷ���
%������matpower���г�������ʱ���Ե��õĺ�����runpf��runopf
%runpf������ʱ������ĳ����ǲ���ģ���ƽ��ڵ���Ա䶯
%runopf������ʱ������Ķ������������ģ�������ĳ�������min��max֮��䶯
%�и��ɴ���ʱ�����ǰѸ���д�����ķ������ʽ


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
%% ��ԭ�����еĽڵ㸺����0
mpc=loadcase('case24_ieee_rts');
j=1;
n=length(mpc.bus);
for i=1:n
    if (mpc.bus(i,3)~=0)
       bus_temp(j,:)= mpc.bus(i,:);%��¼����Щ�����ɵĽڵ�
       j=j+1;
    end
end

mpc.bus(:,3:4)=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%�޸ĸ�������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%ϵͳ�ܵ�װ������3450MW���ܸ���2850MW%%%%%%%%%%%%%%%%%%%%%%%%
bus_temp(:,3)=bus_temp(:,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% �޸�ԭ���ķ��������
%ȷ��Ҫ��ӵķ������
n=length(mpc.gen);
j=j-1;
for i=1:j
   a=find(mpc.gen(:,1)>=bus_temp(i,1),1);%�ҵ��������ڽڵ�ķ����������
   amax=mpc.gen(n,1);%���һ̨��������ڵĽڵ�λ��
   if (length(a)==0)
       gen_add(i,:)= mpc.gen(amax,:)
   else
       gen_add(i,:)= mpc.gen(a,:);
   end

end

    gen_add(:,1)=bus_temp(:,1);

%��gen_add��Ӧ���޸�
for i=1:j
    gen_add(i,4) = 0; % Qmax
    gen_add(i,5) = -bus_temp(i,4); % Qmin
    gen_add(i,9 )= 0; %Pmax
    gen_add(i,10)= -bus_temp(i,3); %Pmin

    gen_add(i,2) = -bus_temp(i,3); %factor - P
    gen_add(i,3) = -bus_temp(i,4); %factor - Q
end

mpc.gen = [mpc.gen;gen_add];

%% �޸Ķ�Ӧgencost��Ϣ
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

