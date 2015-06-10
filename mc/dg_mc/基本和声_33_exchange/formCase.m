function [ bus , branch] = formCase( bus, branch,  OP )
    branch_temp = [];
    ii = 1;
    for i = 1:length(branch(:, 1))
          if OP(i) == 1
            branch_temp(ii, :) = branch(i, :);
            ii = ii + 1;
        end
    end
    branch = branch_temp;
end

