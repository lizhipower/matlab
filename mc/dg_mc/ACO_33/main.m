clear;
[bus branch] = testof33();
branchNum = length(branch(:, 1)); %37
busNum = length(bus(:, 1)); %33
OP = ones(1,branchNum);
% OP(33:37) = 0;
% OP(7) = 0;

% OP(7) = 0;OP(11) = 0;OP(32) = 0;OP(34) = 0;OP(37) = 0;
branch = decodeOP(OP);

A = formA(branch, busNum);
% size(A)
DSRslt = [];
HMRslt = [];
time = [];
for i =1 : 1
    tic
    tau = ones(1,branchNum);

    NA = 30;
    maxLength = 15;
    DSrslt = [];
    OPrslt = [];
    Vrslt = [];
    HMrslt = [];
    for j = 1 : maxLength
        disp(j / maxLength);
        DS = [];
        V = [];
        HM = [];
        oprslt = [];
        for i = 1 : NA
            OP = ACO(A, tau);
            [ds v] = powerflow(OP);
            ds = real(ds);
            v = min(v(3 : end));
            DS = [DS; ds]
            V = [V; v];
            oprslt = [oprslt; OP];
            HM = [HM; find(OP == 0)];


            lu = 0.7;
            Q = 200;
            f = ds;
            for i = 1 : branchNum
                tau(i) = tau(i) * lu;
                if OP(i) == 1
                    tau(i) = tau(i) + Q / f;
                end
            end
        end

        [minDS index] = min(DS);
        Vindex = V(index, :);
        HMindex = HM(index, :);
        OPindex = oprslt(index, :);

        DSrslt = [DSrslt; minDS]
        Vrslt = [Vrslt; Vindex];
        HMrslt = [HMrslt; HMindex]
        OPrslt = [OPrslt; OPindex];

        lu = 0.7;
        Q = 200;
        % [min2 i2] = min(DSrslt);
        % op2 = OPrslt(i2, :);
        % f = min2;

        % f = minDS;
        % for i = 1 : branchNum
        %     tau(i) = tau(i) * lu;
        %     if OPindex(i) == 1
        %         tau(i) = tau(i) + Q / f;
        %     end
        % end
    end
    DSRslt = [DSRslt; DSrslt(end, :)];
    HMRslt = [HMRslt; HMrslt(end, :)];
    timetemp = toc;
    time = [time; timetemp];
end
DSRslt
HMRslt
time