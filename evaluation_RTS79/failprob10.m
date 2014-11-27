%% output数据含义
%probline——线路不可用率
%probgen——机组不可用率
%lamline——线路故障率
%lamgen——机组故障率
%miuline——线路修复率
%miugen——机组修复率

function [probline,probgen,lamline,lamgen,miuline,miugen]=failprob10(cas)

if cas==1 %读RTS79
    [dur,lamline,genmttr,genmttf]=failrate;
else %% 从failrate函数中读取RBTS的原始数据
    [dur,lamline,genmttr,genmttf]=failrateRBTS;
end
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
    miugen(find(isinf(miugen)))=0;
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

%% 故障率参数调整

% lamline=lamline*0.8;%-->数据文件夹3
%  afile_flag=3;
% lamline=lamline*0.9;%-->数据文件夹4
%  afile_flag=4;
% lamline=lamline*1.1;%-->数据文件夹5
% afile_flag=5;
% lamline=lamline*1.2;%-->数据文件夹6
%  afile_flag=6;
% lamline=lamline*1.3;%-->数据文件夹7
%  afile_flag=7;
% lamline=lamline*1.4;%-->数据文件夹8
%  afile_flag=8;
% lamline=lamline*1.5;%-->数据文件夹9
%  afile_flag=9;
 lamline=lamline*1.6;%-->数据文件夹10
%  afile_flag=10;
% lamline=lamline*1.7;%-->数据文件夹11
%  afile_flag=11;


%   lamgen=lamgen*0.8;%-->数据文件夹12
%  afile_flag=12;
%   lamgen=lamgen*0.9;%-->数据文件夹13
%  afile_flag=13;
%   lamgen=lamgen*1.1;%-->数据文件夹14
%  afile_flag=14;
%   lamgen=lamgen*1.2;%-->数据文件夹15
%  afile_flag=15;
%   lamgen=lamgen*1.3;%-->数据文件夹16
%  afile_flag=16;
%   lamgen=lamgen*1.4;%-->数据文件夹17
%  afile_flag=17;
%   lamgen=lamgen*1.5;%-->数据文件夹18
%  afile_flag=18;
%   lamgen=lamgen*1.5;%-->数据文件夹19
%  afile_flag=19;
%   lamgen=lamgen*1.5;%-->数据文件夹20
%  afile_flag=20;



