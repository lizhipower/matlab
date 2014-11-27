%% get_sysN_status_time: function description
function [sys_status_time,sys_status] = get_sysN_status_time(status_time, status, sys_time)

    t_total = 0;
    t = 0;

    i = 1;
    index = 0;


    if length(status_time) ~= length(status)
        disp('wrong input');
        return;
    else
            ele_num = length(status_time);
    end

    for j=1:1:ele_num
        sys_status(1,j) = status{1,j}(1);
    end

    while (t_total<sys_time)
        for j=1:1:ele_num
            temp_status_time(j) = status_time{1,j}(1);
        end

        [ t index] = min( temp_status_time);

        t_total = t_total + t;

        for j=1:1:ele_num
            status_time{1,j}(1)= status_time{1,j}(1)-t;
            sys_status(i+1,j) = sys_status(i,j);
        end
        status_time{1,index}(1) = [];

        sys_status(i+1,index) = abs(sys_status(i,index)-1);

        i = i + 1;
        sys_status_time(i) = t_total;
    end


end

    % ele_num = numel( ele_sys_status_time(: , 1) )

    % t_total = 0;

    % for i = 1 : 1 : ele_num
    %     sys_status(1,i) = ele_status(i,1);
    % end

    % j = 1;

    % while (t_total < sys_time)
    %     sys_status(j+1 , :) = sys_status(j,:);
    %     t = min(ele_status_time(:,1));
    %     sys_status_time(j) = t;
    %     j = j+1;
    %     [min_row, min_col] = find(ele_status_time(:,1) == t);

    %     for i = 1 : 1 : ele_num
    %         if i == min_row
    %             ele_status_time(i,1) = [];
    %             sys_status(j,i) = abs(sys_status(j,i)-1);
    %         else
    %             ele_status_time(i) = ele_status_time(i) - t;
    %         end
    %     end
    % end

