global bus branch
testof33();
hf = [
    33 34 35 36 37;
    4 8 12 28 36;
    7 9 14 37 32;
    ];

% % ================
% ds = [
    % 202.67;
    % 173.56;
    % 139.55;
% ];
% ==================
loadRslt = [];
v =[];
ds = [];
for i = 1 : length(hf(:, 1))
    % disp(i/length(hf(:, 1)));
    op = ones(1, 37);
    for j = 1 : length(hf(i, :))
        op(hf(i, j)) = 0;
    end
    % loadRslt = [loadRslt dsMC(op, bus, branch)];
    [a b ] = powerflow( bus, op);
    temp = b;
    % v = [v  min(temp(3:end))];
    v(i, :) = temp(3: end);
    min(v(i, :))
    ds = [ds real(a)];
end
% for i = 1 : length(v(:,1))
%     plot(v(i, :));
%     hold on;
% end

plot(v(1,:), 'Marker','diamond','Color','blue');
hold on
plot(v(2,:), 'Marker','square','Color','green');
plot(v(3,:), 'Marker','o','Color','red');
hold off
% real(ds)