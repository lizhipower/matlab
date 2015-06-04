
function Ybus = admittance_matrix(bus_temp,branch_temp)
%%
[nb,mb]=size(bus_temp);
[nl,ml]=size(branch_temp);
% nb
% nl

Ybus = zeros(nb,nb);
%%
for k = 1:nl
    I = branch_temp(k,1);  
    I = find(bus_temp(:, 1) == I);
    J = branch_temp(k,2);
    J = find(bus_temp(:, 1) == J);

    Zt = branch_temp(k,3) + j * branch_temp(k,4); 
    if I ~= 0 & J~= 0
        Yt = 1 / Zt;
    end
    Ym = branch_temp(k,5) + j *branch_temp(k,6);
    K = branch_temp(k,7);             
    if(K==0)&(J~=0)   
        Ybus(I,I)=Ybus(I,I)+Yt+Ym;
        Ybus(J,J)=Ybus(J,J)+Yt+Ym;
        Ybus(I,J)=Ybus(I,J)-Yt;
        Ybus(J,I)=Ybus(I,J);
    end
    if(K==0)&(J==0)        
        Ybus(I,I)=Ybus(I,I)+Ym;
    end
    
    if K>0                        
        Ybus(I,I)=Ybus(I,I)+Yt+Ym;
        Ybus(J,J)=Ybus(J,J)+Yt/K/K;
        Ybus(I,J)=Ybus(I,J)-Yt/K;
        Ybus(J,I)=Ybus(I,J);
    end
    
    if K<0                      
        Ybus(I,I)=Ybus(I,I)+Yt+Ym;
        Ybus(J,J)=Ybus(J,J)+K*K*Yt;
        Ybus(I,J)=Ybus(I,J)+K*Yt;
        Ybus(J,I)=Ybus(I,J);
    end
end
end

    
    
