function allNormals = ComputeBestNormals(M, neighbors, numObjPixels)
    % allNormals(i) = normal at the i-th pixel
    allNormals = zeros(numObjPixels, 3);
    
    for i = 1:numObjPixels
        % local evidence term
        b = squeeze(M(i, 5, :, :));

        % iterate through neighbors of the current pixel
        for j = 1:4
            currNeighbor = neighbors(i, j);
            % if the neighbor lies within the image mask
            if currNeighbor ~= 0
                if ~isempty(find(neighbors(currNeighbor,:) == i, 1))
                    % extract the message sent from the neighbor to the current pixel
                    msg = squeeze(M(currNeighbor, find(neighbors(currNeighbor,:) == i, 1), :, :));
                    b = b + msg;
                end;
            end;
        end;
        
        % estimate the normal at the current point
        % as the eigenvector corresponding to the largest
        % eigenvalue of b
        [V, ~] = eigs(b);
        allNormals(i, :) = squeeze(V(:, 1));
    end;
end