function PlotDepthMap(outputDir, depthMap)
    % Save the depth map by the magnitue value
    img = imshow(depthMap, [0 max(max(depthMap))]);
    depthMapFile = [outputDir '/depthMap.jpg'];
    saveas(img, depthMapFile);
    
    % Save the 3D plot of the depth map
    fig = figure;
    img = surfl(depthMap, 'light');
    shading interp;
    
    view([45, 45, 300])
    outputFile = [outputDir '/depthMap3D.jpg'];
    colormap winter;
    saveas(fig, outputFile);