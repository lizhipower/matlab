function [ DS_index Open  V_index] = branch_exchange( OP_open, r )
    global bus branch
    OP_rslt = [];
    DS_rslt = [];
    V_rslt = [];
    OP = ones(1, length(branch(: , 1)));
    for i = 1 : length(OP_open)
        OP(OP_open(i)) = 0;
    end

    for i= 1:5
        OP_temp = OP;
        OP_temp(OP_open(i) ) = 1;
        [OP_Index, DS_min, V]  = minPF(OP_temp, r(i).round);
        OP_rslt = [OP_rslt OP_Index];
        DS_rslt = [DS_rslt DS_min];
        V_rslt = [V_rslt V];
    end

    [DS_index index] = min(DS_rslt);
    Close_index = OP_open(index);
    OP_index = OP_rslt(index);
    OP_open(index) = OP_index;
    Circle_Exchange = index;
    V_index = V_rslt(index);

    Open = OP_open;

end

