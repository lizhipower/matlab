global bus branch

a = 1 ;
if a== 1 
    testof69();
% bus
    OP = ones(1, length(branch(: , 1)));
    OP(69:end) = 0;
% length(OP)
    [ds v] = powerflow(bus, OP);
else
    testof33();
% bus
    OP = ones(1, length(branch(: , 1)));
    OP(33 : end) = 0;
% length(OP)
    [ds v] = powerflow(bus, OP);
end

ds
vnew = v(3 : end);
% 创建 stem
stem(vnew);
ylim([0.85 1]);
