function [ pareto_front,new_set ] = CrowdingDistance( set,Npop,bus,branch,gencost,H,Tk,prob,kc,kl )
%%%%%%%%%%%%%����ӵ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set Ϊ����ĳ���������Ž⼯
% Npop Ϊ��������Ž⼯����

L=size(set,2);
dist=zeros(1,L);     %�洢���Ž⼯�ľ���
dist(1)=inf;
dist(L)=inf;

[fc1,fr1,oth1]= fitness(set,bus,branch,gencost,H,Tk,prob,kc,kl);

all=[fc1' fr1' set'];
%�ⲿ���Ž����򣨰�fc1ֵ��С����
new_all=sortrows(all,1);

%�������ӵ�ӵ������ 
sign_fc=minmax(fc1);    %fc�ļ�ֵ
sign_fr=minmax(fr1);    %fr�ļ�ֵ
for i=2:L-1
   dist(i)= abs(new_all(i+1,1)-new_all(i-1,1))/(sign_fc(2)-sign_fc(1))+abs(new_all(i+1,2)-new_all(i-1,2))/(sign_fr(2)-sign_fr(1));   
end

temp=new_all(:,3:5);
new_set=temp';

%ӵ������ϴ��ǰNλ��ѡȡ!
[dist,index]=sort(-dist);      %indexΪ����ǰ����������ӵ�����뽵�����У�
pareto_front=index(1:Npop);    %���Npop����֧���ı��

end
