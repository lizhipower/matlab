op = ones(1,32);
op = [op zeros(1,5)];
op(31) = 0;
    [DS, V] = powerflow(bus, op)
             % check the V of OP to find the error load num
             statusV = V(3:end)
             errorLoadNum = statusV == 0