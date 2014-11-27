%本程序对IEEE RTS79系统进行评估
% 利用直接序贯蒙特卡洛方法进行系统状态抽样
%可靠性指标选取：
%电力不足概率——LOLP
%年停电功率期望值——EPNS
%平均停电时间——LOLD

%表示所采用的蒙特卡洛方法，直接
amethod=1;
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
%确定该系统中各类元件的个数

mpc=loadcase('case24_ieee_rts');
n_bus=length(mpc.bus);
n_branch=length(mpc.branch);
n_gen=length(mpc.gen);


mpc=case24_to_opf;%读取进行opf的系统参数

%RTS79系统的总负荷量
p_load= -sum(mpc.gen(34:50,10))*0.85;
%% 确定仿真的次数N
N=100;
% 以下变量是用来记录第N年的结果
 time=zeros(1,N);
 n=zeros(1,N);
 dura=zeros(1,N);%停电次数
 lold=zeros(1,N);%平均每次停电时间
 lolp=zeros(1,N);%电力不足概率
%lole=zeros(1,N);% Lost of load expectation=lolp*8760
 epns=zeros(1,N);%年停电功率期望值
%eens=zeros(1,N);%Expected energy not supplied=epns*8760
%以下变量是用来记录前N年的结果
 DURA=zeros(1,N);
 LOLD=zeros(1,N);
 LOLP=zeros(1,N);
 EPNS=zeros(1,N);

 V_LOLP=zeros(1,N);%求标准差
 V_EPNS=zeros(1,N);%求标准差
 V_LOLD=zeros(1,N);%求标准差

 beta_LOLD=zeros(1,N);%求方差系数
 beta_LOLP=zeros(1,N);%求方差系数
 beta_EPNS=zeros(1,N);%求方差系数

 for j=1:N

    tic %计时开始,每一年仿真的时间
    % 利用直接序贯蒙特卡洛方法进行系统状态抽样
    [t_system, status_system] = dirsam_RTS79;%抽取状态

    n(j)=length(t_system);%一个仿真时间段内的系统状态数（这个有头有尾的，实际状态数为n-1）

    loadcut=zeros(1,(j)-1);

    for i=1:n(j)-1

        %一次采样状态的计算
        t_dur=t_system(i+1)-t_system(i);%记录系统状态i的持续时间
       %% 根据采样信息修改系统状态
        mpc.branch(:,11)=status_system(i,1:n_branch)';%修改线路的可用信息
        index=n_branch+1:n_branch+n_gen;
        mpc.gen(1:n_gen,8)=status_system(i,index)';%修改发电机可用信息
       %% 进行可靠性指标的求解
        mpopt = mpoption( 'VERBOSE', 0, 'OUT_ALL', 0);
        results=runopf(mpc,mpopt);
        loadcut(i)=p_load+results.f;%切负荷量

        if(loadcut(i)<1)
            loadcut(i)=0;
        end

        if(loadcut(i) >1)
            F_lolp=1;
            F_epns=loadcut(i);

            if (i==1)
                 dura(j)=dura(j)+1;
            elseif (loadcut(i)*loadcut(i-1)==0)
                dura(j)=dura(j)+1;
            end

        else
             F_lolp=0;
             F_epns=0;
        end



        lolp(j)=lolp(j)+F_lolp*t_dur;
        epns(j)=epns(j)+F_epns*t_dur;

    end

    if (dura(j)==0)
        lold(j)=0;
    else
       lold(j)=lolp(j)/dura(j);
    end

    lolp(j)=lolp(j)/8760;
    epns(j)=epns(j)/8760;

    LOLD(j)=1/j*sum(lold(1:j));
    LOLP(j)=1/j*sum(lolp(1:j));
    EPNS(j)=1/j*sum(epns(1:j));
    V_LOLD(j)=std(lold(1:j));%求标准差
    V_LOLP(j)=std(lolp(1:j));%求标准差
    V_EPNS(j)=std(epns(1:j));%求标准差

    beta_LOLD(j)=V_LOLD(j)/LOLD(j)/sqrt(j);%求方差系数
    beta_LOLP(j)=V_LOLP(j)/LOLP(j)/sqrt(j);%求方差系数
    beta_EPNS(j)=V_EPNS(j)/EPNS(j)/sqrt(j);%求方差系数

    if (j==1)
       time(j)=toc;
    else
       time(j)=time(j-1)+toc;
    end

 end

%  %% 结果展示画图
%  i=1:N;
%  figure(1);
%  plot(i,LOLP);
%  title('IEEE-RTS79 不同仿真次数下LOLP指标 by method1');
%  xlabel('仿真次数N');
%  ylabel('LOLP');
%  grid on;
%
%  i=1:N;
%  figure(2);
%  plot(i,beta_LOLP);
%  title('IEEE-RTS79 不同仿真次数下方差系数beta-LOLP指标 by method1');
%  xlabel('仿真次数N');
%  ylabel('beta-LOLP');
%  grid on;
%
%  i=1:N;
%  figure(3);
%  plot(i,EPNS);
%  title('IEEE-RTS79 不同仿真次数下EPNS指标 by method1');
%  xlabel('仿真次数N');
%  ylabel('EPNS');
%  grid on;
%
%  i=1:N;
%  figure(4);
%  plot(i,beta_EPNS);
%  title('IEEE-RTS79 不同仿真次数下beta-EPNS指标 by method1');
%  xlabel('仿真次数N');
%  ylabel('beta-EPNS');
%  grid on;




