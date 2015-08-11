function [A] = formA(branch, busNum)
    branchNum  = length(branch(:, 1));
    A = zeros(busNum, busNum);
    for i = 1 : busNum
        for j = 1 : branchNum
            tempNum = find(branch(j, 1:2) == i);
            if length(tempNum) ~= 0
                tempBusNum = branch(j, tempNum);
                % if branch(j, 3 - tempNum) > tempBusNum
                A(tempBusNum, branch(j, 3 - tempNum)) = 1;
                % else
                A(branch(j, 3 - tempNum), tempBusNum) = 1;
                % end
                A(tempBusNum, tempBusNum) = A(tempBusNum, tempBusNum) + 1;
            end
        end
    end
end

