
function [time,status_time,status] = cal_sys_time(lambda,mu,status,sys_time)
    time_temp = 0;
    i = 1;
    status_time(1) = 0;
    time(1) = 0;

    while (time_temp < sys_time)
        if status(i) == 1
            status_time(i) = -1 / lambda * log(rand());
            time_temp = time_temp + status_time(i);
        else
            status_time(i) = -1 / mu * log(rand());
            time_temp = time_temp + status_time(i);
        end

        i = i + 1;
        status(i) =  abs(status(i-1) - 1);
        time(i) = time_temp;
    end
    % status(i) = [];
end