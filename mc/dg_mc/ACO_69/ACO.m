function [ OP ] = ACO( A , tau )
    OP = [];
    [bus branch] = testof69();
    allPath = branch(:, 1:2);
    branchNum = length(branch(:, 1));
    busNum = length(A(1, :));

    OP = zeros(1, branchNum);
    All = 1: busNum;
    S = [1];
    W = setdiff(All, S);
    Path = [];

    while length(S) ~= length(All)
        C = [];
        Cpath = [];
        for j = 1 : length(S)
            busTemp = S(j);
            for i = 1 : busNum
                if A(busTemp, i) == 1 && any(S == i)== 0
                    C = [C, i];
                    Cpath = [Cpath; [busTemp i]];
                end
            end
        end
        % C
        % pause
        %choose a path from S to W
        probDistribution = zeros(1, length(Cpath(:, 1)));
        prob = zeros(1, length(Cpath(:, 1)));
        tauC = [];
        yitaC = [];
        alpha = 1;
        belta = 1.25;
        for i = 1 : length(Cpath(:, 1))
            branchNumC = checkBranchNum(Cpath(i, :));
            tauC = [tauC tau(branchNumC)];
            yitaC = [yitaC 1/branch(branchNumC, 3)];
        end

        prob = (tauC .^ alpha) .* (yitaC .^ belta) / sum((tauC .^ alpha) .* (yitaC .^ belta));
        probDistribution = cumsum(prob, 2) / sum(prob);

        rnd = rand;
        for i = 1 : length(Cpath(:, 1))
            if i == length(Cpath(:, 1))
                chosenNum = length(Cpath(:, 1));
                break;
            elseif i == 1
                if rnd < probDistribution(i)
                    chosenNum = 1;
                    break;
                end
            else
                if rnd < probDistribution(i) && rnd > probDistribution(i-1)
                    chosenNum = i;
                    break;
                end
            end
        end
        chosenPath = Cpath(chosenNum, :);
        % ceil(rand*length(C))
        % chosenPath = Cpath(ceil(rand*length(C)), :);

        chosenC = chosenPath(2);
        Path = [Path; chosenPath];
        S = [S chosenC];
        W = setdiff(W, chosenC);
        if length(S)+length(W) ~= length(All)
            disp('error');
        end
        % S
    end
    % S
    % Path
    for i = 1 : length(Path(:, 1))
        if checkBranchNum(Path(i, :)) ~= 0
            OP(checkBranchNum(Path(i, :))) = 1;
        end
        % for j = 1 : branchNum

        %     if isequal(Path(i, :), branch(j, 1:2)) == 1 || isequal(Path(i, :), [branch(j, 2), branch(j, 1)]) == 1
        %         OP(j) = 1;
        %         % pause
        %     end
        % end
    end
end

