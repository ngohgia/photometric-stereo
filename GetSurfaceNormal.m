function normalMap = GetSurfaceNormal(allImg, mask, lightMat)
    [nRows, nCols] = size(mask);

    % get the denominator image
    [denomImgIdx, denomImg] = GetDenomImg(allImg, mask);
    denomImg = double(denomImg);
    
    % get the remaining images
    nonDenomImgs = zeros(size(allImg,1)-1, size(allImg,2), size(allImg,3));
    nonDenomLights = zeros(size(allImg,1)-1, 3);
    
    count = 1;
    for i = 1:size(allImg,1)
        if i ~= denomImgIdx
            nonDenomImgs(count,:,:) = double(squeeze(allImg(i,:,:)));
            nonDenomLights(count,:) = lightMat(i,:);
            count = count + 1;
        end;
    end;
    
    % Estimate the initial surface normals map
    initNorm = zeros(nRows, nCols, 3);
    for i = 1:nRows
        for j = 1:nCols
            if mask(i,j) ~= 0
                initNorm(i,j,:) = GetPixelNorm(denomImg(i,j), squeeze(nonDenomImgs(:,i,j)), ...
                    squeeze(lightMat(denomImgIdx,:)), nonDenomLights);
                if squeeze(initNorm(i,j,:)) == [0 0 0]
                    disp(' ');
                end;
            end;
        end;
    end;
    
    % estimate the surface normals using tensor belief propagation
    normalMap = EstimateNormWithTBP(mask, initNorm);
    
% Use SVD to compute the initial normal at each pixel
function normal = GetPixelNorm(denomPixel, nonDenomPixels, denomLight, nonDenomLights)
    M = nonDenomPixels * denomLight - denomPixel * nonDenomLights;
    [U, S, V] = svd(M);
    normal = squeeze(V(:,size(V,2)));