function [ judgeRslt ] = isIsland( T , num )
    judgeRslt = 0;
    num
    judgeRslt = doLoop(T, num)

end
function [judgeRslt] = doLoop(T, num)
    while 1
        disp('finding...');
        parentNodeNumList = findParent(T , num)
        if any(parentNodeNumList == 1)
            judgeRslt = 0;
            disp('nomal');
            break
        elseif length(parentNodeNumList) == 0
            judgeRslt = 1;
            disp('island');
            break
        else
            for i = 1 : length(parentNodeNumList)
                judgeRslt = doLoop(T, parentNodeNumList(i));
            end
            break
        end
    end
end

