function [ nlk,F ] = analysis( x,Tk,bus,branch,kc )
Npop=size(x,2);
n=size(branch,1);
F=cell(1,Npop);
nlk=zeros(Npop,2);

for i=1:Npop
    FK=[];
    for j=1:n     %ѡ��ĳ��֧·����
        sign1=0; sign2=0;
        %%%%%%%%%�����i�����ӵ�j����·���Ϻ�������ض�%%%%%%%%%
        tTk=Tk{1,j};   
        temp=tTk*[x(:,i);-bus(4:6,3)]; 
        FK=[FK temp]; 
        rating=abs(temp./branch(:,6));
        for k=1:n
            if rating(k)>1
                sign1=1;
                if rating(k)>kc
                    sign2=1;
                end
                continue;
            end
        end
        if sign1==1
            nlk(i,1)=nlk(i,1)+1;
        end  
        if sign2==1
            nlk(i,2)=nlk(i,2)+1;
        end
    end  
    F{1,i}=FK;
end
    
end

