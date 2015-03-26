%% mewParetpHM: function description
function [HM, HF] = newParetoHM(dim, max, min, HMS)
    HM = zeros(1, dim);
    HF = zeros(1, 2);
    x = zeros(1 , dim);

    
    x = newParetoHarmony(dim, max, min);
    HM(1 , :) = x;
    HF(1 , :) = targetFun(x);
    % HF
    % index = 1;
    while (length(HM(: , 1)) < HMS)
        x = newParetoHarmony(dim, max, min);
        dominateRslt =  isDominate(HM, HF , x, dim);
        if dominateRslt == 0
            HM = [HM;  x];
            HF = [HF ; targetFun(x)];
        end

    end 

