%% status_search: function description
function [index] = status_search(status_system,status_sgl)
    status_system_length = length(status_system(1,:));
    flag = 0;
    for i = 1 : 1 : status_system_length
        if isequal(status_system(:,i) , status_sgl)
            index = i;
            flag = 1;
            break;
        end
        if flag == 0
            index = 0;
        end
end
