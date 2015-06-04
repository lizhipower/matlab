function [deltaPQ,Jac,iP,iQ] = DPQ_jac(bus_temp,Ybus)
%���㹦��ƫ��γ��ſɱȾ�����Ӻ���
%---------------------------------------------------
%�ȼ��㹦��ƫ��
%��Pi��Pi����jUiUj(Gijcos��ij+Bijsin��ij )  i=1,2,...n
%��Qi��Qi����jUiUj(Gijsin��ij-Bijcos��ij )
%%
nb=size(bus_temp);
cta=bus_temp(:,3);
U=bus_temp(:,2);
G=real(Ybus);
B=imag(Ybus);
P=bus_temp(:,4);
Q=bus_temp(:,5);
%% %% �γ�delP delQ
iP=0;
iQ=0;
for i=1:nb-1
    addP(i)=0;  %addP(i)=��jUiUj(Gijcos��ij+Bijsin��ij )
    addQ(i)=0;  %addQ(i)=��jUiUj(Gijsin��ij-Bijcos��ij )
    for jl=1:nb
        addP(i)=addP(i)+U(i)*U(jl)*(G(i,jl)*cos(cta(i)-cta(jl))+...
            B(i,jl)*sin(cta(i)-cta(jl)));
        addQ(i)=addQ(i)+U(i)*U(jl)*(G(i,jl)*sin(cta(i)-cta(jl))-...
            B(i,jl)*cos(cta(i)-cta(jl)));
    end
    iP=iP+1;
    DP(iP)=P(i)-addP(i);
    if bus_temp(i,6)==1
        iQ=iQ+1;
        DQ(iQ)=Q(i)-addQ(i);
    end
end
delP=DP';
delQ=DQ';
deltaPQ=[delP;delQ];
%%  �ſ˱Ⱦ���
H=zeros(iP,iP);
N=zeros(iP,iQ);
K=zeros(iQ,iP);
L=zeros(iQ,iQ);
%% H
for i=1:iP
    for jl=1:iP
        if jl~=i
            H(i,jl)=0-U(i)*U(jl)*(G(i,jl)*sin(cta(i)-cta(jl))-...
                B(i,jl)*cos(cta(i)-cta(jl)));
        elseif jl==i
            H(i,jl)=addQ(i)+U(i)^2*B(i,jl);
        end
    end
end
%% N
for i=1:iP
    for jl=1:iQ
        if jl~=i
            N(i,jl)=0-U(i)*U(jl)*(G(i,jl)*cos(cta(i)-cta(jl))+...
                B(i,jl)*sin(cta(i)-cta(jl)));
        elseif jl==i
            N(i,jl)=0-U(i)^2*G(i,jl)-addP(i);
        end
    end
end
%% K
for i=1:iQ
    for j1=1:iP
        if j1~=i
            K(i,j1)= U(i)*U(j1)*(G(i,j1)*cos(cta(i)-cta(j1))+...
                B(i,j1)*sin(cta(i)-cta(j1)));
        elseif j1==i
            K(i,j1)=U(i)^2*G(i,j1)-addP(i);
        end
    end
end
%% L
for i=1:iQ
    for j1=1:iQ
        if j1~=i
            L(i,j1)=0-U(i)*U(j1)*(G(i,j1)*sin(cta(i)-cta(j1))-...
                B(i,j1)*cos(cta(i)-cta(j1)));
        elseif j1==i
            L(i,j1)=U(i)^2*B(i,j1)-addQ(i);
        end
    end
end
%%
Jac=[H,N;K,L];%�γ��ſɱȾ���

end

