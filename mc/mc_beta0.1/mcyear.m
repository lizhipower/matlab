%RTS79系统状态采样
%基于序贯蒙特卡洛序贯方法
%本系统共有bus: [24x13 double]

%          gen: [33x21 double]
%       branch: [38x13 double]

%考虑1年内的状态序列
%读取RTS79的停运模型参数

%% mcyear: 最终结果 t_system表示系统的每个状态改变的时间点，status_system表示系统的状态变化过程，它的最后一状态信息是无用信息，因为没有计算它的持续时间
function [t_system , status_system] = mcyear


    [lamline , miuline , lamgen, miugen] = faildata;
    % 以小时为单位
    lamsystem = [lamline , lamgen]/8760;
    miusystem = [miuline , miugen]/8760;

    % 以年为单位
    % lamsystem = [lamline , lamgen];
    % miusystem = [miuline , miugen];

    ele_num = length(lamsystem);

    %假设系统元件开始都处于正常工作状态

    status_system(1 , :) = ones(1 , ele_num);

    %一次仿真一年的状态序列
    %t_branch用来记录所有元件下一状态改变点时刻
    %0时刻记为开始时刻

    t_system = [0];%记录系统状态改变点时刻

    t_branch = zeros(ele_num , 1);%记录系统元件下一次状态改变点时刻


    t_branch = -1 ./ lamsystem' .* log(rand(ele_num , 1));

    status_temp = ones(ele_num , 1);
    status_system = status_temp;

    while max(t_system) < 8760
        [t index]= min(t_branch);
        t_system = [t_system t];
        status_temp(index , 1) = xor(status_temp(index , 1),1);
        status_system = [status_system status_temp];

        if status_temp(index , 1) == 1
            m = -1/lamsystem(index)*log(rand);
            t_branch(index) = t_branch(index) + m;
        else
            r = -1/miusystem(index)*log(rand);
            t_branch(index) = t_branch(index) + r;
        end

    end
    % status_system = status_system';


end

