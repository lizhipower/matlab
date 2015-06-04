function [result] = gcon0(x,bus)

e=0.1;  %结果精度（发电机出力）
for i=1:size(x,2)
    result(i) = abs(sum(x(:,i))-sum(bus(4:6,3)))-e;
end

end
