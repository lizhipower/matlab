
%Newton-Raphson����(�ű�)
%% output:tempbus branch_temp Sij Sji DS flow 
%%
[deltaPQ,Jac,iP,iQ]=DPQ_jac(bus_temp,Ybus);
cta=bus_temp(1:iP,3);
U=bus_temp(1:iQ,2);
ctaU=[cta;U];
G=real(Ybus);
B=imag(Ybus);
multiplierU=[ones(iP,1);U];
pre=1.0e-10;%����
kmax=10;%����������
%outputY;%����ڵ㵼�ɾ���
%% ��������
for iloop=1:kmax
    if(max(abs(deltaPQ))<pre)
        break
    end
    DctaU=Jac\deltaPQ;
    DctaU=DctaU.*multiplierU;   %��Ϊģ�����õ����Ǧ�U/U������Ҫ���ϳ���U
    ctaU=ctaU-DctaU;
    cta=ctaU(1:iP);
    U=ctaU(iP+1:iP+iQ);
    multiplierU=[ones(iP,1);U]; %���Ĳ��ֲ��䣬���Գ���1
    bus_temp(1:iP,3)=cta;
    bus_temp(1:iQ,2)=U;
   % output_iterate;%������������е��������
    [deltaPQ,Jac,iP,iQ]=DPQ_jac(bus_temp,Ybus);
end
%% ������PV�ڵ���޹�ע���SW�ڵ���й����޹�ע��
cta=bus_temp(:,3);
U=bus_temp(:,2);
PVQ=0;
SWP=0;
SWQ=0;
nb = length(bus_temp);
nl = length(branch_temp);
for i=1:nb
    if(bus_temp(i,6)==2)
        PVQ=0;
        for jl=1:nb
            PVQ=PVQ+U(i)*U(jl)*(G(i,jl)*sin(cta(i)-cta(jl))-...
                B(i,jl)*cos(cta(i)-cta(jl)));
        end
        bus_temp(i,5)=PVQ;   %�����PV�ڵ��޹�����
    end
end
for jl=1:nb
    SWP=SWP+U(nb)*U(jl)*(G(nb,jl)*cos(cta(nb)-cta(jl))+...
                B(nb,jl)*sin(cta(nb)-cta(jl)));
    SWQ=SWQ+U(nb)*U(jl)*(G(nb,jl)*sin(cta(nb)-cta(jl))-...
                B(nb,jl)*cos(cta(nb)-cta(jl)));
end
bus_temp(nb,4)=SWP;
bus_temp(nb,5)=SWQ;    %���SW�ڵ��޹����й�����
%���ˣ������ÿ���ڵ��ϵĵ�ѹ��ֵ����ǣ��ڵ�ע���й����޹�
%%
%��������·���������
V=U.*cos(cta)+j.*U.*sin(cta);
S=zeros(nl,3);
Sij=S(:,1);
Sji=S(:,2);
DSij=S(:,3);
DS = 0;
for i=1:nl
    li=branch_temp(i,1);
    lj=branch_temp(i,2);
    K=branch_temp(i,7);
    Zt=branch_temp(i,3)+j*branch_temp(i,4);
    if li~=0&lj~=0
        Yt=1/Zt;
    end
    Ym=branch_temp(i,5)+j*branch_temp(i,6);
    if li~=0&lj~=0&K==0    %��ͨ��·
        Iij=V(li)*(Yt+Ym)-V(lj)*Yt;
        Iji=V(lj)*(Ym+Yt)-V(li)*Yt;
        Sij(i)=V(li)*conj(Iij);
        Sji(i)=V(lj)*conj(Iji);
        DSij(i)=Sij(i)+Sji(i);
    elseif li~=0&lj~=0&K>0 %��ѹ����·K��j��
        Iij=V(li)*(Ym+Yt)-V(lj)*(Yt/K);
        Iji=V(lj)*(Yt/(K^2))-V(li)*(Yt/K);
        Sij(i)=V(li)*conj(Iij);
        Sji(i)=V(lj)*conj(Iji);
        DSij(i)=Sij(i)+Sji(i);
    elseif li~=0&lj~=0&K<0 %��ѹ����·K��i��
        Iij=V(li)*(Ym+Yt)-V(lj)*(Yt*K);
        Iji=V(lj)*(Yt*K^2)-V(li)*(Yt*K);
        Sij(i)=V(li)*conj(Iij);
        Sji(i)=V(lj)*conj(Iji);
        DSij(i)=Sij(i)+Sji(i);
    else        %�ӵ���·
        Iij=V(li)*Ym;
        Sij(i)=V(li)*conj(Iij);
        Sji(i)=0;
        DSij(i)=Sij(i)+Sji(i);
    end
    DS=DS+DSij(i);
end
S=[Sij,Sji,DSij];
DS=DS*10000;
branchS=[branch_temp,S];

%% -----------------------------------------------------------
%����ѽڵ�˳��ԭΪԭ����״̬
for i=1:nb
    for k=1:nb
        if nodenum(k,2)==i
            tempbus(i,:)=bus_temp(k,:);
        end
    end
end
tempbus(:,3)=tempbus(:,3).*(180/pi);    %�任Ϊ�Ƕ�
tempbus(:,1)=[1:nb]';
V = [];
for i = 1:nb
    V(i) = tempbus(i,2);
end
Pload_total = 0;
Qload_total = 0;
for i = 2:nb
    Pload_total = Pload_total + tempbus(i,4);
    Qload_total = Qload_total + tempbus(i,5);
end
Pload_total = Pload_total
Qload_total = Qload_total
V = [tempbus(1,4),tempbus(1,5),V]

for i=1:nl
    for k=1:2
        if branchS(i,k)~=0
            branchS(i,k)=nodenum(branchS(i,k),2);
        end
    end
end
branch_temp=branchS(:,1:7);
flow=[branchS(:,1),branchS(:,2),branchS(:,8:10)];


%% Ѱ��Capacitor��ESS�Ľ���λ��
%LSF_P = zeros(1,33);
%LSF_Q = zeros(1,33);
%Ploss = zeros(1,32);
%P_eff = real(flow(1,3));
%Q_eff = imag(flow(1,3));
%R = branch_temp(1,3);
%X = branch_temp(1,4);
%Ploss(1) = (P_eff^2+Q_eff^2)*R/(tempbus(1,1)^2);
%LSF_P(1) = (2*P_eff*R)/(tempbus(1,1)^2);
%LSF_Q(1) = (2*Q_eff*R)/(tempbus(1,1)^2);
%for j = 1:length(flow)
 %   P = real(flow(j,3));
  %  Q = imag(flow(j,3));
   % if P>0
    %    node_from = real(flow(j,1));
     %   node_to = real(flow(j,2));
      %  P_eff = -real(flow(j,4));
       % Q_eff = -imag(flow(j,4));
   % else
    %    node_from = real(flow(j,2));
     %   node_to = real(flow(j,1));
      %  P_eff = -real(flow(j,3));
       % Q_eff = -imag(flow(j,3));
   % end
    %R = branch_temp(j,3);
    %X = branch_temp(j,4);
    %Ploss(j) = (P_eff^2+Q_eff^2)*R/(tempbus(node_to,2)^2);
    %LSF_P(node_to) = (2*P_eff*R)/(tempbus(node_to,2)^2);
    %LSF_Q(node_to) = (2*Q_eff*R)/(tempbus(node_to,2)^2);
%end

%[temp_1,index_1] = sort(LSF_P);
%[temp_2,index_2] = sort(LSF_Q);
%position_1 = [];
%position_2 = [];
%position_1 = index_1(end-2:end);

%count = 0;
%kk = 33;
%while kk >= 1
%    if count >= 3
  %      break
   % else
    %    if tempbus(index_2(kk),2) < 0.95
     %       count = count+1;
      %      position_2 = [position_2 index_2(kk)];
       % end
   % end
    %kk = kk-1;
%end

%disp('end of while')



