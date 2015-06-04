function front = Pareto_Non_dominated(new_fit,new_rk,new_error)
%寻找最优前沿
front=[];
L=length(new_fit);

for i=1:L
    
    n_set=[]; %第i个粒子如果支配N个个体，且和M个个体无法比较（即至少有一个目标要优优于其它粒子）N+M=L时表示第i个粒子为最优解

    for j=1:L
            if (new_fit(i)<new_fit(j))&(new_rk(i)<new_rk(j))|...
               (new_fit(i)<=new_fit(j))&(new_rk(i)<new_rk(j))|...
               (new_fit(i)<new_fit(j))&(new_rk(i)<=new_rk(j))|...
               (new_fit(i)<=new_fit(j))&(new_rk(i)>new_rk(j))|...
                (new_fit(i)>new_fit(j))&(new_rk(i)<=new_rk(j))|...
               (new_fit(i)<new_fit(j))&(new_rk(i)>new_rk(j))|...
               (new_fit(i)>new_fit(j))&(new_rk(i)<new_rk(j))|...
               (new_fit(i)==new_fit(j))&(new_rk(i)==new_rk(j))
               
               n_set=[n_set,j];  %存储被支配解的编号
            end    
    end
    
    if length(n_set)==L      %如果i是非支配解
       front=[front,i];      %存储该非支配解的编号
    end
    
    n_set=[];   
end

end


    