function [DS,V] = powerflow(OP)
global bus branch
%testof33();
bus_temp = bus;
branch_temp = branch;
%%
ii = 1;
for i = 1:length(branch_temp(:, 1))
      if OP(i) == 1
        branch_new(ii, :) = branch_temp(i, :);
        ii = ii + 1;
    end
end

branch_temp = branch_new;
% branch_temp = branch_new;

%% ½ÚµãÖØÐÂ±àºÅ
%½ÚµãµÄË³Ðò£ºÆ½ºâ½Úµã¡¢PQ½Úµã¡¢PV½Úµã
[bus_temp,branch_temp,nodenum] = reordering(bus_temp,branch_temp);

%% ÐÎ³É½Úµãµ¼ÄÉ¾ØÕó
Ybus = admittance_matrix(bus_temp,branch_temp);
NRloop;

end

