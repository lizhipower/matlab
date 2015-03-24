%% output数据含义
%probline——线路不可用率
%probgen——机组不可用率
%probbr——断路器不可用率
%probtr——变压器不可用率
%lamline——线路故障率
%lamgen——机组故障率
%lambr——断路器故障率
%lamtr——变压器故障率
%miuline——线路修复率
%miugen——机组修复率
%miubbr——断路器修复率
%miutr——变压器修复率\


%ksrv---服务器故障率系数
%ksw---交换机故障率系数
%kli---通信线路故障率系数
%kied---IED故障率


function [probline,probgen]=failprob

[dur,lamline,genmttr,genmttf]=failrate;

%% 根据t的变化，对lamline作出倍增性修改
% [week,day,hour]=exacttimefun(t);
% hour=(week-1)*7*24+(day-1)*24+hour;
% if hour<9*7*24 || hour>48*7*24
%     lamline=1.8*lamline;    
% elseif (hour>=9*7*24 && hour<22*7*24)
%     lamline=0.2*lamline;    
% elseif (hour>=22 *7*24 && hour<35*7*24)
%     lamline=1.4*lamline;    
% else
%     lamline=0.6*lamline;    
% end 


if nargout<2 %只输出线路不可用率
%% 计算线路修复率μ和不可用率U
    miuline=8760./dur;  %线路修复率,单位为年
    probline=lamline./(lamline+miuline);%不可用率，单位为年
else
    %% 计算线路修复率μ和不可用率U
    miuline=8760./dur;  %线路修复率,单位为年
    probline=lamline./(lamline+miuline);%不可用率，单位为年

%% 机组的修复率μ、故障率λ和不可用率U
  %  mttrp=weeks(1,i)*weekhours;
  %  miugenp(1,i)=8760/mttrp;
   % lamgenp(1,i)=8760/(8760-mttrp);
    miugen=8760./genmttr;
    lamgen=8760./genmttf;
  %  fenzi=lamgen(1,i)*miugenp(1,i)+lamgenp(1,i)*miugen(1,i);
  %  fenmu=fenzi+miugen(1,i)*miugenp(1,i);
    probgen=lamgen./(lamgen+miugen);
%     prob2=mttrp/8760;
%     probgen2(1,i)=1-(1-prob1)*(1-prob2);
%%------考虑检修计划---------------
%    probgen(1,i)=fenzi/fenmu;

end


%% 
%probline(1,3)=0;
%probline(1,8)=0;
%probline(1,13)=0;
%probgen(1,3)=0;   
%probgen(1,4)=0;   
%probgen(1,5)=0;   
%probgen(1,15)=0;   
