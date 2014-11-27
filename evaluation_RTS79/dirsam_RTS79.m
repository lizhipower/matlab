function [t_system, status_system] = dirsam_RTS79;
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%RTS79系统状态采样
%基于序贯蒙特卡洛序贯方法
%本系统共有bus: [24x13 double]
%          gen: [33x21 double]
%       branch: [38x13 double]
%考虑1年内的状态序列
%序贯蒙特卡洛仿真一共有两种常见方法直接法&间接法
%读取RTS79的停运模型参数

[probline,probgen,lamline,lamgen,miuline,miugen]=failprob10(1);

%lamsystem——[lamline,lamgen]
%miusystem——[minline,mingen]
lamsystem=[lamline,lamgen]/8760;%failprob中lamline,lamgen的单位是次数/年
miusystem=[miuline,miugen]/8760;
n=length(lamsystem);

%假设系统元件开始都处于正常工作状态

%status_branch1=1;
%status_branch2=1;
%status_branch3=1;
status_system(1,:)=ones(1,n);

%一次仿真一年的状态序列
%t_branch用来记录所有元件下一状态改变点时刻
%0时刻记为开始时刻


t_system=[];%记录系统状态改变点时刻
t_system(1)=0;
t_branch=zeros(1,n);%记录系统元件下一次状态改变点时刻


for i=1:n
    R=rand;
    t_branch(i)=-1/lamsystem(i)*log(R);
end

i=1;
while (t_system(i)<=8760)%一旦时间点超出了8760小时就结束
   
    i=i+1;
    t=min(t_branch);
    j=find(t_branch==t);%找到最先改变状态的线路编号
    
%     for j=1:n %找到最先改变状态的线路编号
%         if(t_branch(j)==t)
%             break;
%         end
%     end
  
    t_system(i)=t;
    status_system(i,:)=status_system(i-1,:);
    status_system(i,j)=xor(status_system(i,j),1);%改变i时刻的系统状态，只有j元件改变
    
    if (status_system(i,j)==1)
        R=rand;
        temp=-1/lamsystem(j)*log(R);
        
        t_branch(j)=t_branch(j)+temp;
    else
       R=rand;
       temp=-1/miusystem(j)*log(R);
        
       t_branch(j)=t_branch(j)+temp;
    end
  
    
end    
 
m=length(t_system);
t_system(m)=8760;  
status_system(m,:)=status_system(m-1,:);
    
   

end

