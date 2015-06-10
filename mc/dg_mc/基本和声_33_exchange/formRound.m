function [ r ] = formRound( Open, bus, branch )
    rNum = length(Open);
    r = [];
    OP = ones(1, length(branch(:, 1) ) );
    for i = 1 : rNum
        OP(Open(i)) = 0;
    end
    
    for i = 1 : rNum

        OP(Open(i))  = 1;
        [ bus_temp, branch_temp] = formCase( bus, branch, OP);
        T = formT(bus_temp, branch_temp);
        % Open
        r(i).round = getRound( T , Open, i);
        % r(i).round
        OP(Open(i))  = 0;

    end


end

