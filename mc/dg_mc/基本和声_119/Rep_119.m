function OP = Rep_119(OP)
global bus branch
%%
LN = size(branch,1);
k = 1;
F = [k];
A = [];
B = [branch(F(1),1) branch(F(1),2)];
N = 200;
for iter = 1:N
    A = [];
    i = 1;
    while(i <= length(B))
        for j=1:LN
            if (branch(j,1)==B(i))||(branch(j,2)==B(i))
                iss = 1;
                for kk=1:length(F)%是否与F矩阵中已有的支路重合
                    if j==F(kk)
                        iss=0;
                        break
                    end
                end
                for kk = 1:length(B)
                    if (((branch(j,1)==B(i))&&(branch(j,2)==B(kk)))||((branch(j,2)==B(i))&&(branch(j,1)==B(kk))))&&(iss==1)
                        iss = 0;
                        OP(j) = 0;
                        break
                    end
                end
                if iss == 1
                    A = [A j];
                end
            end
        end
        i = i+1;
    end
    %% 修改矩阵F和B
    st = 0;
    for i = 1:length(A)
       if OP(A(i)) == 1
           st = 1;
           break
       end
    end
    j = ceil(length(A)*rand(1));
    while(st == 1)&&j
        if OP(A(j)) == 1
            ssb = 1;
            for i = 1:length(B)    %检查B中是否已存在支路j的首段节点
                if B(i) == branch(A(j),1)
                    ssb = 0;
                    break
                end
            end
            if ssb == 1
                B = [B branch(A(j),1)];
            else
                B = [B branch(A(j),2)];
            end
            F = [F A(j)];
            A = [A(1:j-1) A(j+1:end)];
            break
        end
        j = ceil(length(A)*rand(1));
    end
    if (st==0)&&(~isempty(A))%如果在所有A中都没有开关量为闭合的支路，则在其中随机选取一个作为开关量闭合的支路
        kk=ceil(length(A)*rand(1));
        F=[F A(kk)];
        ssb=1;
        for i=1:length(B)
            if B(i)==branch(A(kk),1)
                ssb = 0;
                break
            end
        end
        if ssb==1
             B=[B branch(A(kk),1)];
        else
             B=[B branch(A(kk),2)];
        end
         OP(A(kk))=1;
         A=[A(1:(kk-1)) A((kk+1):end)];
    end
    iter = iter+1;
end

if (length(B)~=118)||(length(F)~=117)
    OP = ones(1, LN);
    OP(118:end) = 0;

end
        
    
            

