function [ risk ] = calrisk(x,Tk,bus,branch,prob,kc,kl)
Npop=size(x,2);
n=size(branch,1);
s=zeros(n,Npop);  %存储严重度
r=zeros(n,Npop);  %存储风险

for i=1:Npop      %选定某个粒子的支路潮流
    for j=1:n     %选定某条支路开断
        %%%%%%%%%计算第i个粒子第j条线路开断后的总严重度%%%%%%%%%
        tempTk=Tk{1,j};   
        F=tempTk*[x(:,i);-bus(4:6,3)];  
        rating=abs(F./branch(:,6));     %Post_F/Fmax
        
        %计算第i个粒子第j条线路开断后其余支路的过载严重度
        for k=1:n
            r1=10*rating(k)-9;
            r2=(9/(kl-1))*rating(k)+1-9/(kl-1);
            r3=(90/(kc-kl))*rating(k)+100-90*kc/(kc-kl);
            r0=[0 r1 r2 r3];
            s(j,i)=s(j,i)+max(r0);
        end
        rating=[];
        %%%%%%%计算第i个粒子第j条线路的开断风险%%%%%%%
        r(j,i)=prob(j)*s(j,i);       
    end
    %%%%%%%计算第i个粒子的风险%%%%%%%
    risk(i)=sum(r(:,i));
end
s=[];
    
end
          
          
           
               
           
        
        
        
        
        