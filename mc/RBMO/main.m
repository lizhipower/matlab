clear all
clc
tic;                 % computering run time

w = 0.5;             % 权重，非常重要
c1 = 2;		         % 加速因子1
c2 = 2;		         % 加速因子2
eta =0.9;	         % 用于更新权重
Npop = 50;          % 粒子个数
ITERA_N = 1000;     % 设置迭代次数

rand('state',sum(100*clock));   % generate variable random numbers with time


%%%%%%%%%%%%%%%%获取测试系统参数%%%%%%%%%%%%%%%%
[baseMVA, bus, gen, branch, gencost] = loadcase('case6');
[i2e, bus, gen, branch] = ext2int(bus, gen, branch);
ngen=size(gen,1);                 %发电机数目
load=sum(bus(4:6,3))              %负荷大小
kc=1.2; kl=1.1;

prob=[0.00016;0.00016;0.00008;0.00008;0.00008;0.00008;0.00024;0.00008;0.00008;0.00008;0.00016];
prob=10.*prob;

%%%%%计算节点注入功率灵敏度因子%%%%
H = makePTDF(baseMVA, bus, branch);

%%%%%计算节点注入功率灵敏度因子（故障状态-线路停运）%%%%%
NL=size(branch,1);
Tk=cell(1,NL);
for i=1:NL
    branch(i,11)=0;   %设置支路i开断
    temp=makePTDF(baseMVA,bus,branch);
    Tk{1,i}=temp;
    branch(i,11)=1;   %支路i状态复位
end

%初始化位置（ngen*Npop个粒子）
x = zeros(ngen,Npop);
for i=1:ngen
    x(i,:) =gen(i,10) + rand(1,Npop) * (gen(i,9) - gen(i,10)); 
end
x(ngen,:)=load-sum(x(1:ngen-1,:));         %计算第N台发电机的初值


%%%%%%%重构粒子位置，保证电力平衡%%%%%%%%
ind1=find(x(ngen,:)>gen(ngen,9));
ind2=find(x(ngen,:)<gen(ngen,10));
ind=[ind1 ind2];
len=size(ind,2);
for i=1:len
    while ind(i)~=0
          for j=1:ngen-1
              x(j,ind(i)) = gen(j,10) + rand * (gen(j,9) - gen(j,10));   %计算N-1维发电机出力
          end
          x(ngen,ind(i))=load-sum(x(1:ngen-1,ind(i)));    %计算第N台发电机的初值
          if x(ngen,ind(i))>=gen(ngen,10) && x(ngen,ind(i))<=gen(ngen,9)
              ind(i)=0;
          end  
    end
end

%%%%%%设定速度最大值（随机产生的，在自变量的范围内）%%%%%%%%
vmax = zeros(ngen,Npop);
for i=1:ngen
    vmax(i,:) = 0.5*(max(x(i,:)) - min(x(i,:)));
end

%初始化速度（ngen*Npop个粒子）
v = zeros(ngen,Npop);
for i=1:ngen
    v(i,:) =  rand(1,Npop) .* vmax(i,:);	
end


%计算初始种群的适应值
[fc,fr,error] = fitness(x,bus,branch,gencost,H,Tk,prob,kc,kl);

pbest = [x; fc; fr; error];    %设定个体初始最佳适应值，Npop个  
gbest=inf*ones(3,1);                  %设定种群初始最佳适应值   

midfront=[]; %temporary front index
mid_set=[];  %temporary optimal solution
front=[];   
front_set=[];


%%%%%initialization complete%%%%%%%
Diversity = zeros(ITERA_N+1,1);
dir       =    1;
DivH      =   0.001;
DivL      =   0.00005;
itera = 0;     % 当前迭代次数


%%%%%%%%%%%%%%%%%%%%%%%种群迭代,寻优%%%%%%%%%%%%%%%%%%%%
while itera <= ITERA_N        % start iteration

	itera = itera + 1;	   	% the times of iteration 
    
    %var求方差，存储平均方差（表征粒子多样性）
    Diversity(itera)  =  ( var(x(1,:))+var(x(2,:))+var(x(1,:)) ) / Npop ;
 
    %[0,1]随机数
    h1 = rand;	h2 = rand;	% random number: h1 and  h2
    
    %根据粒子的多样性情况，对公式的变量赋值
    if Diversity(itera) > DivH  && dir < 0
        dir = 1; 
    elseif Diversity(itera) < DivL && dir > 0
        dir = -1;
    end
        
    %%%更新Npop个粒子的速度与位置%%%
    for i=1:Npop
        for j=1:ngen-1
            %%%更新粒子的速度%%%
            v(j,i)= w * v(j,i) + dir*(c1 * h1 * (pbest(j,i) - x(j,i)) + c2 * h2 * (gbest(j) - x(j,i)));	%更新速度
            if v(j,i)>vmax(j,i)
                v(j,i)=vmax(j,i);
            end
            if v(j,i)<-vmax(j,i)
                v(j,i)=-vmax(j,i);
            end
            %%%更新粒子的位置%%%
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
%     %%%%%%%重构粒子位置,保证电力平衡%%%%%%%%%
    x=reconstruction( x,w,v,vmax,dir,c1,c2,ngen,load,gen,pbest,gbest );
   
	% 计算新种群的适应值
    [new_fc,new_fr,new_error] = fitness(x,bus,branch,gencost,H,Tk,prob,kc,kl);
     
    %%%%%%%%%%%%%更新个体最佳适应值(Pareto支配）非常重要%%%%%%%%%%%%%%%
    for i = 1 : Npop  
       if (new_fc(i)<fc(i))&(new_fr(i)<fr(i))|...
              (new_fc(i)<=fc(i))&(new_fr(i)<fr(i))|...
              (new_fc(i)<fc(i))&(new_fr(i)<=fr(i))
          pbest(:,i) = [x(:,i);new_fc(i);new_fr(i);new_error(i)];
       end
    end
    
    %存储当代种群的信息，以便下次迭代中进行比较
    fc=new_fc;
    fr=new_fr;
    error=new_error;

   
    %%%%%%%%%%%%%%Pareto非支配%%%%%%%%%%%%%
    %获取当前种群在最优前沿上的非支配解的编号 
    midfront = Pareto_Non_dominated(new_fc,new_fr,new_error);
    
    
    %%%%%%%%%%%外部粒子归档与拥挤距离排序%%%%%%%%%%%%
    %如果是第一代
    if itera==1
        front=midfront;            %非支配解的编号
        mid_set=x(:,front);        %非支配解的位置
        front_set=mid_set;         %最优前沿的位置
    
        mid_set=[];%清空
        point=ceil(rand*size(front_set,2));    %从非支配解中任意选择一个作为全局最优解gBest
        gbest=front_set(:,point);              %最优解位置x更新
             
    %如果不是第一代
    else
        mid_set=x(:,midfront);     %非支配解的位置
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        front_set=[front_set mid_set];      %更新最优前沿（可能存在劣解）
        [midf1,midf2,oo]=fitness(front_set,bus,branch,gencost,H,Tk,prob,kc,kl);        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        front=Pareto_Non_dominated(midf1,midf2,oo);      %更新最优前沿（排除劣解）
        temp_set=front_set(:,front);
        midf1=[];  midf2=[];   oo=[];   %%清空
    
        %如果非支配解小于粒子个数
        if size(temp_set,2) < Npop
            front_set=temp_set;
            %从非支配解中任意选择一个作为全局最优解gBest
            point=ceil(rand*size(front_set,2));
            gbest=front_set(:,point);
    
        %如果非支配解个数大于粒子个数
        %拥挤距离排序，排除多于的非支配解，得到Npop个非支配解的编号
        else
            [ind,new_set]=CrowdingDistance(temp_set,Npop,bus,branch,gencost,H,Tk,prob,kc,kl);
            temp_set=new_set;           
            front_set=temp_set(:,ind);   %进行最优解集缩减
     
            %从非支配解中任意选择一个作为全局最优解gBest     
            point=ceil(2+rand*(Npop-4));
%             point=ceil(2+rand*ndims(ind)*0.05);
            gbest=front_set(:,point);
         end

        mid_set=[];%清空
        temp_set=[];
    end
    
    
    %%%%粒子群变异(非常非常重要，有助于全局搜索，避免陷入局部最优，提高结果精度；会增加计算时间）%%%
    x = Mutation( x,Npop,ngen,gen,itera,ITERA_N );
    
    %%%更新权重%%%
    w = w * eta;          
end


%%%%%%%%%%%%%%%%%%%%%%输出pareto前沿%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%画图%%%%%%%%%%%%%%
plot(ofr(:),ofc(:),'b*','LineWidth',0.5,'MarkerSize',8,'MarkerEdgeColor','r'); 
xlabel('风险');
ylabel('费用');
title('帕累托曲线');

front_set   %最优前沿位置（发电出力）
ofc         %发电费用
ofr         %风险
ooth        %误差

% %%%%%%%%%%%调用VIKOR决策支持方法，选择最佳组合解%%%%%%%%%%%%%%
% [s,r,q,best,best_solution]=vikor(front_set,ofc,ofr);
% 
% %%%%%%%%%%%%静态安全分析%%%%%%%%%%%
% 
% %%组合解的静态安全分析结果
% comp=best_solution(1:ngen)
% best_solution(ngen+1)
% best_solution(ngen+2)
% % comp_BRANCH = calflow( comp,bus,H );     %使用PTDF灵敏度因子计算直流潮流
% [n1,comp_N1BRANCH]=analysis(comp',Tk,bus,branch,kc)
% 
% %%COST最优解的静态安全分析结果
% mincost=front_set(:,1)
% ofc(1)
% ofr(1)
% % mincost_BRANCH = calflow( comp,bus,H );     %使用PTDF灵敏度因子计算直流潮流
% [n2,mincost_N1BRANCH]=analysis(mincost,Tk,bus,branch,kc)
% 
% %%RISK最优解的静态安全分析结果
% minrisk=front_set(:,Npop)
% ofc(Npop)
% ofr(Npop)
% % minrisk_BRANCH = calflow( comp,bus,H );     %使用PTDF灵敏度因子计算直流潮流
% [n3,minrisk_N1BRANCH]=analysis(minrisk,Tk,bus,branch,kc)


[n,N1BRANCH]=analysis(front_set,Tk,bus,branch,kc)

toc




