function [parentNodeNumList] = findParent(T, nodeNum)
    parentNodeNumList = [];
    for i = 1 : nodeNum - 1
        if T(i, nodeNum) ~= 0
            parentNodeNumList = [parentNodeNumList i];
        end
    end
end
