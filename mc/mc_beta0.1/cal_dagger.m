%% cal_dagger: function description
function [dagger_status_system] = cal_dagger(dagger_rand , dagger_num ,probsystem)
    % dagger_num = 4;
    dagger_rand_length = length(dagger_rand);
    dagger_status_system = ones(dagger_num , dagger_rand_length);
    for i = 1 : dagger_rand_length
        if dagger_rand(i) <= 1 / dagger_num
            if dagger_rand(i) < probsystem(i)
                dagger_status_system(1,i) = 0;
            end
        elseif dagger_rand(i) <= 2 / dagger_num
            if dagger_rand(i) < 1 / dagger_num + probsystem(i)
                dagger_status_system(2,i) = 0;
            end
        elseif dagger_rand(i) <= 3 / dagger_num
            if dagger_rand(i) < 2 / dagger_num + probsystem(i)
                dagger_status_system(3,i) = 0;
            end
        else
            if dagger_rand(i) < 3 / dagger_num + probsystem(i)
                dagger_status_system(4,i) = 0;
            end
        end
    end
end

