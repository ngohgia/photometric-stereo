function normalMap = ConvertNormVectorToMap(allNormals, mask, numObjPixels, maskRow, maskCol)
    % Convert the vector of normals to the Surface Normal map
    normalMap = zeros(size(mask,1), size(mask,2), 3);
    
    for i = 1:numObjPixels
        row = maskRow(i);
        col = maskCol(i);
        normalMap(row, col, :) = squeeze(allNormals(i,:));
    end;
end