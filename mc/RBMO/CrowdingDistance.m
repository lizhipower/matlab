function [ pareto_front,new_set ] = CrowdingDistance( set,Npop,bus,branch,gencost,H,Tk,prob,kc,kl )
%%%%%%%%%%%%%计算拥挤距离%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set 为超过某数量的最优解集
% Npop 为欲输出最优解集个数

L=size(set,2);
dist=zeros(1,L);     %存储最优解集的距离
dist(1)=inf;
dist(L)=inf;

[fc1,fr1,oth1]= fitness(set,bus,branch,gencost,H,Tk,prob,kc,kl);

all=[fc1' fr1' set'];
%外部最优解排序（按fc1值由小到大）
new_all=sortrows(all,1);

%计算粒子的拥挤距离 
sign_fc=minmax(fc1);    %fc的极值
sign_fr=minmax(fr1);    %fr的极值
for i=2:L-1
   dist(i)= abs(new_all(i+1,1)-new_all(i-1,1))/(sign_fc(2)-sign_fc(1))+abs(new_all(i+1,2)-new_all(i-1,2))/(sign_fr(2)-sign_fr(1));   
end

temp=new_all(:,3:5);
new_set=temp';

%拥挤距离较大的前N位被选取!
[dist,index]=sort(-dist);      %index为排列前的索引（按拥挤距离降序排列）
pareto_front=index(1:Npop);    %获得Npop个非支配解的编号

end
