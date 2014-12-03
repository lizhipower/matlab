%% doTIS: function description
function [t_system_TIS, status_system_TIS] = doTIS(t_system, status_system)
    t_delta = 10;
    t_temp = 0;
    t_system_temp = t_system(1);
    t_system_TIS(1) = 0;
    j = 1;
    num_status = length(t_system);

    for i = 1 : 1 : num_status
        while t_temp <= t_system_temp
            t_temp = t_temp + t_delta;
            status_system_TIS(:,j) = status_system(:,i);
            j = j + 1;
            t_system_TIS(j) = t_temp;
        end
        if i+1 > num_status
            break;
        end
        t_system_temp = t_system(i+1);
    end
    t_system_TIS(j) = [];
end


