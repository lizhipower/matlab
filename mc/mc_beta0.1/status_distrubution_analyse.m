clc;
clear('all');

[t_system, status_system] = mcyear;

status_num = length(t_system);
statu_rank_distribution = [0, 0 , 0 , 0 , 0];

for i = 1:1:status_num
    status_rank = error_rank(status_system(:,i));
    if status_rank <= 3
        statu_rank_distribution(status_rank+1) = statu_rank_distribution(status_rank+1) + 1;
    else
        statu_rank_distribution(5) = statu_rank_distribution(5) + 1;
    end
end


bar(statu_rank_distribution ./ status_num);
