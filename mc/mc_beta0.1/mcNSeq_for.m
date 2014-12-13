
function [LOLP, beta_LOLP] = mcNSeq_for(dagger_num)

    mpc=loadcase('case24_ieee_rts');
    n_bus=length(mpc.bus);
    n_branch=length(mpc.branch);
    n_gen=33;


    mpc=case24_to_opf;

    p_load= -sum(mpc.gen(34:50,10)) * 1.1;

    nseq_circle_times = 20;

    nseq_loop_times = 100;

    beta = 0.1;
    % dagger_num = 4;

    N = nseq_circle_times;

    time=zeros(1,N);
    n=zeros(1,N);

    dura=zeros(1,N);
    lolp=zeros(1,N);
    epns=zeros(1,N);
    DURA=zeros(1,N);

    LOLP=zeros(1,N);
    EPNS=zeros(1,N);

    V_LOLP=zeros(1,N);
    V_EPNS=zeros(1,N);



    beta_LOLP=ones(1,N);
    beta_EPNS=zeros(1,N);

    method = 1;
    for j=1:N

        status_repeat(j) = 0;
        tic

        [lamline , miuline , lamgen, miugen] = faildata;

        lamsystem = [lamline , lamgen]/8760;
        miusystem = [miuline , miugen]/8760;
        probsystem = lamsystem ./ (lamsystem + miusystem);

        ele_num = length(lamsystem);

        K = 1.6765;


        N1 = 0;
        N0 = 0;
        prob_average = mean(probsystem);

        n(j) = nseq_loop_times;

        loadcut = zeros(1,n(j));

        status_system_rom = [];
        disp(sprintf('stage %d of %d, loading...\n',j,N ));

        for i = 1 : n(j)
            dagger_status_system = cal_dagger(rand(1,ele_num) , dagger_num ,K*probsystem);
            for dagger_i = 1 : 1 : dagger_num
                status_system = dagger_status_system(dagger_i , :)';


                if isempty(status_system_rom) == 1
                    status_system_rom = status_system;
                else
                    status_system_rom = [status_system_rom status_system];
                end

                mpc.branch(:,11) = status_system(1:n_branch);

                mpc.gen(1:33 , 8) = status_system(39 : 71);

                search_result = status_search(status_system_rom,status_system);
                error_rank_result = error_rank(status_system);
                if search_result < (i-1) * dagger_num + dagger_i

                    loadcut(i) = loadcut(search_result);
                    loadcut_dagger(dagger_i) = loadcut(search_result);
                    loadcut((i-1)*dagger_num + dagger_i) = loadcut_dagger(dagger_i);
                    status_repeat(j) = status_repeat(j) + 1 ;
                else

                    if error_rank_result >= 0
                        mpopt = mpoption( 'VERBOSE', 0, 'OUT_ALL', 0);
                        results = runopf(mpc,mpopt);

                        loadcut_dagger(dagger_i) = p_load + results.f;
                        loadcut((i-1)*dagger_num + dagger_i) = loadcut_dagger(dagger_i);
                    else
                        loadcut((i-1)*dagger_num + dagger_i) = loadcut_dagger(dagger_i);
                        loadcut_dagger(dagger_i) = 0;
                    end
                end

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


                if(loadcut_dagger(dagger_i) >= 1)
                    F_lolp_dagger(dagger_i) = 1 * K_multiNum;
                    F_epns_dagger(dagger_i) = loadcut_dagger(dagger_i) * K_multiNum;

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


        lolp(j) = lolp(j) / n(j);
        epns(j) = epns(j) / n(j);



        LOLP(j) = 1 / j * sum(lolp(1:j));
        EPNS(j) = 1 / j * sum(epns(1:j));


        V_LOLP(j) = std(lolp(1:j));
        V_EPNS(j) = std(epns(1:j));


        beta_LOLP(j) = V_LOLP(j) / LOLP(j) / sqrt(j);
        beta_EPNS(j) = V_EPNS(j) / EPNS(j) / sqrt(j);

        if (j == 1)
           time(j) = toc;
        else
           time(j) = time(j-1)+toc;
        end

        j = j + 1;
    end


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
    cal_cost = time(j-1)
    disp('it is OK!');




