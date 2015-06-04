function [ x ] = reconstruction( x,w,v,vmax,dir,c1,c2,ngen,load,gen,pbest,gbest )

rand('state',sum(100*clock)); % generate variable random numbers with time
index1=find(x(ngen,:)>gen(ngen,9));
index2=find(x(ngen,:)<gen(ngen,10));
index=[index1 index2];
len=size(index,2);

if len>=1
    
    for i=1:len
        
        war=0;
        while index(i)~=0
            
            if war<=10
                for j=1:ngen-1                 
                     %%%重新更新粒子的速度%%%
                     v(j,index(i))= w * v(j,index(i)) + dir*(c1 * rand * (pbest(j,index(i)) - x(j,index(i))) + c2 * rand * (gbest(j) - x(j,index(i))));	%更新速度
                     if v(j,index(i))>vmax(j,index(i))
                        v(j,index(i))=vmax(j,index(i));
                     end
                     if v(j,index(i))<-vmax(j,index(i))
                        v(j,index(i))=-vmax(j,index(i));
                     end
                     %%%重新更新粒子的位置%%%
                     x(j,index(i))=x(j,index(i))+v(j,index(i)); 
                     if x(j,index(i))>gen(j,9)
                        x(j,index(i))=gen(j,9);
                     end
                     if x(j,index(i))<gen(j,10)
                        x(j,index(i))=gen(j,10);
                     end
                end
            else 
                for j=1:ngen-1  
                    x(j,index(i)) = gen(j,10) + rand * (gen(j,9) - gen(j,10));
                end            
            end
         
            x(ngen,index(i))=load-sum(x(1:ngen-1,index(i)));
            if x(ngen,index(i))>=gen(ngen,10) & x(ngen,index(i))<=gen(ngen,9)
                index(i)=0;
            end
             
            war=war+1;
        end
    end

else
    sprintf('No particles need to be reconstructioned！');
        
end

end

