%本程序对IEEE RTS79系统进行评估
% 利用间接序贯蒙特卡洛方法进行系统状态抽样
%可靠性指标选取：
%电力不足概率――LOLP
%年停电功率期望值――EPNS



    %确定该系统中各类元件的个数

    clc
    clear;
    mpc=loadcase('case24_ieee_rts');
    n_bus=length(mpc.bus);
    n_branch=length(mpc.branch);
    n_gen=33;


    mpc=case24_to_opf;%读取进行opf的系统参数
    %RTS79系统的总负荷量

    % p_load= -sum(mpc.gen(34:50,10))*0.85;
    p_load= -sum(mpc.gen(34:50,10)) ;

    %% 确定仿真的次数
    % 大循环
    nseq_circle_times = 10;
    % 小循环
    nseq_loop_times = 500;
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
    beta_LOLP=zeros(1,N);%求方差系数
    beta_EPNS=zeros(1,N);%求方差系数

    K_temp = zeros(1,N);
    K_TEMP = zeros(1,N);
    V_K = zeros(1,N);
    beta_K = zeros(1,N);


    K= 1;

    for j=1:N
    % j = 1;
    % while(beta_LOLP(j) >= 0.03)
        % j
        % beta_LOLP(j)
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

        ele_gen = length(lamgen);
        ele_line = length(lamline);
        ele_num = length(lamsystem);

        probline = probsystem(1 : ele_line);
        probgen = probsystem(ele_line+1 : end);

        % 以年为单位
        % lamsystem = [lamline , lamgen];
        % miusystem = [miuline , miugen];
        % probsystem = lamsystem ./ (lamsystem + miusystem);



        N1 = 0;
        N0 = 0;
        prob_average = mean(probsystem);

        n(j) = nseq_loop_times;%一个循环的系统状态数 也可以切换到 相对不确定度

        % loadcut = zeros(1,n(j));

        status_system_rom = [];
        disp(sprintf('stage %d of %d, loading...\n',j,N ));

        for i = 1 : n(j)
            loadcut(i) = 0;
            if mod(i,50)==0
                disp(sprintf('%3.0f%s of stage %d is done, loading...\n',i/n(j)*100,'%',j ));
            end

            % status_system = ( rand(1,ele_num) >= (K*probsystem) )';

            % status_line = ones(1,ele_line)';
            % status_gen = (rand(1,ele_gen) >= (K * probgen))';

            status_line = (rand(1,ele_line) >= (K * probline))';
            status_gen = ones(1,ele_gen)';
            status_system = [status_line ; status_gen];

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

            % if error_rank_result <= 1
            % if error_rank_result <= 1 || error_rank_result > 5
            % if error_rank_result <= 4
            %     continue
            % end

            if search_result < i
                % 表示状态重复
                loadcut(i) = loadcut(search_result);
                status_repeat(j) = status_repeat(j) + 1 ;
            else
                % 表示是全新状态
                mpopt = mpoption( 'VERBOSE', 0, 'OUT_ALL', 0);
                results = runopf(mpc,mpopt);
                loadcut(i) = p_load + results.f;%切负荷量
            end

            if(loadcut(i) < 1) %去抖动
                loadcut(i) = 0;
            end

            if(loadcut(i) > 1000) %去错误值
                loadcut(i) = 0;
            end

            K_multiNum = 1;
            for ii =1 : 1 : length(status_system)
                if status_system(ii,1) == 1
                    K_multiNum = K_multiNum * (1 - probsystem(ii))/(1 - K*probsystem(ii));
                else
                    K_multiNum = K_multiNum / K;
                end
            end

            if(loadcut(i) >= 1)
                % 计算是否故障：停电
                % disp('yo');
                if (i==1) || (loadcut(i)*loadcut(i-1)==0)
                    N0 = N0 + error_rank(status_system);
                    N1 = N1 + ele_num - error_rank(status_system);
                end
            end
        end


        U0 = N0 /( N0 + N1);
        U0_temp(j) = U0;
        A = U0 * prob_average - (1 - U0)*prob_average*(1 - prob_average);
        B = - U0 * prob_average;
        C = U0;

        K = -(B + sqrt(B^2 - A*C)) / A;

        % 第j年的数据
        K_temp(j) = K;
        % 前j年的数据
        K_TEMP(j) = 1 / j * sum(K_temp(1:j));
        %求标准差
        V_K(j) = std(K_TEMP(1:j));
        %求方差系数
        beta_K(j) = V_K(j) / K_TEMP(j) / sqrt(j);

        if (j == 1)
           time(j) = toc;
        else
           time(j) = time(j-1)+toc;
        end

        % j = j + 1;
    end

    % 检查结果
    subplot(2,1,1);
    bar(K_TEMP);
    xlabel('K\_TEMP');
    subplot(2,1,2);
    bar(beta_K);
    xlabel('beta\_K');



    % clc;
    % cal_cost = beta_LOLP(end) * time(end);
    disp('it is OK!');
    K_TEMP(end)
    beta_K(end)
    % stairs(t_system(1,2:532),loadcut);
% end


