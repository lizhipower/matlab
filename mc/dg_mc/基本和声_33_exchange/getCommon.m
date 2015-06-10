function [ c ] = getCommon( r, rNum )
    for i = 1 : rNum - 1
        for j = i + 1 : rNum
            cNum = getCommonNum(i, j, rNum);
            c(cNum).common = intersect(r(i).round, r(j).round);
        end
    end
end

