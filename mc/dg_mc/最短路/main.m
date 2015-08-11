[bus branch] = testof33();
OP = ones(1,37);
% OP(33:37) = 0;
OP(7) = 0;
OP(11) = 0;
OP(32) = 0;
OP(34) = 0;
OP(37) = 0;

ii = 1;
for i = 1:37
    if OP(i) == 1
        branch_new(ii,:) = branch(i,:);
        ii = ii+1;
    end
end
branch = branch_new;
a = formA(branch, 33);
endNode = findEndNode(a)
[ds v flow] = powerflow(OP)
