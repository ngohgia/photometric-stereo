function w = ComputeMsgWeight(allNormals, i, j)
    % Compute the weight assigned to a given message
    SIGMA = 0.5; 
    
    tmp = sum((allNormals(i,:) - allNormals(j,:)).^2);
    tmp = log(1 + 0.5 * tmp / SIGMA^2);
    
    w = exp(-tmp * 0.5 / SIGMA^2);
end