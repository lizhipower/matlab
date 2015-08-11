function [init_HM,init_OPL] = initial(HMS,Dim)

    global bus branch round1 round2 round3 round4 round5
    s = length(branch(:,1));
    init_HM = ones(HMS,Dim);
    init_OPL = [];
    % duan_kai = [7 7 7 7 7];
    %Ploss=zeros(1,HMS);
    for i = 1:HMS
        % while length(find(duan_kai == 7)) ~= 0
        init;
        % end
        duan_kai;
        % INIT
        % pause

        init_HM(i,:) = duan_kai;
        init_OPL(i,:) = INIT;

        init_OPL(i,:) = Rep(init_OPL(i,:));
    %    Ploss(i) = powerflow_1(init_OPL(i,:));
         %init_OPL(i,:) = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
    end
    %init_OPL(HMS,:) = [1,1,1,1,1,1,0,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1];
    %init_HM(HMS,:) = [7,9,14,32,28];
end
