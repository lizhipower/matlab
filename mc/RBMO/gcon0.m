function [result] = gcon0(x,bus)

e=0.1;  %������ȣ������������
for i=1:size(x,2)
    result(i) = abs(sum(x(:,i))-sum(bus(4:6,3)))-e;
end

end
