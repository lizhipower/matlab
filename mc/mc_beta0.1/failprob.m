%% output���ݺ���
%probline������·��������
%probgen�������鲻������
%probbr������·����������
%probtr������ѹ����������
%lamline������·������
%lamgen�������������
%lambr������·��������
%lamtr������ѹ��������
%miuline������·�޸���
%miugen���������޸���
%miubbr������·���޸���
%miutr������ѹ���޸���\


%ksrv---������������ϵ��
%ksw---������������ϵ��
%kli---ͨ����·������ϵ��
%kied---IED������


function [probline,probgen]=failprob

[dur,lamline,genmttr,genmttf]=failrate;

%% ����t�ı仯����lamline�����������޸�
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


if nargout<2 %ֻ�����·��������
%% ������·�޸��ʦ̺Ͳ�������U
    miuline=8760./dur;  %��·�޸���,��λΪ��
    probline=lamline./(lamline+miuline);%�������ʣ���λΪ��
else
    %% ������·�޸��ʦ̺Ͳ�������U
    miuline=8760./dur;  %��·�޸���,��λΪ��
    probline=lamline./(lamline+miuline);%�������ʣ���λΪ��

%% ������޸��ʦ̡������ʦ˺Ͳ�������U
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
%%------���Ǽ��޼ƻ�---------------
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
