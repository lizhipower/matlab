global bus branch

a = 1 ;
if a== 1 
    testof119();
% bus
    OP = ones(1, length(branch(: , 1)));
    nl = length(branch(: , 1))
    close = [132 131 130 129 126 125 123 75 72 62 53 43 33 27 23];
    for i = 1 : length(close)
        OP(close(i) -1 ) = 0;
    % OP(nl - 13:end) = 0;
    end
% length(OP)
    [ds v] = powerflow_119(bus, OP);
else
    testof33();
% bus
    OP = ones(1, length(branch(: , 1)));
    % OP(33 : end) = 0;
% length(OP)
    [ds v] = powerflow(bus, OP);
end

ds
vnew = v(3 : end);
% for i = 1 : length(vnew)
%     if (vnew(i) > 0.9 )
%         vnew(i)
%         i
%     end
% end
% min(vnew)
% 创建 stem
stem(vnew);
ylim([0.85 1]);
