%% statusMC: function description
function[loadRslt cdfPLoad] = dsMC(OP, bus)
    disp('3');
        OPlength = length(OP);
        statusOP = zeros(1, OPlength);
        zeroPosition = find(OP == 0);

        busNum = 33;
        standardLoad = ones(1, busNum);

        busPLoad = bus(: , 4);
        busQLoad = bus(: , 5);



         %delete the info of closed line
        tempOP = OP;
        tempOP(tempOP==0)=[];

        yearLoop = 1000

        PLoad = zeros(1, yearLoop);
        QLoad = zeros(1, yearLoop);
        PLOAD = zeros(1, yearLoop);
        QLOAD = zeros(1, yearLoop);

        V_PLOAD = zeros(1, yearLoop);
        V_QLOAD = zeros(1, yearLoop);

        beta_PLOAD = zeros(1, yearLoop);
        beta_QLOAD = zeros(1, yearLoop);

        timecost = zeros(1, yearLoop);
        % maxPload = 0;
        % cdfPLoad = zeros(1 ,7);
        cdfPLoad = [];
        for  k = 1 : yearLoop
            % tic;
            if mod(k, yearLoop/10) == 0
                disp('loading...');
                disp(k/yearLoop);
            end
             %change the status of the open line by MC
            [ t_system , status_system ] = dsMCyear(tempOP);
            loopLength = length(t_system);

            sumPLoad = 0;
            sumQLoad = 0;

            % PLoad = 0;
            % QLoad = 0;

            % per malfunction

            for j = 1 : loopLength - 1
                 tempOP = status_system(:, j)';
                 %add the info of closed line back to the OP
                 zeroPositionIndex = 1;
                 tempOPIndex = 1;
                 for i = 1 : OPlength
                     if i ==  zeroPosition(zeroPositionIndex)
                         statusOP(i) = 0;
                         zeroPositionIndex = zeroPositionIndex + 1;
                     else
                         statusOP(i) = tempOP(tempOPIndex);
                         tempOPIndex = tempOPIndex + 1;
                     end

                     if zeroPositionIndex > length(zeroPosition)
                        zeroPositionIndex = 1;
                    elseif tempOPIndex > length(tempOP)
                        tempOPIndex = 1;
                    end
                 end


                 % cal the NRloop of the OP
                 [DS, V] = powerflow(bus, statusOP);

                 % check the V of OP to find the error load num

                 statusV = V(1 , 3:end);
                 errorLoadNum = statusV > 1.1 * standardLoad;

                 %sum the load of all the error num load
                 totalPLoad = sum(errorLoadNum' .* busPLoad) * (t_system(j+1)-t_system(j));
                 totalQLoad = sum(errorLoadNum' .* busQLoad) * (t_system(j+1)-t_system(j));

                 % if maxPload < abs(totalPLoad)
                 %     maxPload = abs(totalPLoad)
                 % end
                 absPLoad = abs(totalPLoad);
                 cdfPLoad = [cdfPLoad absPLoad ];
                %  if absPLoad > 0 && absPLoad < 0.0001
                %     cdfPLoad(1, 1) = cdfPLoad(1, 1)  + 1;
                % % elseif absPLoad < 0.005
                % %     cdfPLoad(1, 2) = cdfPLoad(1, 2)  + 1;
                % elseif absPLoad < 0.001
                %     cdfPLoad(1, 2) = cdfPLoad(1, 2) + 1;
                % % elseif absPLoad < 0.05
                % %     cdfPLoad(1, 4) = cdfPLoad(1, 4) + 1;
                % elseif absPLoad < 0.01
                %     cdfPLoad(1, 3) = cdfPLoad(1,3) + 1;
                % % elseif absPLoad < 0.5
                % %     cdfPLoad(1, 6) = cdfPLoad(1,6) + 1;
                % elseif absPLoad < 0.1
                %     cdfPLoad(1, 4) = cdfPLoad(1,4) + 1;
                % % elseif absPLoad < 5
                % %     cdfPLoad(1, 8) = cdfPLoad(1,8) + 1;
                % elseif absPLoad < 1
                %     cdfPLoad(1, 5) = cdfPLoad(1,5) + 1;
                % elseif absPLoad < 10
                %     cdfPLoad(1, 6) = cdfPLoad(1,6) + 1;
                % else
                %     cdfPLoad(1, 7) = cdfPLoad(1,7) + 1;
                % end






                 sumPLoad = sumPLoad + abs(totalPLoad);
                 sumQLoad = sumQLoad + abs(totalQLoad);
            end


            if (k == 1)
                time(k)=toc;
            else
                time(k)=time(k-1)+toc;
            end
            % k th year
            PLoad(k) = sumPLoad / 8760;
            QLoad(k) = sumQLoad / 8760;
            % in k year
            PLOAD(k) =1 / k * sum(PLoad(1: k));
            QLOAD(k) =1 / k * sum(QLoad(1: k));
            %std
            V_PLOAD(k) = std(PLoad(1: k));
            V_QLOAD(k) = std(QLoad(1: k));
            %beta
            beta_PLOAD(k) = V_PLOAD(k) / PLOAD(k) /sqrt(k);
            beta_QLOAD(k) = V_QLOAD(k) / QLOAD(k) /sqrt(k);

        end

         % time(yearLoop)
         loadRslt = PLOAD(yearLoop) * 1e4;
         % bar(PLOAD)