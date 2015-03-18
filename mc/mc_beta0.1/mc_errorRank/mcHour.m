function [status_system]  =   mcHour
   
    mpc=loadcase('case24_ieee_rts');
    n_bus=length(mpc.bus);
    n_branch=length(mpc.branch);
    n_gen=33;


    mpc=case24_to_opf;
    %读取进行opf的系统参数
    %RTS79系统的总负荷量
    p_load= -sum(mpc.gen(34:50,10)) * 1.1;

    dagger_num = 1;
    K = 1;

    % 利用直接序贯蒙特卡洛方法进行系统状态抽样

    %抽取状态
    % 非序贯抽样
    [lamline , miuline , lamgen, miugen] = faildata;
    % 以小时为单位
    lamsystem = [lamline , lamgen]/8760;
    miusystem = [miuline , miugen]/8760;
    probsystem = lamsystem ./ (lamsystem + miusystem) * 3;

    % 以年为单位
    % lamsystem = [lamline , lamgen];
    % miusystem = [miuline , miugen];
    % probsystem = lamsystem ./ (lamsystem + miusystem);

    ele_num = length(lamsystem);

    status_system_rom = [];

     for dagger_i = 1 : 1 : dagger_num
        dagger_status_system = cal_dagger(rand(1,ele_num) , dagger_num ,K*probsystem);
        status_system = dagger_status_system(dagger_i , :)';
    end


end



