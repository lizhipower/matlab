function [ ss, rr, qq, best, best_solution ] = vikor( x, fc, fe )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Npop=size(x,2);
solution=[x' fc' fe'];
sign=0;

%%设置目标函数权重
w=[0.6 0.4];
v=0.5;

%%目标函数值归一化处理
sign_fc=minmax(fc);
sign_fe=minmax(fe);
fc=(fc-sign_fc(1))/(sign_fc(2)-sign_fc(1));
fe=(fe-sign_fe(1))/(sign_fe(2)-sign_fe(1));

%%找出正理想解和负理想解
ideal_fc=minmax(fc);
ideal_fe=minmax(fe);

%%求综合评价最优解S，综合评价最劣解R
for i=1:Npop
    S(i)=w(1)*(ideal_fc(1)-fc(i))/(ideal_fc(1)-ideal_fc(2))...
        +w(2)*(ideal_fe(1)-fe(i))/(ideal_fe(1)-ideal_fe(2));
    R(i)=max([w(1)*(ideal_fc(1)-fc(i))/(ideal_fc(1)-ideal_fc(2))...
              w(2)*(ideal_fe(1)-fe(i))/(ideal_fe(1)-ideal_fe(2))]);
end
sign_S=minmax(S);
sign_R=minmax(R);

%%计算各方案产生的利益比率Q
for i=1:Npop
    Q(i)=v*(S(i)-sign_S(1))/(sign_S(2)-sign_S(1))...
        +(1-v)*(R(i)-sign_R(1))/(sign_R(2)-sign_R(1));
end

all=[fc' fe' S'];

%%按S由小到大排列
ss=sortrows(all,3);

%%按R由小到大排列
all=[];
all=[fc' fe' R'];
rr=sortrows(all,3);

%%按Q由小到大排列
all=[];
all=[fc' fe' Q'];
qq=sortrows(all,3);
Q=qq(:,3);

%%%确定折中解
if Q(2)-Q(1)>=1/(Npop-1) 
    t1=qq(1); t2=qq(2);
    for i=1:Npop/3
        if (ss(1)==t1 & ss(2)==t2) | (rr(1)==t1 & rr(2)==t2)
            best=qq(1,:);
            best(1)=best(1)*(sign_fc(2)-sign_fc(1))+sign_fc(1);
            best(2)=best(2)*(sign_fe(2)-sign_fe(1))+sign_fe(1);
            sign=1;
            break;
        end
    end
    
else
    for i=3:Npop
        if Q(i)-Q(1)>=1/(Npop-1)
            best=qq(i,:);
            best(1)=best(1)*(sign_fc(2)-sign_fc(1))+sign_fc(1);
            best(2)=best(2)*(sign_fe(2)-sign_fe(1))+sign_fe(1);
            sign=1;
            break;
        end
    end
    
end

if sign==1
    ind=find(solution(:,4)==best(1)&solution(:,5)==best(2));
    best_solution=solution(ind,:)
else
    best=[];
    fprintf('Cannot find best_solution');
end
    
end

