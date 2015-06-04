clear all
clc
tic;                 % computering run time

w = 0.5;             % Ȩ�أ��ǳ���Ҫ
c1 = 2;		         % ��������1
c2 = 2;		         % ��������2
eta =0.9;	         % ���ڸ���Ȩ��
Npop = 50;          % ���Ӹ���
ITERA_N = 1000;     % ���õ�������

rand('state',sum(100*clock));   % generate variable random numbers with time


%%%%%%%%%%%%%%%%��ȡ����ϵͳ����%%%%%%%%%%%%%%%%
[baseMVA, bus, gen, branch, gencost] = loadcase('case6');
[i2e, bus, gen, branch] = ext2int(bus, gen, branch);
ngen=size(gen,1);                 %�������Ŀ
load=sum(bus(4:6,3))              %���ɴ�С
kc=1.2; kl=1.1;

prob=[0.00016;0.00016;0.00008;0.00008;0.00008;0.00008;0.00024;0.00008;0.00008;0.00008;0.00016];
prob=10.*prob;

%%%%%����ڵ�ע�빦������������%%%%
H = makePTDF(baseMVA, bus, branch);

%%%%%����ڵ�ע�빦�����������ӣ�����״̬-��·ͣ�ˣ�%%%%%
NL=size(branch,1);
Tk=cell(1,NL);
for i=1:NL
    branch(i,11)=0;   %����֧·i����
    temp=makePTDF(baseMVA,bus,branch);
    Tk{1,i}=temp;
    branch(i,11)=1;   %֧·i״̬��λ
end

%��ʼ��λ�ã�ngen*Npop�����ӣ�
x = zeros(ngen,Npop);
for i=1:ngen
    x(i,:) =gen(i,10) + rand(1,Npop) * (gen(i,9) - gen(i,10)); 
end
x(ngen,:)=load-sum(x(1:ngen-1,:));         %�����N̨������ĳ�ֵ


%%%%%%%�ع�����λ�ã���֤����ƽ��%%%%%%%%
ind1=find(x(ngen,:)>gen(ngen,9));
ind2=find(x(ngen,:)<gen(ngen,10));
ind=[ind1 ind2];
len=size(ind,2);
for i=1:len
    while ind(i)~=0
          for j=1:ngen-1
              x(j,ind(i)) = gen(j,10) + rand * (gen(j,9) - gen(j,10));   %����N-1ά���������
          end
          x(ngen,ind(i))=load-sum(x(1:ngen-1,ind(i)));    %�����N̨������ĳ�ֵ
          if x(ngen,ind(i))>=gen(ngen,10) && x(ngen,ind(i))<=gen(ngen,9)
              ind(i)=0;
          end  
    end
end

%%%%%%�趨�ٶ����ֵ����������ģ����Ա����ķ�Χ�ڣ�%%%%%%%%
vmax = zeros(ngen,Npop);
for i=1:ngen
    vmax(i,:) = 0.5*(max(x(i,:)) - min(x(i,:)));
end

%��ʼ���ٶȣ�ngen*Npop�����ӣ�
v = zeros(ngen,Npop);
for i=1:ngen
    v(i,:) =  rand(1,Npop) .* vmax(i,:);	
end


%�����ʼ��Ⱥ����Ӧֵ
[fc,fr,error] = fitness(x,bus,branch,gencost,H,Tk,prob,kc,kl);

pbest = [x; fc; fr; error];    %�趨�����ʼ�����Ӧֵ��Npop��  
gbest=inf*ones(3,1);                  %�趨��Ⱥ��ʼ�����Ӧֵ   

midfront=[]; %temporary front index
mid_set=[];  %temporary optimal solution
front=[];   
front_set=[];


%%%%%initialization complete%%%%%%%
Diversity = zeros(ITERA_N+1,1);
dir       =    1;
DivH      =   0.001;
DivL      =   0.00005;
itera = 0;     % ��ǰ��������


%%%%%%%%%%%%%%%%%%%%%%%��Ⱥ����,Ѱ��%%%%%%%%%%%%%%%%%%%%
while itera <= ITERA_N        % �Hstart iteration

	itera = itera + 1;	   	% �[the times of iteration 
    
    %var�󷽲�洢ƽ������������Ӷ����ԣ�
    Diversity(itera)  =  ( var(x(1,:))+var(x(2,:))+var(x(1,:)) ) / Npop ;
 
    %[0,1]�����
    h1 = rand;	h2 = rand;	% random number: h1 and  h2
    
    %�������ӵĶ�����������Թ�ʽ�ı�����ֵ
    if Diversity(itera) > DivH  && dir < 0
        dir = 1; 
    elseif Diversity(itera) < DivL && dir > 0
        dir = -1;
    end
        
    %%%����Npop�����ӵ��ٶ���λ��%%%
    for i=1:Npop
        for j=1:ngen-1
            %%%�������ӵ��ٶ�%%%
            v(j,i)= w * v(j,i) + dir*(c1 * h1 * (pbest(j,i) - x(j,i)) + c2 * h2 * (gbest(j) - x(j,i)));	%�����ٶ�
            if v(j,i)>vmax(j,i)
                v(j,i)=vmax(j,i);
            end
            if v(j,i)<-vmax(j,i)
                v(j,i)=-vmax(j,i);
            end
            %%%�������ӵ�λ��%%%
            x(j,i)=x(j,i)+v(j,i); 
            if x(j,i)>gen(j,9)
                x(j,i)=gen(j,9);
            end
            if x(j,i)<gen(j,10)
                x(j,i)=gen(j,10);
            end
        end
    end
     x(ngen,:)=load-sum(x(1:ngen-1,:));
    
    in1=[];ind2=[];ind=[];
%     %%%%%%%�ع�����λ��,��֤����ƽ��%%%%%%%%%
    x=reconstruction( x,w,v,vmax,dir,c1,c2,ngen,load,gen,pbest,gbest );
   
	% ��������Ⱥ����Ӧֵ
    [new_fc,new_fr,new_error] = fitness(x,bus,branch,gencost,H,Tk,prob,kc,kl);
     
    %%%%%%%%%%%%%���¸��������Ӧֵ(Pareto֧�䣩�ǳ���Ҫ%%%%%%%%%%%%%%%
    for i = 1 : Npop  
       if (new_fc(i)<fc(i))&(new_fr(i)<fr(i))|...
              (new_fc(i)<=fc(i))&(new_fr(i)<fr(i))|...
              (new_fc(i)<fc(i))&(new_fr(i)<=fr(i))
          pbest(:,i) = [x(:,i);new_fc(i);new_fr(i);new_error(i)];
       end
    end
    
    %�洢������Ⱥ����Ϣ���Ա��´ε����н��бȽ�
    fc=new_fc;
    fr=new_fr;
    error=new_error;

   
    %%%%%%%%%%%%%%Pareto��֧��%%%%%%%%%%%%%
    %��ȡ��ǰ��Ⱥ������ǰ���ϵķ�֧���ı�� 
    midfront = Pareto_Non_dominated(new_fc,new_fr,new_error);
    
    
    %%%%%%%%%%%�ⲿ���ӹ鵵��ӵ����������%%%%%%%%%%%%
    %����ǵ�һ��
    if itera==1
        front=midfront;            %��֧���ı��
        mid_set=x(:,front);        %��֧����λ��
        front_set=mid_set;         %����ǰ�ص�λ��
    
        mid_set=[];%���
        point=ceil(rand*size(front_set,2));    %�ӷ�֧���������ѡ��һ����Ϊȫ�����Ž�gBest
        gbest=front_set(:,point);              %���Ž�λ��x����
             
    %������ǵ�һ��
    else
        mid_set=x(:,midfront);     %��֧����λ��
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        front_set=[front_set mid_set];      %��������ǰ�أ����ܴ����ӽ⣩
        [midf1,midf2,oo]=fitness(front_set,bus,branch,gencost,H,Tk,prob,kc,kl);        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        front=Pareto_Non_dominated(midf1,midf2,oo);      %��������ǰ�أ��ų��ӽ⣩
        temp_set=front_set(:,front);
        midf1=[];  midf2=[];   oo=[];   %%���
    
        %�����֧���С�����Ӹ���
        if size(temp_set,2) < Npop
            front_set=temp_set;
            %�ӷ�֧���������ѡ��һ����Ϊȫ�����Ž�gBest
            point=ceil(rand*size(front_set,2));
            gbest=front_set(:,point);
    
        %�����֧�������������Ӹ���
        %ӵ�����������ų����ڵķ�֧��⣬�õ�Npop����֧���ı��
        else
            [ind,new_set]=CrowdingDistance(temp_set,Npop,bus,branch,gencost,H,Tk,prob,kc,kl);
            temp_set=new_set;           
            front_set=temp_set(:,ind);   %�������Ž⼯����
     
            %�ӷ�֧���������ѡ��һ����Ϊȫ�����Ž�gBest     
            point=ceil(2+rand*(Npop-4));
%             point=ceil(2+rand*ndims(ind)*0.05);
            gbest=front_set(:,point);
         end

        mid_set=[];%���
        temp_set=[];
    end
    
    
    %%%%����Ⱥ����(�ǳ��ǳ���Ҫ��������ȫ����������������ֲ����ţ���߽�����ȣ������Ӽ���ʱ�䣩%%%
    x = Mutation( x,Npop,ngen,gen,itera,ITERA_N );
    
    %%%����Ȩ��%%%
    w = w * eta;          
end


%%%%%%%%%%%%%%%%%%%%%%���paretoǰ��%%%%%%%%%%%%%%%%%%%%%%
[ofc,ofr,ooth]=fitness(front_set,bus,branch,gencost,H,Tk,prob,kc,kl);
L=Npop;

for i=1:L-1
    for j=i+1:L
        if ofc(i)>ofc(j)
            temp1=ofc(i);temp2=ofr(i);tp=front_set(:,i);
            ofc(i)=ofc(j);ofr(i)=ofr(j);front_set(:,i)=front_set(:,j);
            ofc(j)=temp1;ofr(j)=temp2;front_set(:,j)=tp;
        end
    end
end

%%%%%%%%%%%%%��ͼ%%%%%%%%%%%%%%
plot(ofr(:),ofc(:),'b*','LineWidth',0.5,'MarkerSize',8,'MarkerEdgeColor','r'); 
xlabel('����');
ylabel('����');
title('����������');

front_set   %����ǰ��λ�ã����������
ofc         %�������
ofr         %����
ooth        %���

% %%%%%%%%%%%����VIKOR����֧�ַ�����ѡ�������Ͻ�%%%%%%%%%%%%%%
% [s,r,q,best,best_solution]=vikor(front_set,ofc,ofr);
% 
% %%%%%%%%%%%%��̬��ȫ����%%%%%%%%%%%
% 
% %%��Ͻ�ľ�̬��ȫ�������
% comp=best_solution(1:ngen)
% best_solution(ngen+1)
% best_solution(ngen+2)
% % comp_BRANCH = calflow( comp,bus,H );     %ʹ��PTDF���������Ӽ���ֱ������
% [n1,comp_N1BRANCH]=analysis(comp',Tk,bus,branch,kc)
% 
% %%COST���Ž�ľ�̬��ȫ�������
% mincost=front_set(:,1)
% ofc(1)
% ofr(1)
% % mincost_BRANCH = calflow( comp,bus,H );     %ʹ��PTDF���������Ӽ���ֱ������
% [n2,mincost_N1BRANCH]=analysis(mincost,Tk,bus,branch,kc)
% 
% %%RISK���Ž�ľ�̬��ȫ�������
% minrisk=front_set(:,Npop)
% ofc(Npop)
% ofr(Npop)
% % minrisk_BRANCH = calflow( comp,bus,H );     %ʹ��PTDF���������Ӽ���ֱ������
% [n3,minrisk_N1BRANCH]=analysis(minrisk,Tk,bus,branch,kc)


[n,N1BRANCH]=analysis(front_set,Tk,bus,branch,kc)

toc




