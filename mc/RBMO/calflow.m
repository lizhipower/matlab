function [ F ] = calflow( x,bus,H )

Npop=size(x,2);   %���Ӹ���
F=[];

for i=1:Npop   
    %%%%%%%������·������ʹ��PTDF���������ӣ�%%%%%%%%
    Branch=H*[x(:,i);-bus(4:6,3)];

%     gen(:,2)=x(:,i);
%     [MVAbase,new_bus,new_gen,new_branch,success]=rundcpf(baseMVA,bus,gen,branch);
    
%     if success         
%         F=[F new_branch(:,14)];
%     else
%         sprintf('Error in flow calculation');
%     end
    
    F=[F Branch];  
    Branch=[]; %���    
end

end
