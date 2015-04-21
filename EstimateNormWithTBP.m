function normalMap = EstimateNormWithTBP(mask,  initNorm)
    % driver function of the TBP
    MAX_ITR = 10;
    
    % Get rows and cols that are within the mask
    [maskRow, maskCol] = find(mask);
    numObjPixels = size(maskRow, 1);
    
    % index(i,j) = k means the pixel at position (i,j) has index k
    % among the pixels within the image mask
    % index(i,j) = 0 means the pixel lies outside the image mask
    index = zeros(size(mask,1), size(mask,2));
    for i = 1:numObjPixels
        objRow = maskRow(i);
        objCol = maskCol(i);
        index(objRow, objCol) = i;
    end;
    
    % neighbors = numObjPixels x 4 matrix
    % neighbors[i,j] with 1 <= j <= 4 are the indices of the neighboring 
    % pixels of the pixel of index i
    neighbors = zeros(numObjPixels, 4);

    % get the neihbors of each pixel
    for i = 1:numObjPixels
        row = maskRow(i);
        col = maskCol(i);

        if index(row-1, col) > 0 
            neighbors(i,1) = index(row-1, col); % X+1, Y
        end;
        
        if index(row, col+1) > 0
            neighbors(i,2) = index(row, col+1); % X, Y+1
        end
        
        if index(row, col-1) > 0
            neighbors(i,3) = index(row, col-1); %X-1, Y
        end;

        if (index(row+1, col) > 0)
            neighbors(i,4) = index(row+1, col); %X, Y-1
        end;
    end;
    
    % Message matrix M
    % M(i, 5, :, :) contains the local evidence of pixel of index i
    % M(i, j, :, :) with 1 <= j <= 4 are the messages from pixel of index
    % i to its four neighbors
    M  = ones(numObjPixels, 5, 3, 3);

    % assign all messages M(i,j,:,:) with a an identity matrix of size 3x3
    tmp = ones(1, 1, 3, 3);
    tmp(1,1,:,:) = eye(3,3);
    M = bsxfun(@times, M, tmp);
    
    % assign local evidence to each pixel
    for i = 1:numObjPixels
        row = maskRow(i);
        col = maskCol(i);
        % the initial value of the normal at the given point
        normal = squeeze(initNorm(row, col, :));
        normal = normal';
        M(i,5,:,:) = normal * normal';
    end;
    
    % Perform the update
    for iter = 1:MAX_ITR
        disp(['Iteration: ' num2str(iter)]);
        % Compute best normal at each pixel
        allNormals = ComputeBestNormals(M, neighbors, numObjPixels);
        % Convert the vector of normals to the Surface Normal Map
        normalMap = ConvertNormVectorToMap(allNormals, mask, numObjPixels, maskRow, maskCol);
        %imshow(normalMap);

        % Recompute the messages between the pixels
        ComputeMessages(M, neighbors, allNormals, numObjPixels);
    end;
end