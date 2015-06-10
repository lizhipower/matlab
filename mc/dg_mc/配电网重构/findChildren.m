function [ childrenNodeLists ] = findChildren( T, nodeNum )
    childrenNodeLists = [];
    % nodeNum
    for i = nodeNum +1 : length( T(1, :) )
        if T(nodeNum, i) ~= 0
            childrenNodeLists = union(childrenNodeLists, i);
            childrenNodeLists = union(getChildrenLoop(T, i), childrenNodeLists);
        end
    end
end
%% getChildrenLoop: function description
function [children] = getChildrenLoop(T, nodeNum)
    children = [];
    for i = nodeNum + 1 : length( T(1, :))
        if T(nodeNum, i) ~= 0
                children = [children,  i];
            if T(i+1 : end, i) == 1
                break
            else
                children = [children, getChildrenLoop(T, i)];
            end
        end
    end
end

