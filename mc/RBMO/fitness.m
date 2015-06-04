%求适应值（目标函数），采用罚函数法
function [fc,fr,error] = fitness(x,bus,branch,gencost,H,Tk,prob,kc,kl)
Npop=size(x,2);     %粒子个数

new_BRANCH=calflow(x,bus,H);     %使用PTDF灵敏度因子计算直流潮流

%等式约束（每个粒子对应1个等式约束）
% g0=gcon0(x,bus);

%%%正常状态不等式约束(每个粒子对应所有线路潮流不等式约束）
h1=gcon1(new_BRANCH,branch);

%%%%%%计算系统风险%%%%%%       目标2：risk
fr=calrisk(x,Tk,bus,branch,prob,kc,kl);

punishment01  =  10^35;    %cost的等式罚因子
punishment02  =  10^28;    %risk的等式罚因子
punishment1  =  10^6;     %cost的不等式罚因子
punishment2  =  10^8;     %risk的不等式罚因子

%%%%%%%%分别求取Noop个粒子的适应值(COST,EMISSION)%%%%%%%%
for k=1:Npop
    q=[];
    other1(k)=0;  %存储等式越限之和
    other2(k)=0;
    
    %等式约束违反程度
%     if g0(k)>=0
%        other1(k)=g0(k)*punishment01;
%        other2(k)=g0(k)*punishment02;
%     end
   
    %不等式约束违反程度
    for i=1:size(branch,1)
        q(i)=min(0,-h1(i,k)).^2;
    end 
    
    %不等式约束条件总违反程度
    error(k)=sum(q);
          
    %目标1：cost
    fc(k)=calcost(x(:,k),gencost);  
    
    fc(k)=fc(k)+other1(k)+punishment1*error(k);
    fr(k)=fr(k)+other2(k)+punishment2*error(k);   
    error(k)=other1(k)+punishment1*error(k);
end

g0=[];h1=[];other=[];other1=[];other2=[];

end





