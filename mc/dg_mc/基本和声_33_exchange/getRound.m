function [ Round  ] = getRound( T , Open, c_index)
    global bus branch
    Round = [];
    RoundEndNodeNum = [];
    for i = 1 : length(T(: ,1))
        rNum = 0;
        for j = 1 : i - 1
            if T(j, i) ~= 0
                rNum = rNum + 1;
            end
        end
        
        if rNum == 2
            RoundEndNodeNum = [RoundEndNodeNum i]; 
            % disp(' round node found');
            % RoundEndNodeNum
        end
    end
    % disp('Text0');
    RoundEndNodeNum
    if length(RoundEndNodeNum) == 1
        % disp('Text');
        Loop = [];
        % node = [];
        ii = 1;
        for i = 1 : RoundEndNodeNum - 1
            if T(i, RoundEndNodeNum) ~= 0;
                % node[ii] = i;
                Loop(ii).loop = union(getAreaLoop(T, i), i);
                % Loop(ii).loop 
                ii = ii + 1;
            end
        end
        Round = roundType1(Loop, T , Open, c_index, RoundEndNodeNum);
    elseif length(RoundEndNodeNum) == 2
        % RoundEndNodeNum
        path = [];
        [Loop, Round, path] = checkRound(RoundEndNodeNum, path, T, Open, c_index);
        
        if length(Round) == 0
            r1 = [];
            r2 = [];
            if length(path) == 4
                p1 = [];
                p2 = [];
                for i = 1 : length(path)
                    % disp('path...............');
                    % path(i).path
                    if min(path(i).path) == 1
                        if length(p1) == 0
                            p1 = path(i).path;
                        else
                            c1 = intersect(p1, path(i).path);
                            u1 = union(p1, path(i).path);
                            r1 = setxor(u1, c1);
                            r1 = union(r1, max(c1));
                        end
                    else
                        if length(p2) == 0
                            p2 = path(i).path;
                        else
                            c2 = intersect(p2, path(i).path);
                            u2 = union(p2, path(i).path);
                            r2 = setxor(u2, c2);
                            r2 = union(r2, max(c2));
                        end
                    end
                end
            end
            RoundNode = union(r1, r2);
            RoundNode = union(RoundNode, RoundEndNodeNum);
            for i = 1 : length(branch)
                if any(RoundNode == branch(i, 1))== 1 & any(RoundNode == branch(i, 2))== 1
                    Round = [Round i];
                end
            end
            Round = setxor(Round, intersect(Round, Open));
            Round = union(Round, Open(c_index));
        end
    elseif length(RoundEndNodeNum) == 3
        path = [];
        [Loop, Round, path] = checkRound(RoundEndNodeNum, path, T, Open, c_index);
        if length(Round) == 0
            for i = 1 : length(path)
                disp('pathstart..........');
                path(i).path
                disp('pathend........');
            end
        end
    end
end
function [Loop, Round, path] = checkRound(RoundEndNodeNum, path,  T, Open, c_index)
     for  RoundEndNodeNumIndex = 1 : length(RoundEndNodeNum)
            Loop = [];
            % node = [];
            % disp('Text1');
            ii = 1;

            rootNodeNum = 0;
            rootTemp = 0;
            for i = 1 : RoundEndNodeNum(RoundEndNodeNumIndex) - 1
                if T(i, RoundEndNodeNum(RoundEndNodeNumIndex)) ~= 0;
                    % node[ii] = i;
                    Loop(ii).loop = union(getAreaLoop(T, i), i);
                    % disp('Text2');
                    % disp('loop');
                    % Loop(ii).loop
                    if rootTemp == 0
                        rootTemp = min(Loop(ii).loop) ;
                    elseif rootTemp == min(Loop(ii).loop) 
                        rootNodeNum = rootNodeNum + 1;
                    end                            
                    path((RoundEndNodeNumIndex-1)*2 + ii).path = Loop(ii).loop;
                    ii = ii + 1;
                end
            end
            % rootNodeNum
            if rootNodeNum ~= 0
                % disp('it is a round');
                Round = roundType1(Loop, T , Open, c_index, RoundEndNodeNum(RoundEndNodeNumIndex));
                
                break
            elseif rootNodeNum == 0
                % disp('it is a path');
                Round = [];
            end
        end
end
function [Round] = roundType1(Loop, T , Open, c_index, RoundEndNodeNum)
    global bus branch
    
    root = [1: length(T(:, 1))];
        for i = 1 : length(Loop)
            root = intersect(root, Loop(i).loop);
        end
        rootNode = max(root);
        RoundNode = [];
        for i = 1 : length(Loop)
            RoundNode = union(RoundNode, Loop(i).loop);
        end
        RoundNode = setxor(RoundNode, root);
        RoundNode = union(RoundNode, rootNode);
        
        RoundNode = union(RoundNode, RoundEndNodeNum);
        
        Round = [];
        for i = 1 : length(branch)
            if any(RoundNode == branch(i, 1))== 1 & any(RoundNode == branch(i, 2))== 1
                Round = [Round i];
            end
        end
        Round = setxor(Round, intersect(Round, Open));
        Round = union(Round, Open(c_index));
end
function [Loop] = getAreaLoop(T, nodeNum)
    Loop = [];
    while 1
        % disp('find parentNodeLists');
        parentNodeLists = findParent(T, nodeNum);
        Loop = union(Loop, parentNodeLists);
        if (checkRootPoint(T, parentNodeLists) == 1)
            % disp('root found');
            break
        else
            for i = 1 : length(parentNodeLists)
                Loop = union(Loop, getAreaLoop(T, parentNodeLists(i)));
            end
            break
        end
    end
end

