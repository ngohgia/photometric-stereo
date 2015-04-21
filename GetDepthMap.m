function depthMap = GetDepthMap(maskImg, normalMap)
    [nRows, nCols] = size(maskImg);
    
    % get the rows and columns of the pixels within the mask
    [maskRow, maskCol] = find(maskImg);
    numObjPixels = size(maskRow,1);     % total number of pixels within the mask
    
    % the minimum threshold that the z-component that can be
    EPSILON = 0.1;  
    
    % index(i,j) = k means the pixel at position (i,j) in the
    % non-masked image has index k among the pixels lying
    % within the mask
    % index(i,j) = 0 means the pixel lies outside of the mask

    index = zeros(nRows, nCols);
    for i = 1:numObjPixels
        objRow = maskRow(i);
        objCol = maskCol(i);
        index(objRow, objCol) = i;
    end;
    
    % vectors used to construct the sparse matrix M
    % M is a 2N x N sparse matrix where N is the number of pixels lying within the
    % image mask.
    % Elements of M indicates which pixel is involved in the computation of the surface depth
    % of a given pixel
    sparseMx = zeros(4 * numObjPixels, 1);
    sparseMy = zeros(4 * numObjPixels, 1);
    sparseMval = zeros(4 * numObjPixels, 1);
    
    % vectors used to construct U
    % U is a 2N x 1 sparse matrix
    % which are the n_x/n_z and n_y/n_z values
    sparseUx = zeros(2 * numObjPixels, 1);
    sparseUval = zeros(2 * numObjPixels, 1);

    
    % initialize up the M matrix
    count = 0;
    for i = 1:numObjPixels
        % row and column values of the current pixel
        row = maskRow(i);
        col = maskCol(i);
        % the normal at the corresponding point on the object surface
        nx = normalMap(row, col, 1);
        ny = normalMap(row, col, 2);
        nz = normalMap(row, col, 3);
        
        if (abs(nz) > EPSILON)
            if (index(row-1, col) > 0 && index(row, col+1) > 0)
                % point (X, Y+1) and (X+1,Y) are inside the mask
                count = count + 1;
                sparseMx(count) = 2*i-1;
                sparseMy(count) = index(row, col); %X, Y
                sparseMval(count) = 1;

                count = count + 1;
                sparseMx(count) = 2*i-1;
                sparseMy(count) = index(row, col+1);  %X+1, Y
                sparseMval(count) = -1;

                sparseUx(count) = 2*i-1;
                sparseUval(count) = nx / nz;

                %---------%
                count = count + 1;
                sparseMx(count) = 2*i;
                sparseMy(count) = index(row, col);  %X, Y
                sparseMval(count) = 1;

                count = count + 1;
                sparseMx(count) = 2*i;
                sparseMy(count) = index(row-1, col);    %X, Y-1
                sparseMval(count) = -1;

                sparseUx(count) = 2*i;
                sparseUval(count) = ny / nz;
            elseif (index(row-1, col) > 0)
                % point (X+1, Y) is outside the mask
                if (index(row, col-1) > 0)
                    count = count + 1;
                    sparseMx(count) = 2*i-1;
                    sparseMy(count) = index(row, col); %X, Y
                    sparseMval(count) = -1;

                    count = count + 1;
                    sparseMx(count) = 2*i-1;
                    sparseMy(count) = index(row, col-1);  %X-1, Y
                    sparseMval(count) = 1;

                    sparseUx(count) = 2*i-1;
                    sparseUval(count) = nx / nz;
                end;

                count = count + 1;
                sparseMx(count) = 2*i;
                sparseMy(count) = index(row, col); %X, Y
                sparseMval(count) = 1;

                count = count + 1;
                sparseMx(count) = 2*i;
                sparseMy(count) = index(row-1, col);  %X+1, Y
                sparseMval(count) = -1;

                sparseUx(count) = 2*i;
                sparseUval(count) = ny / nz;

            elseif (index(row, col+1) > 0)
                % point (X, Y+1) is outside the mask
                count = count + 1;
                sparseMx(count) = 2*i-1;
                sparseMy(count) = index(row, col); %X, Y
                sparseMval(count) = 1;

                count = count + 1;
                sparseMx(count) = 2*i-1;
                sparseMy(count) = index(row, col+1);  %X-1, Y
                sparseMval(count) = -1;

                sparseUx(count) = 2*i-1;
                sparseUval(count) = nx / nz;

                if (index(row+1, col) > 0)
                    count = count + 1;
                    sparseMx(count) = 2*i;
                    sparseMy(count) = index(row, col); %X, Y
                    sparseMval(count) = -1;

                    count = count + 1;
                    sparseMx(count) = 2*i;
                    sparseMy(count) = index(row+1, col);  %X, Y+1
                    sparseMval(count) = 1;

                    sparseUx(count) = 2*i;
                    sparseUval(count) = ny / nz;
                end;
            else
                if (index(row, col-1) > 0)
                    count = count + 1;
                    sparseMx(count) = 2*i-1;
                    sparseMy(count) = index(row, col); %X, Y
                    sparseMval(count) = -1;

                    count = count + 1;
                    sparseMx(count) = 2*i-1;
                    sparseMy(count) = index(row, col-1);  %X-1, Y
                    sparseMval(count) = 1;

                    sparseUx(count) = 2*i-1;
                    sparseUval(count) = nx / nz;
                end;

                if (index(row+1, col) > 0)
                    count = count + 1;
                    sparseMx(count) = 2*i;
                    sparseMy(count) = index(row, col);  %X, Y
                    sparseMval(count) = -1;

                    count = count + 1;
                    sparseMx(count) = 2*i;
                    sparseMy(count) = index(row+1, col);  %X, Y+1
                    sparseMval(count) = 1;

                    sparseUx(count) = 2*i;
                    sparseUval(count) = ny / nz;
                end;
            end;
        end;
    end;
    
    % remove zeros from the index vectors if any
    sparseMx(sparseMx == 0) = [];
    sparseMy(sparseMy == 0) = [];
    sparseMval(sparseMval == 0) = [];
    
    sparseUx(sparseUx == 0) = [];
    sparseUval(sparseUval == 0) = [];
    
    % Initialize M and U
    M = sparse(sparseMx, sparseMy, sparseMval);
    U = sparse(sparseUx, ones(1, size(sparseUx, 1)), sparseUval);
    
    % Get the depth at all pixels and offset by the minimum depth
    z = M \ U;
    z = z - min(z);
    
    % Convert the vector z into the Depth Map
    depthMap = zeros(nRows, nCols);
    for i = 1:size(z,1)
        depthMap(maskRow(i), maskCol(i)) = z(i);
    end;
