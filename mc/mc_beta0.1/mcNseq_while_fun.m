function[cal_cost, lop_rslt, j] =   mcNseq_while_fun (K, spaceGround, spaceCell) 
   
    mpc=loadcase('case24_ieee_rts');
    n_bus=length(mpc.bus);
    n_branch=length(mpc.branch);
    n_gen=33;


    mpc=case24_to_opf;
    %读取进行opf的系统参数
    %RTS79系统的总负荷量
    p_load= -sum(mpc.gen(34:50,10)) * 1.1;

    %% 确定仿真的次数
    % 大循环
    nseq_circle_times = 15;
    % 小循环
    nseq_loop_times = 100;
    % 精度
    beta = 0.2
    dagger_num = 4;

    % 以下变量是用来记录第N年的结果
    N = nseq_circle_times;

    time=zeros(1,N);
    n=zeros(1,N);

    dura=zeros(1,N);%停电次数
    % lold=zeros(1,N);%平均每次停电功率
    lolp=zeros(1,N);%电力不足概率
    %lole=zeros(1,N);% Lost of load expectation=lolp*8760
    epns=zeros(1,N);%年停电功率期望值
    %eens=zeros(1,N);%Expected energy not supplied=epns*8760
    %以下变量是用来记录前N年的结果
    DURA=zeros(1,N);
    % LOLD=zeros(1,N);
    LOLP=zeros(1,N);
    EPNS=zeros(1,N);

    V_LOLP=zeros(1,N);%求标准差
    V_EPNS=zeros(1,N);%求标准差
    % V_LOLD=zeros(1,N);%求标准差

    % beta_LOLD=zeros(1,N);%求方差系数
    beta_LOLP=ones(1,N);%求方差系数
    beta_EPNS=zeros(1,N);%求方差系数

    method = 1;
    % for j=1:N
    %j记录了white循环的次数
    j = 2;
    while(beta_LOLP(j-1) >= beta)
        % 看结果用
        j
        beta_LOLP(j-1)
        status_repeat(j) = 0;
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

        % K = 1.6765;

        % [2,inf]
        % K = 1.6056;
        % [2,4]
        % K = 1.53;
        % [5,inf]
        % K = 2.0586;

        N1 = 0;
        N0 = 0;
        prob_average = mean(probsystem);

        n(j) = nseq_loop_times;%一个循环的系统状态数 也可以切换到 相对不确定度

        loadcut = zeros(1,n(j));

        status_system_rom = [];
        disp(sprintf('stage %d of %d, loading...\n',j,N ));

        for i = 1 : n(j)
            dagger_status_system = cal_dagger(rand(1,ele_num) , dagger_num ,K*probsystem);

            F_lolp_dagger = zeros(1, dagger_num);
            F_epns_dagger = zeros(1, dagger_num);
            for dagger_i = 1 : 1 : dagger_num
                status_system = dagger_status_system(dagger_i , :)';

                % 状态记录
                if isempty(status_system_rom) == 1
                    status_system_rom = status_system;
                else
                    status_system_rom = [status_system_rom status_system];
                end

                %一次采样状态的计算

                %% 根据采样信息修改系统状态
                %修改线路的可用信息
                mpc.branch(:,11) = status_system(1:n_branch);
                %修改发电机可用信息
                mpc.gen(1:33 , 8) = status_system(39 : 71);

                % 进行可靠性指标的求解

                % 进行状态搜索
                search_result = status_search(status_system_rom,status_system);
                error_rank_result = error_rank(status_system);

                if error_rank_result <= spaceGround || error_rank_result > spaceCell
                % if error_rank_result <=1 || error_rank_result > 4
                % if error_rank_result <= 4
                    continue
                end

                if search_result < (i-1) * dagger_num + dagger_i
                    % 表示状态重复
                    % loadcut(i) = loadcut(search_result);
                    loadcut_dagger(dagger_i) = loadcut(search_result);
                    loadcut((i-1)*dagger_num + dagger_i) = loadcut_dagger(dagger_i);
                    status_repeat(j) = status_repeat(j) + 1 ;
                else
                    % 表示是全新状态
                    if error_rank_result >= 0
                        mpopt = mpoption( 'VERBOSE', 0, 'OUT_ALL', 0);
                        results = runopf(mpc,mpopt);
                        % loadcut(i) = p_load + results.f;%切负荷量
                        loadcut_dagger(dagger_i) = p_load + results.f;
                        loadcut((i-1)*dagger_num + dagger_i) = loadcut_dagger(dagger_i);
                    else
                        loadcut((i-1)*dagger_num + dagger_i) = loadcut_dagger(dagger_i);
                        loadcut_dagger(dagger_i) = 0;
                    end
                end
                %去抖动 || 去错误值
                if(loadcut_dagger(dagger_i) < 1) || (loadcut_dagger(dagger_i) > 1000)
                    loadcut_dagger(dagger_i) = 0;
                end

                K_multiNum = 1;
                for ii =1 : 1 : length(status_system)
                    if status_system(ii,1) == 1
                        K_multiNum = K_multiNum * (1 - probsystem(ii))/(1 - K*probsystem(ii));
                    else
                        K_multiNum = K_multiNum / K;
                    end
                end

                % 计算风险指标
                if(loadcut_dagger(dagger_i) >= 1)
                    F_lolp_dagger(dagger_i) = 1 * K_multiNum;
                    F_epns_dagger(dagger_i) = loadcut_dagger(dagger_i) * K_multiNum;
                    % 计算是否故障：停电
                    if (dagger_i == 1)
                        dura(j)=dura(j)+1;
                    elseif (loadcut_dagger(dagger_i)*loadcut_dagger(dagger_i - 1)==0)
                        dura(j)=dura(j)+1;
                    end
                else
                    F_lolp_dagger(dagger_i) = 0;
                    F_epns_dagger(dagger_i) = 0;
                end
            end
            F_lolp = mean(F_lolp_dagger);
            F_epns = mean(F_epns_dagger);
            lolp(j) = lolp(j) + F_lolp;
            epns(j) = epns(j) + F_epns;

        end

        % 第j年的数据
        lolp(j) = lolp(j) / n(j);
        epns(j) = epns(j) / n(j);

        % 前j年的数据
        % LOLD(j) = 1 / j * sum(lold(1:j));
        LOLP(j) = 1 / j * sum(lolp(1:j));
        EPNS(j) = 1 / j * sum(epns(1:j));

        % V_LOLD(j) = std(lold(1:j));%求标准差
        V_LOLP(j) = std(lolp(1:j));%求标准差
        V_EPNS(j) = std(epns(1:j));%求标准差

        % beta_LOLD(j) = V_LOLD(j) / LOLD(j) / sqrt(j);%求方差系数
        beta_LOLP(j) = V_LOLP(j) / LOLP(j) / sqrt(j);%求方差系数
        beta_EPNS(j) = V_EPNS(j) / EPNS(j) / sqrt(j);%求方差系数

        if (j == 1)
           time(j) = toc;
        else
           time(j) = time(j-1)+toc;
        end

        j = j + 1;
    end

    % 检查结果
    % subplot(3,1,1);
    % bar(beta_LOLP);
    % xlabel('beta\_LOLP');
    % xlim([0 j-1]);

    % subplot(3,1,2);
    % bar(LOLP);
    % xlabel('LOLP');
    % xlim([0 j-1]);

    % subplot(3,1,3);
    % bar(time);
    % xlabel('time');
    % xlim([0 j-1]);


    clc;
    cal_cost = time(j-1);
    lop_rslt = LOLP(j-1);
    disp('it is OK!');
     % clear('all')
