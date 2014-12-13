%% status_analyse: function description




function [status_rank] = error_rank(status_sgl)
    status_rank = length(find(status_sgl == 0));
end



% [t_system, status_system] = mcyear;

% status_num = length(t_system);
% statu_rank_distribution = [0 , 0 , 0];

% for i = 1:1:status_num
%     status_rank = status_analyse(status_system(:,i));
%     if status_rank == 1
%         statu_rank_distribution(1) = statu_rank_distribution(1) + 1;
%     elseif status_rank == 2
%         statu_rank_distribution(2) = statu_rank_distribution(2) + 1;
%     else
%         statu_rank_distribution(3) = statu_rank_distribution(3) + 1;
%     end
% end


% bar(statu_rank_distribution ./ status_num);