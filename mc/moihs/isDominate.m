%% isDominate: function description
function [dominate] = isDominate(HM, HF , x, dim)
    xHF = zeros(1, dim);
    xHF = targetFun(x);
    dominate = 1;
    % lenth = length(HM)
    for i = 1 : length(HF(: , 1))
        % xHF
        % HF
        compare =   xHF < HF(i, :);
        dominateRslt = all(all(compare==1));
        notDominateRslt = all(all(compare==0));
        if dominateRslt == 1
            % disp('dominate');
            dominate = 1 * dominate;
        elseif notDominateRslt == 1;
            % disp('notdominare');

            dominate = -1;
            break
        else
            % disp('equal');

            dominate = 0;
        end        
    end
    % return dominate;
