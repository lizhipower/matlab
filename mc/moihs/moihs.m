

max = 2;
min = 0;
MAXlength = 10000;

x = zeros(1 , 1);
dim = length(x);
new_x = zeros(1 , 1);

[HMS HMCR PAR bw] = initial();

HM = zeros(HMS, 1);
HF = zeros(HMS, 1);
 
new_HM = zeros(HMS, 1);
new_HF = zeros(HMS, 1);

%initial HM 
% [HM HF] = newHM(dim, max, min, HMS);

% initial ParetoHM
[HM HF] = newParetoHM(dim, max, min, HMS);

% pause

% update the HM
loopMax = 0;
while (loopMax < MAXlength)
    %create new Harmony
    new_x = newHarmony(dim, HMCR, PAR, length(HM), bw, HM, max, min) ;
    new_xFun =  targetFun(new_x);
    forIndex = 1;
    % while(forIndex ~= length(HM(: , 1))) 
    for j = 1 : length(HM(: ,1))
        % dominateRslt =  isDominate(HM, HF , new_x, dim);
        compareLoop = new_xFun < HF(j, :);
        dominateRsltLoop = all(all(compareLoop==1));
        notDominateRsltLoop = all(all(compareLoop==0));

        if dominateRsltLoop == 1
            % disp('dom');
            HM(j , : ) = new_x;
            HF(j , :) = new_xFun;
            % forIndex = forIndex - 1
           length(HM(: , 1));
           % forIndex = forIndex + 1;
           break
        elseif notDominateRsltLoop == 1
            % disp('notdom');
            % j
            % forIndex = forIndex + 1;
            % break
        else
            % disp('equal');
            HM = [HM; new_x];
            HF = [HF; targetFun(new_x)];
            break
            % forIndex = forIndex + 1;
        end
        
    end
    loopMax = loopMax + 1
end
        

% x = [1 1]
% [a b ] = targetFun(x)


