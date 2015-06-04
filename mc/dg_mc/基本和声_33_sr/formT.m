function [ T ] = formT( bus, branch )
    num_bus = length(bus(:, 1));
    num_branch = length(branch(: , 1));
    T = zeros(num_bus, num_bus);
    branchTopology = branch( : , 1 : 2);
    for i = 1 : num_branch
        col_num = branchTopology(i , 1);
        row_num = branchTopology(i , 2);
        
        T(col_num, col_num) = T(col_num, col_num) + 1;
        T(row_num, row_num) = T(row_num, row_num) + 1;
        
        T(col_num, row_num) = T(col_num, row_num) + 1;
    end


end

