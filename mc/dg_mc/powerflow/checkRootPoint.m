function [hasRoot] = checkRootPoint(T, parentNodeLists)
    hasRoot = 0;

    for i = 1 : length(parentNodeLists)
        isRoot = 1;
        for j = 1 : parentNodeLists(i) - 1
            if T(j, parentNodeLists(i)) ~= 0
                isRoot = 0;
                break
            end
        end

        if isRoot == 1
            hasRoot = 1;
            break
        end

    end
end