function [ isolated ] = findIsolated( T )
    isolated = [];
    isolatedAreaEnd = [];
    isolatedPoint = [];

    T_num = length(T(1, :));

    for i = 1 : T_num
        if (T(i, i) == 0)
            isolatedPoint = [isolatedPoint i];
        elseif (T(i, i) == 1 && i ~= 1 && any(isolated == i)==0)
            if isIsland(T, i) == 1
                isolatedAreaEnd = [isolatedAreaEnd i];
            end
        end
    end

    % isolatedAreaEnd
    isolatedChildren = [];
    for i = length(isolatedAreaEnd) : -1 : 1
        % isolatedAreaEnd(i)
        isolatedChildren = union(isolatedChildren, getAreaLoop(T, isolatedAreaEnd(i)));
    end
    isolated = union(isolatedPoint, isolatedAreaEnd);
    isolated = union(isolated, isolatedChildren);

end

function [isolatedChildren] = getAreaLoop(T, nodeNum)
    isolatedChildren = [];
    while 1
        % disp('find parentNodeLists');
        parentNodeLists = findParent(T, nodeNum);
        isolatedChildren = union(isolatedChildren, parentNodeLists);
        if (checkRootPoint(T, parentNodeLists) == 1)
            % disp('root found');
            break
        else
            for i = 1 : length(parentNodeLists)
                isolatedChildren = union(isolatedChildren, getAreaLoop(T, parentNodeLists(i)));
            end
            break
        end
    end
end

%% checkRootPoint: function description
function [hasRoot] = checkRootPoint(T, parentNodeLists)
    hasRoot = 0;

    for i = 1 : length(parentNodeLists)
        isRoot = 0;

        for j = 1 : parentNodeLists(i) - 1
            if T(parentNodeLists(i), j) ~= 0
                isRoot = 1;
                break
            end
        end

        if isRoot == 1
            hasRoot = 1;
            break
        end

    end
end
