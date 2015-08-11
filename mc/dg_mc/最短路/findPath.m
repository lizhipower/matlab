function [ Path ] = findPath(EndNode, A)
    Path = zeros(1, length(EndNode));
    for i = 1 : length(EndNode)
        Path(i).path = [];

    end
end

