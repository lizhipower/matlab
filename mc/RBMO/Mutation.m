function [ x ] = Mutation( x,Npop,ngen,gen,itera,ITERA_N )

    rand('state',sum(100*clock));
    mp=0.5; xb=1;    %变异率
    
        for i=1:Npop
             for j=1:xb
                  sign=ceil(rand*ngen);
                  del=((gen(sign,9)-gen(sign,10))*(1.0-itera*mp/ITERA_N)^2)/5;
                  ub=x(sign,i)+del;
                  lb=x(sign,i)-del;
                  if lb<gen(sign,10)
                      lb=gen(sign,10);
                  end
                  if ub>gen(sign,9)
                      ub=gen(sign,9);
                  end
                  x(sign,i)=unifrnd(lb,ub,1,1);   %产生变异的位置x 
             end
        end



end

