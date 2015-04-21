function [denomImgIdx, denomImg] = GetDenomImg(allImg, mask)
    % function to get the denominator image

    % rows and columns of all pixels within the image mask
    [maskRows, maskCols] = find(mask);
    numObjPixels = size(maskRows, 1);

    % index(i,j) = k means the pixel at position (i,j) has index k
    % among the pixels within the image mask
    % index(i,j) = 0 means the pixel lies outside the image mask    
    index = zeros(size(mask));
    for i = 1:numObjPixels
        row = maskRows(i);
        col = maskCols(i);
        index(row, col) = i;
    end;
    
    % thresholds used to determine if a pixel does not lie in a shadow
    % or inside a bright spot
    LOWER_THRES = 0.7;
    UPPER_THRES = 0.9;

    % allImgRanks = D x M x N matrix where M x N is the size of each image, D is
    % the number of images
    % allImgRanks(d, i, j) is the rank by intensity of the pixel (i,j) in
    % the d-th image among the corresponding pixels in all D images
    %
    % validPixelByImg = D x M x N matrix
    % validPixelByImg(d, i, j) = 1 if the rank of the pixel (i,j) in the
    % d-th image lies within the percentile specified by LOWER_THRES and
    % UPPER_THRES; 0 otherwise
    allImgRanks = zeros(size(allImg));
    validPixelByImg = zeros(size(allImg));
    
    for i = 1:size(mask,1)
        for j = 1:size(mask,2)
            if (mask(i,j) > 0)
                % get the intensity at all pixels of position (i,j) across
                % all images
                intensity = squeeze(allImg(:,i,j));
                % assign a rank to all pixels at position (i,j) across
                % all images
                [~ , ~ , ranks] = unique(intensity);
                allImgRanks(:,i,j) = ranks;
                
                % assign 1 to pixels with a rank above the lower threshold
                lowerRank = max(ranks) * LOWER_THRES;
                validPixelByImg(ranks > lowerRank , i, j) = 1;
            end;
        end;
    end;
    
    % numValidPixels is a vector of length equals the number of images
    % numValidPixels(d) = the number of valid pixels within the d-th image
    %
    % meanImgRank is a vector of length equals the number of images
    % meanImgRank(d) = the mean rank value of all valid pixels within the d-th image
    numValidPixels = zeros(size(allImg, 1), 1);
    meanImgRank = zeros(size(allImg, 1), 1);
    for i = 1:size(numValidPixels, 1)
        validPixels = squeeze(validPixelByImg(i,:,:));
        numValidPixels(i) = sum(sum(validPixels));
        
        currImgRanks = squeeze(allImgRanks(i,:,:));
        meanImgRank(i) = sum(sum(currImgRanks(validPixels ~= 0))) / numValidPixels(i);
    end;
    
    upperThres = max(meanImgRank) * UPPER_THRES;
    % the denominator image is the one with the most number of valid pixels
    % the mean rank of the valid pixels lying within the predefined range
    denomImgIdx = find(numValidPixels == max(numValidPixels(meanImgRank < upperThres)));
    denomImg = squeeze(allImg(denomImgIdx,:,:));
    
    % imshow(denomImg, [0 max(max(denomImg))]);