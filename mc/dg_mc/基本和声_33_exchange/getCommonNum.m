function [ cNum ] = getCommonNum( c1Num, c2Num, rNum )
    cNum = 0;

    for i = 1 : c1Num - 1
        cNum = rNum - i + cNum;
    end
    cNum = cNum + c2Num - c1Num;



end

