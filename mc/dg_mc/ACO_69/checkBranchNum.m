function [ branchNum ] = checkBranchNum( Path )
    [bus branch] = testof69();
    branchNum = 0;
    branchNum = length(branch(:, 1));
    for j = 1 : branchNum
        if isequal(Path, branch(j, 1:2)) == 1 || isequal(Path, [branch(j, 2), branch(j, 1)]) == 1
            branchNum = j;
            % pause
        end
    end


end

