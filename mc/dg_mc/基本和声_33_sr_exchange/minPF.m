function [ OP_Index DS_min  V] = minPF( OP,circle  )
    global bus branch
    OP_temp = OP;

    DS_Rslt = [];
    V_Rslt = [];
    for i = 1 : length(circle)
        OP_temp = OP;
        OP_temp( circle(i) )  = 0;
        [DS, V] = powerflow(bus, OP_temp);
      
        V_Rslt = [V_Rslt min(V(4:end))];
        % DS
        DS_Rslt = [DS_Rslt real(DS)];

    end
    % DS_Rslt
    [DS_min Index_min] = min(DS_Rslt);
    OP_Index = circle(Index_min);
    V = V_Rslt(Index_min);


end

