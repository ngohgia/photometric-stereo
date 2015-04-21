function StereoTBP(rootDir, imgName, numImgs)
    % output folder
    outputDir = [rootDir '/' imgName '/output'];
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end;

    % Read the light sources
    lightFile = fopen([rootDir '/lights.txt'], 'r');
    numLights = fscanf(lightFile, '%d\n', 1);
    
    lightMat = [];
    for i = 1:numLights
        lightMat(i, :) = fscanf(lightFile, '%f %f %f\n', 3);
    end;
    
    filePath = [rootDir '/' imgName '/'];
    % Read mask file
    mask = imread([filePath imgName '.mask.tiff']);
    mask = rgb2gray(mask);
    mask = logical(mask);
    
    % Read image files
    allImg = [];
    for i = 1:numImgs
        img = imread([filePath imgName '.' num2str(i-1) '.tiff']);
        img = rgb2gray(img);
        
        allImg(i,:,:) = img;
    end;
    
    % Estimate Surface Normals
    normalMap = GetSurfaceNormal(allImg, mask, lightMat);
    PlotSurfaceNormals(outputDir, normalMap);
    
    % Estimate the Depth Map
     depthMap = GetDepthMap(mask, normalMap);
     PlotDepthMap(outputDir, depthMap);