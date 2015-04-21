function S = GetLightSources(rootDir, numLights)
  filePath = [fullfile(rootDir) '/chrome/chrome'];
  
  % Find the center of the ball
  maskFilePath = [filePath '.mask.tiff'];
  ball = imread(maskFilePath);
  ball = rgb2gray(ball);
  
  % Pick out the foreground of the mask
  maxVal = max(max(ball));
  [nRows, nCols] = find(ball == maxVal);
  leftCol = min(nCols);
  rightCol= max(nCols);
  topRow = min(nRows);
  botRow = max(nRows);
  % Compute the centter and radius of the ball
  Cx = double(leftCol + rightCol) / 2;
  Cy = double(topRow + botRow) / 2;
  center = [Cx, Cy];
  rad = double(rightCol - leftCol) / 2;
  
  % reflection directon
  R = [0 0 1];
  % source direction
  S = [];
  for i = 1:numLights
      im = imread([filePath '.' num2str(i-1) '.tiff']);
      im = rgb2gray(im);
      % extract the pixels of thebright spot
      maxVal = max(max(im));
      [spotRows, spotCols] = find(im == maxVal);
      numPixels = size(spotRows, 1);
      
      % the center of the bright spot
      Sx = sum(spotCols) / numPixels;
      Sy = sum(spotRows) / numPixels;
      
      Nx = (Sx - Cx) / rad;
      Ny = -(Sy - Cy) / rad;   % the minus sign to flip the y-direction upwards
      Nz = sqrt(1 - Nx^2 - Ny^2);
      
      normal = [Nx, Ny, Nz];
 
      % compute source direction
      S(i, :) = 2 * (dot(R, normal)) * normal - R;  
      
      tmp = imread([filePath '.' num2str(i-1) '.tiff']);
      for j = 1:size(tmp,1)
        tmp(j, uint16(Sx), :) = [255 0 0];
        tmp(j, uint16(Cx), :) = [255 0 0];
      end;
      tmp(uint16(Sy), uint16(Sx), :) = [255 0 0];
      imshow(tmp);
  end
  
  % write the lighting direction into a file
  fout = fopen([rootDir '/lights.txt'], 'w');
  fprintf(fout, '%d \n', numLights);
  for i = 1:numLights
      fprintf(fout, '%0.5f %0.5f %0.5f \n', S(i,1), S(i,2), S(i,3));
  end;
  fclose(fout);
  
  
  
  
  