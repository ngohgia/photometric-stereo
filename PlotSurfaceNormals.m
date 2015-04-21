function PlotSurfaceNormals(outputDir, surfNormals)
    surfNormals = double(surfNormals);
    [nRows nCols nColors] = size(surfNormals);
    
    % form vectors of row and col indices
    rowIdx = []; colIdx = []; Nx = []; Ny = []; Nz = [];
    for i = 1:nRows
        colIdx = [colIdx 1:nCols];
        rowIdx = [rowIdx i*ones(1, nCols)];
        Nx = [Nx surfNormals(i, :, 1)];
        Ny = [Ny surfNormals(i, :, 2)];
        Nz = [Nz surfNormals(i, :, 3)];
    end;
    
    img = imshow(surfNormals);
     % save the colored surface normal plot
    outputFile = [outputDir '/coloredSurfNorm.jpg'];
    saveas(img, outputFile);   
    
    H = slice(surfNormals, [], [], 1);
    colormap(gray(256));
    set(H, 'EdgeColor', 'none');
    hold on;
    quiver3(colIdx, rowIdx, ones(1, nRows * nCols), ...
        Nx, Ny, Nz);
    hold off;
    
    % view the plot from above
    view(0, 90);
    camroll(180);
    
    % save the surface normal plot
    outputFile = [outputDir '/surfNorm.jpg'];
    saveas(H, outputFile);
    
    