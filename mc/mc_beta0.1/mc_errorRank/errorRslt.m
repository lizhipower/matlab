mpc=loadcase('case24_ieee_rts');
n_bus=length(mpc.bus);
n_branch=length(mpc.branch);
n_gen=33;


mpc=case24_to_opf;
%读取进行opf的系统参数
%RTS79系统的总负荷量
p_load= -sum(mpc.gen(34:50,10)) * 1.1;


busVaCell = ones(1, n_bus)' * 1.05;
busVaGround = ones(1, n_bus)' * 0.95;

busVaError = 0;
% branchRateAError = zeros(1, n_branch)';
branchRateAError = 0;
loop = 1000;


caseRateA = mpc.branch(: , 6) * 0.9 ;

for i = 1 : loop

    if mod(i, loop / 10) == 0
        disp('loading...');
        disp(i/loop);
    end

    status_system = mcHour;

    mpc.branch(:,11) = status_system(1:n_branch);
    % 修改发电机可用信息
    mpc.gen(1:33 , 8) = status_system(39 : 71);


    error_rank_result = error_rank(status_system);


    if error_rank_result >= 2
        mpopt = mpoption( 'VERBOSE', 0, 'OUT_ALL', 0);
        results = runopf(mpc,mpopt);
        % loadcut(i) = p_load + results.f;%切负荷量
        % loadcut_dagger(dagger_i) = p_load + results.f;
        % loadcut((i-1)*dagger_num + dagger_i) = loadcut_dagger(dagger_i);  
        busVa = results.bus(: , 8);
        branchRateA = abs(results.branch(: , 14));



        % if busVa >1.05 || busVa < 0.95
        busVaError =  busVaError + sum(busVa > busVaCell) + sum(busVa < busVaGround);
        % end
        % branchRateAError = branchRateAError + 5 * (branchRateA ./ caseRateA - 0.8);
        branchRateAError = branchRateAError  + sum(branchRateA > caseRateA);
    else
        % loadcut((i-1)*dagger_num + dagger_i) = loadcut_dagger(dagger_i);
        % loadcut_dagger(dagger_i) = 0;
    end

  

end
busVaError
branchRateAError




