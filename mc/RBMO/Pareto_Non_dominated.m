function front = Pareto_Non_dominated(new_fit,new_rk,new_error)
%Ѱ������ǰ��
front=[];
L=length(new_fit);

for i=1:L
    
    n_set=[]; %��i���������֧��N�����壬�Һ�M�������޷��Ƚϣ���������һ��Ŀ��Ҫ�������������ӣ�N+M=Lʱ��ʾ��i������Ϊ���Ž�

    for j=1:L
            if (new_fit(i)<new_fit(j))&(new_rk(i)<new_rk(j))|...
               (new_fit(i)<=new_fit(j))&(new_rk(i)<new_rk(j))|...
               (new_fit(i)<new_fit(j))&(new_rk(i)<=new_rk(j))|...
               (new_fit(i)<=new_fit(j))&(new_rk(i)>new_rk(j))|...
                (new_fit(i)>new_fit(j))&(new_rk(i)<=new_rk(j))|...
               (new_fit(i)<new_fit(j))&(new_rk(i)>new_rk(j))|...
               (new_fit(i)>new_fit(j))&(new_rk(i)<new_rk(j))|...
               (new_fit(i)==new_fit(j))&(new_rk(i)==new_rk(j))
               
               n_set=[n_set,j];  %�洢��֧���ı��
            end    
    end
    
    if length(n_set)==L      %���i�Ƿ�֧���
       front=[front,i];      %�洢�÷�֧���ı��
    end
    
    n_set=[];   
end

end


    