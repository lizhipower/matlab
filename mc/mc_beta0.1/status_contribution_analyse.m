%% status_contribution_analyse: function description
function [LOLP_distribution , statu_rank_distribution , t] = status_contribution_analyse


    [t_system, status_system] = mcyear;

    status_num = length(t_system);
    statu_rank_distribution = [0, 0 , 0 , 0 , 0, 0, 0,0 ,0 ];


    for i = 1:1:status_num
        status_rank = error_rank(status_system(:,i));
        if status_rank <= 7
            statu_rank_distribution(status_rank+1) = statu_rank_distribution(status_rank+1) + 1;
        else
            statu_rank_distribution(8) = statu_rank_distribution(8) + 1;
        end
    end

    LOLP_distribution = status_contribution_cal(t_system , status_system);

    % bar(statu_rank_distribution ./ status_num);