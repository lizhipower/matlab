%% get_sys_status_time: function description
function [sys_status_time,sys_status] = get_sys_status_time(a_status_time, a_status, b_status_time, b_status, sys_time)
    t_total = 0;
    t = 0;

    i = 1;
    index = 0;

    sys_status(1,1) = a_status(1);
    sys_status(1,2) = b_status(1);
    while (t_total<sys_time)
        [ t index] = min( [a_status_time(1), b_status_time(1)] );

        t_total = t_total + t;


        if index == 1
            a_status_time(1) = [];
            b_status_time(1) = b_status_time(1) - t;
            sys_status(i+1,1) = abs(sys_status(i,1)-1);
            sys_status(i+1,2) = sys_status(i,2);
        else
            b_status_time(1) = [];
            a_status_time(1) = a_status_time(1) - t;
            sys_status(i+1,2) = abs(sys_status(i,2)-1);
            sys_status(i+1,1) = sys_status(i,1);

        end

        i = i + 1;
        sys_status_time(i) = t_total;
    end
    % sys_status(i,:) = [];

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

