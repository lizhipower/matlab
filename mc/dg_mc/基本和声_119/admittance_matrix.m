%% 形成节点导纳矩阵
function Ybus = admittance_matrix(bus_temp,branch_temp)
%%
[nb,mb]=size(bus_temp);
[nl,ml]=size(branch_temp);
Ybus = zeros(nb,nb);%对导纳矩阵赋初值0，一个nb阶零矩阵
%%
for k = 1:nl
    I = branch_temp(k,1);                  %读入线路参数
    J = branch_temp(k,2);
    Zt = branch_temp(k,3) + j * branch_temp(k,4); %Zt=R+jX
    if I ~= 0 & J~= 0
        Yt = 1 / Zt;
    end
    Ym = branch_temp(k,5) + j *branch_temp(k,6);
    K = branch_temp(k,7);                 %变比
    if(K==0)&(J~=0)   %变通线路：K＝0（即没有变压器）
                      %且J！＝0（即不是对地支路）
        Ybus(I,I)=Ybus(I,I)+Yt+Ym;
        Ybus(J,J)=Ybus(J,J)+Yt+Ym;
        Ybus(I,J)=Ybus(I,J)-Yt;
        Ybus(J,I)=Ybus(I,J);
    end
    if(K==0)&(J==0)                %对地支路
        Ybus(I,I)=Ybus(I,I)+Ym;
    end
    
    if K>0                        %变压器线路：Zt和Ym为折算到i侧的值，K在j侧
        Ybus(I,I)=Ybus(I,I)+Yt+Ym;
        Ybus(J,J)=Ybus(J,J)+Yt/K/K;
        Ybus(I,J)=Ybus(I,J)-Yt/K;
        Ybus(J,I)=Ybus(I,J);
    end
    
    if K<0                        %变压器线路：Zt和Ym为折算到i侧的值，K在i侧
        Ybus(I,I)=Ybus(I,I)+Yt+Ym;
        Ybus(J,J)=Ybus(J,J)+K*K*Yt;
        Ybus(I,J)=Ybus(I,J)+K*Yt;
        Ybus(J,I)=Ybus(I,J);
    end
end
end

    
    
