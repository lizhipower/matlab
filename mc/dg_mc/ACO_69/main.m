clear;
[bus branch] = testof69();
branchNum = length(branch(:, 1)); %73
busNum = length(bus(:, 1)); %69
OP = ones(1,branchNum);
% OP(69:73) = 0;

% OP(7) = 0;

% OP(69) = 0;OP(14) = 0;OP(58) = 0;OP(72) = 0;OP(61) = 0;
% powerflow(OP)
% pause
branch = decodeOP(OP);
A = formA(branch, busNum);
% size(A)
DSRslt = [];
HMRslt = [];
time = [];
% powerflow(OP)
% pause
for i =1 : 1
    tic
    tau = ones(1,branchNum);

    NA = 60;
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
            DS = [DS; ds];
            V = [V; v];
            oprslt = [oprslt; OP];
            HM = [HM; find(OP == 0)];
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
        f = minDS;
        for i = 1 : branchNum
            tau(i) = tau(i) * lu;
            if OPindex(i) == 1
                tau(i) = tau(i) + Q / f;
            end
        end
    end
    DSRslt = [DSRslt; DSrslt(end, :)]
    HMRslt = [HMRslt; HMrslt(end, :)]
    timetemp = toc;
    time = [time; timetemp]
end
DSRslt
HMRslt
time