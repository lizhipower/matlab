function [ risk ] = calrisk(x,Tk,bus,branch,prob,kc,kl)
Npop=size(x,2);
n=size(branch,1);
s=zeros(n,Npop);  %�洢���ض�
r=zeros(n,Npop);  %�洢����

for i=1:Npop      %ѡ��ĳ�����ӵ�֧·����
    for j=1:n     %ѡ��ĳ��֧·����
        %%%%%%%%%�����i�����ӵ�j����·���Ϻ�������ض�%%%%%%%%%
        tempTk=Tk{1,j};   
        F=tempTk*[x(:,i);-bus(4:6,3)];  
        rating=abs(F./branch(:,6));     %Post_F/Fmax
        
        %�����i�����ӵ�j����·���Ϻ�����֧·�Ĺ������ض�
        for k=1:n
            r1=10*rating(k)-9;
            r2=(9/(kl-1))*rating(k)+1-9/(kl-1);
            r3=(90/(kc-kl))*rating(k)+100-90*kc/(kc-kl);
            r0=[0 r1 r2 r3];
            s(j,i)=s(j,i)+max(r0);
        end
        rating=[];
        %%%%%%%�����i�����ӵ�j����·�Ŀ��Ϸ���%%%%%%%
        r(j,i)=prob(j)*s(j,i);       
    end
    %%%%%%%�����i�����ӵķ���%%%%%%%
    risk(i)=sum(r(:,i));
end
s=[];
    
end
          
          
           
               
           
        
        
        
        
        