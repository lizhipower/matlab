%% output���ݺ���
%probline������·��������
%probgen�������鲻������
%lamline������·������
%lamgen�������������
%miuline������·�޸���
%miugen���������޸���

function [probline,probgen,lamline,lamgen,miuline,miugen]=failprob10(cas)

if cas==1 %��RTS79
    [dur,lamline,genmttr,genmttf]=failrate;
else %% ��failrate�����ж�ȡRBTS��ԭʼ����
    [dur,lamline,genmttr,genmttf]=failrateRBTS;
end
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
    miugen(find(isinf(miugen)))=0;
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

%% �����ʲ�������

% lamline=lamline*0.8;%-->�����ļ���3
%  afile_flag=3;
% lamline=lamline*0.9;%-->�����ļ���4
%  afile_flag=4;
% lamline=lamline*1.1;%-->�����ļ���5
% afile_flag=5;
% lamline=lamline*1.2;%-->�����ļ���6
%  afile_flag=6;
% lamline=lamline*1.3;%-->�����ļ���7
%  afile_flag=7;
% lamline=lamline*1.4;%-->�����ļ���8
%  afile_flag=8;
% lamline=lamline*1.5;%-->�����ļ���9
%  afile_flag=9;
 lamline=lamline*1.6;%-->�����ļ���10
%  afile_flag=10;
% lamline=lamline*1.7;%-->�����ļ���11
%  afile_flag=11;


%   lamgen=lamgen*0.8;%-->�����ļ���12
%  afile_flag=12;
%   lamgen=lamgen*0.9;%-->�����ļ���13
%  afile_flag=13;
%   lamgen=lamgen*1.1;%-->�����ļ���14
%  afile_flag=14;
%   lamgen=lamgen*1.2;%-->�����ļ���15
%  afile_flag=15;
%   lamgen=lamgen*1.3;%-->�����ļ���16
%  afile_flag=16;
%   lamgen=lamgen*1.4;%-->�����ļ���17
%  afile_flag=17;
%   lamgen=lamgen*1.5;%-->�����ļ���18
%  afile_flag=18;
%   lamgen=lamgen*1.5;%-->�����ļ���19
%  afile_flag=19;
%   lamgen=lamgen*1.5;%-->�����ļ���20
%  afile_flag=20;



