function [ isolated ] = findIsolated( T )
    isolated = [];
    isolatedAreaEnd = [];
    isolatedPoint = [];

    T_num = length(T(1, :));

    for i = 1 : T_num
        if (T(i, i) == 0)
            isolatedPoint = [isolatedPoint i];
        elseif (i ~= 1 & T(i, i) ~= 0)
            % i
            % sum(any(T(1: i-1, i) ~= 0))
            if sum(any(T(1: i-1, i) ~= 0)) == 0
                isolatedAreaEnd = [isolatedAreaEnd i];
                % if isIsland(T, i) == 1
                %     isolatedAreaEnd = [isolatedAreaEnd i];
                % end
            end
        end
    end

    % return

    island = [];
    for i = 1 : length(isolatedAreaEnd)
        island(i).area = findChildren(T, isolatedAreaEnd(i));
        island(i).root = isolatedAreaEnd(i);
        island(i).area = union(island(i).area, island(i).root);
        % ==================
        % island(i).area
        % island(i).root
        % ===================
    end
    ii = 1;
    island_new = [];
    for i = 1 : length(island)
        islandTempArea = island(i).area;
        for j = i + 1 : length(island)
            if length(intersect(islandTempArea, island(j).area)) ~= 0
                islandTempArea = union(islandTempArea, island(j).area);
                island(j).area = [];
            end
        end
        island_new(ii).area = islandTempArea;
        ii = ii + 1;

    end
    isIsland = island_new;
    mainPath = findChildren(T, 1);
    mainPath = union(mainPath, 1);

% ===================
    % mainPath

    % isolatedAreaEnd
% ====================
    ii = 1;
    island_new = [];
    for i = 1 : length(island)
        if length(intersect(island(i).area, mainPath)) == 0
            island_new(ii).area = island(i).area;
            island_new(ii).root = island(i).root;
            % island_new(ii).area

            ii = ii + 1;
        end
    end
    island = island_new;
    isolatedPoint;
    isolated = [];
    for i = 1 : length(island)
        isolated = union(isolated, island(i).area);
    end
    isolated = union(isolatedPoint, isolated);
    return


    isolatedChildren = [];
    ii = 1;
    islnads(ii).area = [];
    islnads(ii).roots = [];
    for i = length(isolatedAreaEnd) : -1 : 1
        % isolatedAreaEnd(i)
        if i == length(isolatedAreaEnd)
            % disp('s1');
            islnads(ii).area = union(isolatedAreaEnd(i), getAreaLoop(T, isolatedAreaEnd(i)));
            if checkRootPoint(T, isolatedAreaEnd(i)) == 1
                islnads(ii).roots = union(islnads(ii).roots,isolatedAreaEnd(i));
            end
        else
            % disp('s2');
            if length(intersect(islnads(ii).area, getAreaLoop(T, isolatedAreaEnd(i)))) ~= 0
                % disp('s21');
                islnads(ii).area = union(isolatedAreaEnd(i), islnads(ii).area);
                islnads(ii).area = union(getAreaLoop(T, isolatedAreaEnd(i)), islnads(ii).area);
                if checkRootPoint(T, isolatedAreaEnd(i)) == 1
                    islnads(ii).roots = union(islnads(ii).roots, isolatedAreaEnd(i));
                end
            elseif checkRootPoint(T, isolatedAreaEnd(i)) == 1 | length(getAreaLoop(T, isolatedAreaEnd(i))) == 0
                % disp('s22');
                if length( intersect( islnads(ii).area, isolatedAreaEnd(i) ) ) ~= 0
                    % disp('commmon');
                    islnads(ii).area = union(isolatedAreaEnd(i), islnads(ii).area);

                    if checkRootPoint(T, isolatedAreaEnd(i)) == 1
                        % disp('root');
                        islnads(ii).roots = union(islnads(ii).roots, isolatedAreaEnd(i));
                    end
                end
            elseif length(getAreaLoop(T, isolatedAreaEnd(i))) ~=0
                % disp('s3');

                ii = ii + 1;
                islnads(ii).area = [];
                islnads(ii).roots = [];

                islnads(ii).area = union(isolatedAreaEnd(i), islnads(ii).area);
                islnads(ii).area = union(getAreaLoop(T, isolatedAreaEnd(i)), islnads(ii).area);

                if checkRootPoint(T, isolatedAreaEnd(i)) == 1
                    islnads(ii).roots = union(islnads(ii).roots, isolatedAreaEnd(i));
                end

            end
        end

        isolatedChildren = union(isolatedChildren, getAreaLoop(T, isolatedAreaEnd(i)));
    end
    for i = 1 : length(islnads)
        % i
        % islnads(i).area
        % islnads(i).roots

        isolated_temp = [];
        for j = 1 : length(islnads(i).roots)
            islandRoots = islnads(i).roots;
            children = findChildren(T, islandRoots(j) );
            areaTemp =  islnads(i).area;

            unionTemp = union(children  , areaTemp);
            if isequal(unionTemp, areaTemp)
                isolated_temp = union(isolated_temp, areaTemp);
            end
        end

    end
    isolated =  union(isolated_temp, isolatedPoint);
    % isolated = union(isolatedPoint, isolatedAreaEnd);
    % isolated = union(isolated, isolatedChildren);

end

function [isolatedChildren] = getAreaLoop(T, nodeNum)
    isolatedChildren = [];
    while 1
        % disp('find parentNodeLists');
        parentNodeLists = findParent(T, nodeNum);
        isolatedChildren = union(isolatedChildren, parentNodeLists);
        if (checkRootPoint(T, parentNodeLists) == 1)
            % disp('root found');
            break
        else
            for i = 1 : length(parentNodeLists)
                isolatedChildren = union(isolatedChildren, getAreaLoop(T, parentNodeLists(i)));
            end
            break
        end
    end
end


