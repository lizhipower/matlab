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
CDF = [];
for i = 1 : length(hf(:, 1))
    disp(i/length(hf(:, 1)));
    op = ones(1, 37);
    for j = 1 : length(hf(i, :))
        op(hf(i, j)) = 0;
    end
    [load cdf] = dsMC_cdf(op, bus, branch);
    % [a b ] = powerflow( bus, op);
    CDF(i).cdf = cdf;
    ds = [ds a];
end
%
plotcdf(CDF(1).cdf, 'blue');
hold on
plotcdf(CDF(2).cdf, 'green');
plotcdf(CDF(3).cdf, 'red');
hold off

%% plotcdf: function description


