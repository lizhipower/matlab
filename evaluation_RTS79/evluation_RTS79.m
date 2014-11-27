%�������IEEE RTS79ϵͳ��������
% ����ֱ��������ؿ��巽������ϵͳ״̬����
%�ɿ���ָ��ѡȡ��
%����������ʡ���LOLP
%��ͣ�繦������ֵ����EPNS
%ƽ��ͣ��ʱ�䡪��LOLD

%��ʾ�����õ����ؿ��巽����ֱ��
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
%ȷ����ϵͳ�и���Ԫ���ĸ���

mpc=loadcase('case24_ieee_rts');
n_bus=length(mpc.bus);
n_branch=length(mpc.branch);
n_gen=length(mpc.gen);


mpc=case24_to_opf;%��ȡ����opf��ϵͳ����

%RTS79ϵͳ���ܸ�����
p_load= -sum(mpc.gen(34:50,10))*0.85;
%% ȷ������Ĵ���N
N=100;
% ���±�����������¼��N��Ľ��
 time=zeros(1,N);
 n=zeros(1,N);
 dura=zeros(1,N);%ͣ�����
 lold=zeros(1,N);%ƽ��ÿ��ͣ��ʱ��
 lolp=zeros(1,N);%�����������
%lole=zeros(1,N);% Lost of load expectation=lolp*8760
 epns=zeros(1,N);%��ͣ�繦������ֵ
%eens=zeros(1,N);%Expected energy not supplied=epns*8760
%���±�����������¼ǰN��Ľ��
 DURA=zeros(1,N);
 LOLD=zeros(1,N);
 LOLP=zeros(1,N);
 EPNS=zeros(1,N);

 V_LOLP=zeros(1,N);%���׼��
 V_EPNS=zeros(1,N);%���׼��
 V_LOLD=zeros(1,N);%���׼��

 beta_LOLD=zeros(1,N);%�󷽲�ϵ��
 beta_LOLP=zeros(1,N);%�󷽲�ϵ��
 beta_EPNS=zeros(1,N);%�󷽲�ϵ��

 for j=1:N

    tic %��ʱ��ʼ,ÿһ������ʱ��
    % ����ֱ��������ؿ��巽������ϵͳ״̬����
    [t_system, status_system] = dirsam_RTS79;%��ȡ״̬

    n(j)=length(t_system);%һ������ʱ����ڵ�ϵͳ״̬���������ͷ��β�ģ�ʵ��״̬��Ϊn-1��

    loadcut=zeros(1,(j)-1);

    for i=1:n(j)-1

        %һ�β���״̬�ļ���
        t_dur=t_system(i+1)-t_system(i);%��¼ϵͳ״̬i�ĳ���ʱ��
       %% ���ݲ�����Ϣ�޸�ϵͳ״̬
        mpc.branch(:,11)=status_system(i,1:n_branch)';%�޸���·�Ŀ�����Ϣ
        index=n_branch+1:n_branch+n_gen;
        mpc.gen(1:n_gen,8)=status_system(i,index)';%�޸ķ����������Ϣ
       %% ���пɿ���ָ������
        mpopt = mpoption( 'VERBOSE', 0, 'OUT_ALL', 0);
        results=runopf(mpc,mpopt);
        loadcut(i)=p_load+results.f;%�и�����

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
    V_LOLD(j)=std(lold(1:j));%���׼��
    V_LOLP(j)=std(lolp(1:j));%���׼��
    V_EPNS(j)=std(epns(1:j));%���׼��

    beta_LOLD(j)=V_LOLD(j)/LOLD(j)/sqrt(j);%�󷽲�ϵ��
    beta_LOLP(j)=V_LOLP(j)/LOLP(j)/sqrt(j);%�󷽲�ϵ��
    beta_EPNS(j)=V_EPNS(j)/EPNS(j)/sqrt(j);%�󷽲�ϵ��

    if (j==1)
       time(j)=toc;
    else
       time(j)=time(j-1)+toc;
    end

 end

%  %% ���չʾ��ͼ
%  i=1:N;
%  figure(1);
%  plot(i,LOLP);
%  title('IEEE-RTS79 ��ͬ���������LOLPָ�� by method1');
%  xlabel('�������N');
%  ylabel('LOLP');
%  grid on;
%
%  i=1:N;
%  figure(2);
%  plot(i,beta_LOLP);
%  title('IEEE-RTS79 ��ͬ��������·���ϵ��beta-LOLPָ�� by method1');
%  xlabel('�������N');
%  ylabel('beta-LOLP');
%  grid on;
%
%  i=1:N;
%  figure(3);
%  plot(i,EPNS);
%  title('IEEE-RTS79 ��ͬ���������EPNSָ�� by method1');
%  xlabel('�������N');
%  ylabel('EPNS');
%  grid on;
%
%  i=1:N;
%  figure(4);
%  plot(i,beta_EPNS);
%  title('IEEE-RTS79 ��ͬ���������beta-EPNSָ�� by method1');
%  xlabel('�������N');
%  ylabel('beta-EPNS');
%  grid on;




