%% faildata: lambda and mu
%% output数据含义
%probline――线路不可用率
%probgen――机组不可用率
%probbr――断路器不可用率
%probtr――变压器不可用率
%lamline――线路故障率
%lamgen――机组故障率
%lambr――断路器故障率
%lamtr――变压器故障率
%miuline――线路修复率
%miugen――机组修复率
%miubbr――断路器修复率
%miutr――变压器修复率\


%ksrv---服务器故障率系数
%ksw---交换机故障率系数
%kli---通信线路故障率系数
%kied---IED故障率
function [lamline , miuline , lamgen , miugen] = faildata(arg)

[dur,lamline,genmttr,genmttf]=failrate;

if nargout<3 %只输出线路lambda mu
    miuline=8760./dur;  %线路修复率,单位为年
else
    %% 计算线路修复率μ和不可用率U
    miuline=8760./dur;  %线路修复率,单位为年
    miugen=8760./genmttr;
    lamgen=8760./genmttf;
end
