%% newHarmony: function description
function [x] = newHarmony(dim, HMCR, PAR, HMS, bw, HM, max, min)
    x = zeros(1, dim);
    for i = 1 : dim
        if rand < HMCR
            randIndex = fix(doRand(HMS, 1));
            if rand < PAR
                bwIndex = bw * round( doRand(-1, 1) );

                randIndex = randIndex + bwIndex;
                if randIndex > HMS
                    randIndex = HMS;
                elseif randIndex < 1
                    randIndex = 1;
                end
            end
            x(i) = HM(randIndex , i);
        else
            x(i) = doRand(max, min);
        end
    end