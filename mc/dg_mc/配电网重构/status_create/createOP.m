%% createOP: function description
function [OP] = createOP(HM)
    OPlength = 37;
    OP = ones(1, OPlength);
    for i = 1 :    length(HM)
        OPindex = HM(i);
        OP(OPindex) = 0;
    end
    
