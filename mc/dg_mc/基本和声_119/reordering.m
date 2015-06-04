function [bus_temp,branch_temp,nodenum] = reordering(bus_1,branch_1)
%%
bus_temp = bus_1;
branch_temp = branch_1;
[nb,mb] = size(bus_temp);
[nl,ml] = size(branch_temp);
nSW = 0;
nPQ = 0;
nPV = 0;
for iloop=1:nb
    type=bus_temp(iloop,6); %�ڵ�����,1ΪPQ�ڵ㣬2ΪPV�ڵ㣬3Ϊƽ��ڵ�
    if type==3
        nSW=nSW+1;
        SW(nSW,:)=bus_temp(iloop,:);
    elseif type==2
        nPV=nPV+1;
        PV(nPV,:)=bus_temp(iloop,:);
    else
        nPQ=nPQ+1;
        PQ(nPQ,:)=bus_temp(iloop,:);
    end
end
if nSW == 0
    SW = [];
end
if nPQ == 0
    PQ = [];
end
if nPV == 0
    PV = [];
end
%%
bus_temp = [PQ;PV;SW];
newbus = [1:nb]';
nodenum = [newbus,bus_temp(:,1)];%��������м���֮�󣬻�Ӧ�ðѽڵ�任��ȥ
bus_temp(:,1) = newbus;
%% �������˽ڵ����޸�branch_temp������
for iloop=1:nl
   for jloop=1:2 
       for kloop=1:nb
           if branch_temp(iloop,jloop)==nodenum(kloop,2)
               branch_temp(iloop,jloop)=nodenum(kloop,1);
               break
           end
       end
   end
end
end





        
