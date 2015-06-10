function [ t_system , status_system ] = dsMCyear( tempOP )
    eleNum = length (tempOP);
    lam = ones(1, eleNum) * 0.4;
    dur = ones(1, eleNum) * 10;
    miu = 8760 ./ dur;

    lam = lam / 8760;
    miu = miu / 8760;

    %假设系统元件开始都处于正常工作状态

    status_system(1 , :) = ones(1 , eleNum);

    %一次仿真一年的状态序列
    %t_branch用来记录所有元件下一状态改变点时刻
    %0时刻记为开始时刻

    t_system = [0];%记录系统状态改变点时刻

    t_branch = zeros(eleNum , 1);%记录系统元件下一次状态改变点时刻


    t_branch = -1 ./ lam' .* log(rand(eleNum , 1));

    % status_temp = ones(eleNum , 1);
     % status_temp = status_system;
    status_temp = ones(eleNum , 1);
    status_system = status_temp;

    while max(t_system) < 8760
        [t index]= min(t_branch);
        t_system = [t_system t];
        status_temp(index , 1) = xor(status_temp(index , 1),1);
        status_system = [status_system status_temp];

        if status_temp(index , 1) == 1
            m = -1/lam(index)*log(rand);
            t_branch(index) = t_branch(index) + m;
        else
            r = -1/miu(index)*log(rand);
            t_branch(index) = t_branch(index) + r;
        end

    end
    % status_system = status_system';

    % dsMCOP

end

