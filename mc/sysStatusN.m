clear;
lambda = 1 / 2940;
mu = 1 / 60;

sys_time = 8760;
% time_temp = 0;

a_status(1) = 1;
b_status(1) = 1;

[a_status_totaltime,a_status_time, a_status] = cal_sys_time(lambda,mu,a_status,sys_time);

[b_status_totaltime,b_status_time, b_status] = cal_sys_time(lambda,mu,b_status,sys_time);

status_time = {a_status_time, b_status_time};

status = {a_status, b_status};

[sys_status_time ,sys_status]= get_sysN_status_time(status_time, status, sys_time)

sys_status_dec = sys_status(:,1) .* 2 + sys_status(:,2)
% sys_status_totaltime =
% plot(sys_status)

subplot(3, 1, 1);

stairs(a_status_totaltime,a_status);ylim([0 2]);xlim([0 8760]);

subplot(3, 1, 2);

stairs(b_status_totaltime,b_status);ylim([0 2]);xlim([0 8760]);

subplot(3, 1, 3);

stairs(sys_status_time,sys_status_dec);ylim([0 5]);xlim([0 8760]);