%本程序对IEEE RTS79系统进行评估
% 利用间接序贯蒙特卡洛方法进行系统状态抽样
%可靠性指标选取：
%电力不足概率――LOLP
%年停电功率期望值――EPNS

%表示所采用的蒙特卡洛方法，间接
% amethod=2920;
%% dataformat
%% bus data
%     1       2     3   4   5   6     7    8   9   10     11   12    13
%   bus_i   type    Pd  Qd  Gs  Bs  area   Vm  Va baseKV zone Vmax  Vmin
%% generator data
%    1    2   3    4     5      6     7       8      9       10     11   12  13
%   bus   Pg  Qg  Qmax  Qmin    Vg  mBase   status  Pmax    Pmin    Pc1 Pc2 Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc    ramp_10 ramp_30 ramp_q  apf %   Unit Code
%% generator cost data
%   1   startup shutdown    n   x1  y1  ... xn  yn
%   2   startup shutdown    n   c(n-1)  ... c0
%% branch data
%     1       2     3   4   5     6       7       8       9       10     11        12    13
%   fbus    tbus    r   x   b   rateA   rateB   rateC   ratio   angle   status  angmin  angmax




mpc=loadcase('case24_ieee_rts');
n_bus=length(mpc.bus);
n_branch=length(mpc.branch);
n_gen=33;


mpc=case24_to_opf;%读取进行opf的系统参数
%RTS79系统的总负荷量

% p_load= -sum(mpc.gen(34:50,10))*0.85;
p_load= -sum(mpc.gen(34:50,10)) * 1.1;

N = nseq_circle_times;

time=zeros(1,N);
n=zeros(1,N);

dura=0;%停电次数
% lold=zeros(1,N);%平均每次停电功率
lolp=0;%电力不足概率
%lole=zeros(1,N);% Lost of load expectation=lolp*8760
epns=0;%年停电功率期望值
%eens=zeros(1,N);%Expected energy not supplied=epns*8760




tic %计时开始,每一年仿真的时间
% 利用直接序贯蒙特卡洛方法进行系统状态抽样


%抽取状态

% 非序贯抽样
[lamline , miuline , lamgen, miugen] = faildata;
% 以小时为单位
lamsystem = [lamline , lamgen]/8760;
miusystem = [miuline , miugen]/8760;
probsystem = lamsystem ./ (lamsystem + miusystem);

% 以年为单位
% lamsystem = [lamline , lamgen];
% miusystem = [miuline , miugen];
% probsystem = lamsystem ./ (lamsystem + miusystem);
ele_num = length(lamsystem);
pieprob = 1;

for i = 1: ele_num
    pieprob = (1 - probsystem(1,i)) * pieprob;
end

for i= 1: ele_num
    status_system = ones(1,ele_num);
    status_system(1,i) = 0;
    % 状态记录


    %一次采样状态的计算

    %% 根据采样信息修改系统状态
    %修改线路的可用信息
    mpc.branch(:,11) = status_system(1:n_branch);
    %修改发电机可用信息
    % mpc.gen(1:n_gen , 8) = status_system(n_branch+1: n_branch+n_gen ，i);
    mpc.gen(1:33 , 8) = status_system(39 : 71);

    % 进行可靠性指标的求解

    mpopt = mpoption( 'VERBOSE', 0, 'OUT_ALL', 0);
    results = runopf(mpc,mpopt);
    loadcut(i) = p_load + results.f;%切负荷量


    if(loadcut(i) < 1) %去抖动
        loadcut(i) = 0;
    end

    if(loadcut(i) > 1000) %去错误值
        loadcut(i) = 0;
    end


    if(loadcut(i) >= 1)

        F_lolp = 1 * pieprob / (1 - probsystem(1,i)) * probsystem(1,i);
        F_epns = loadcut(i) * pieprob / (1 - probsystem(1,i)) * probsystem(1,i);

        % 计算是否故障：停电
        if (i==1)
            dura=dura+1;
        elseif (loadcut(i)*loadcut(i-1)==0)
            dura=dura+1;
        end

    else
        F_lolp=0;
        F_epns=0;
    end

    lolp = lolp + F_lolp;
    epns = epns + F_epns;
end






    % 检查结果
    % subplot(3,1,1);
    % bar(beta_LOLP);
    % xlabel('beta\_LOLP');

    % subplot(3,1,2);
    % bar(LOLP);
    % xlabel('LOLP');

    % % subplot(3,1,2);
    % % ylim([0.09,0.13]);
    % % hold on;
    % % plot(LOLP);
    % % subplot(4,1,3);
    % % bar(beta_K);
    % % xlabel('beta\_K');

    % subplot(3,1,3);
    % bar(time);
    % xlabel('time');
    % % subplot(3,1,3)
    % % ylim([0.03 0.06]);
lolp
epns
disp('it is OK!');
    % stairs(t_system(1,2:532),loadcut);
% end


