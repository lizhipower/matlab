function [t_system, status_system] = dirsam_RTS79;
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%RTS79ϵͳ״̬����
%����������ؿ�����᷽��
%��ϵͳ����bus: [24x13 double]
%          gen: [33x21 double]
%       branch: [38x13 double]
%����1���ڵ�״̬����
%������ؿ������һ�������ֳ�������ֱ�ӷ�&��ӷ�
%��ȡRTS79��ͣ��ģ�Ͳ���

[probline,probgen,lamline,lamgen,miuline,miugen]=failprob10(1);

%lamsystem����[lamline,lamgen]
%miusystem����[minline,mingen]
lamsystem=[lamline,lamgen]/8760;%failprob��lamline,lamgen�ĵ�λ�Ǵ���/��
miusystem=[miuline,miugen]/8760;
n=length(lamsystem);

%����ϵͳԪ����ʼ��������������״̬

%status_branch1=1;
%status_branch2=1;
%status_branch3=1;
status_system(1,:)=ones(1,n);

%һ�η���һ���״̬����
%t_branch������¼����Ԫ����һ״̬�ı��ʱ��
%0ʱ�̼�Ϊ��ʼʱ��


t_system=[];%��¼ϵͳ״̬�ı��ʱ��
t_system(1)=0;
t_branch=zeros(1,n);%��¼ϵͳԪ����һ��״̬�ı��ʱ��


for i=1:n
    R=rand;
    t_branch(i)=-1/lamsystem(i)*log(R);
end

i=1;
while (t_system(i)<=8760)%һ��ʱ��㳬����8760Сʱ�ͽ���
   
    i=i+1;
    t=min(t_branch);
    j=find(t_branch==t);%�ҵ����ȸı�״̬����·���
    
%     for j=1:n %�ҵ����ȸı�״̬����·���
%         if(t_branch(j)==t)
%             break;
%         end
%     end
  
    t_system(i)=t;
    status_system(i,:)=status_system(i-1,:);
    status_system(i,j)=xor(status_system(i,j),1);%�ı�iʱ�̵�ϵͳ״̬��ֻ��jԪ���ı�
    
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

