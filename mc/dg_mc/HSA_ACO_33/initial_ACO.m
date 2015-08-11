function [ HF, HM, OPL, V ] = initial_ACO( HF, HM, OPL, V, rate_HM )
    global bus branch
    branchNum = length(branch(:, 1)); %37
    busNum = length(bus(:, 1)); %33
    OP_ACO = ones(1,branchNum);
    tau = ones(1,branchNum);
    branch_ACO = decodeOP(OP_ACO);
    A = formA(branch_ACO, busNum);
    NA = 30;
    HMS = length(HF(:, 1));
    disp(HMS);
    for i = 1 : HMS
        disp('stage 1');
        disp(i/HMS);
        if rand > rate_HM
            lu = 0.7;
            Q = 200;
            [minDS,minDSIndex] = min(HF);
            f = minDS;
            OPindex = OPL(minDSIndex, :);
            for i = 1 : branchNum
                tau(i) = tau(i) * lu;
                if OPindex(i) == 1
                    tau(i) = tau(i) + Q / f;
                end
            end
            DS_ACO = [];
            V_ACO = [];
            HM_ACO = [];
            oprslt_ACO = [];
            for i = 1 : NA
                OP_ACO = ACO(A, tau);
                [ds_ACO v_ACO] = powerflow(bus, OP_ACO);
                ds_ACO = real(ds_ACO);
                v_ACO = min(v_ACO(3 : end));
                DS_ACO = [DS_ACO; ds_ACO];
                V_ACO = [V_ACO; v_ACO];
                oprslt_ACO = [oprslt_ACO; OP_ACO];
                HM_ACO = [HM_ACO; find(OP_ACO == 0)];
            end

            [minDS_ACO index_ACO] = min(DS_ACO);
            Vindex_ACO = V_ACO(index_ACO, :);
            OPindex_ACO = oprslt_ACO(index_ACO, :);
            HMindex_ACO = HM_ACO(index_ACO, :);

            [WorstFit,WorstLoc] = max(HF);
            if minDS_ACO < WorstFit
                HM(WorstLoc,:) = HMindex_ACO;
                HF(WorstLoc,:) = minDS_ACO;
                OPL(WorstLoc,:) = OPindex_ACO;
                V(WorstLoc,:) = Vindex_ACO;
            end
        end
    end
end

