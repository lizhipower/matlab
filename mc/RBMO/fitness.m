%����Ӧֵ��Ŀ�꺯���������÷�������
function [fc,fr,error] = fitness(x,bus,branch,gencost,H,Tk,prob,kc,kl)
Npop=size(x,2);     %���Ӹ���

new_BRANCH=calflow(x,bus,H);     %ʹ��PTDF���������Ӽ���ֱ������

%��ʽԼ����ÿ�����Ӷ�Ӧ1����ʽԼ����
% g0=gcon0(x,bus);

%%%����״̬����ʽԼ��(ÿ�����Ӷ�Ӧ������·��������ʽԼ����
h1=gcon1(new_BRANCH,branch);

%%%%%%����ϵͳ����%%%%%%       Ŀ��2��risk
fr=calrisk(x,Tk,bus,branch,prob,kc,kl);

punishment01  =  10^35;    %cost�ĵ�ʽ������
punishment02  =  10^28;    %risk�ĵ�ʽ������
punishment1  =  10^6;     %cost�Ĳ���ʽ������
punishment2  =  10^8;     %risk�Ĳ���ʽ������

%%%%%%%%�ֱ���ȡNoop�����ӵ���Ӧֵ(COST,EMISSION)%%%%%%%%
for k=1:Npop
    q=[];
    other1(k)=0;  %�洢��ʽԽ��֮��
    other2(k)=0;
    
    %��ʽԼ��Υ���̶�
%     if g0(k)>=0
%        other1(k)=g0(k)*punishment01;
%        other2(k)=g0(k)*punishment02;
%     end
   
    %����ʽԼ��Υ���̶�
    for i=1:size(branch,1)
        q(i)=min(0,-h1(i,k)).^2;
    end 
    
    %����ʽԼ��������Υ���̶�
    error(k)=sum(q);
          
    %Ŀ��1��cost
    fc(k)=calcost(x(:,k),gencost);  
    
    fc(k)=fc(k)+other1(k)+punishment1*error(k);
    fr(k)=fr(k)+other2(k)+punishment2*error(k);   
    error(k)=other1(k)+punishment1*error(k);
end

g0=[];h1=[];other=[];other1=[];other2=[];

end





