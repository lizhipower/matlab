function [EndNode] = findEndNode(a)
    EndNode = [];
    for i = 1 : length(a(1, :))
        if a(i, i) == 1 && i ~= 1
            EndNode = union(EndNode, i);
        end
    end
end

