function M = ComputeMessages(M, neighbors, allNormals, numObjPixels)
    % recompute the messages matrix
    for i = 1:numObjPixels
        for j = 1:size(neighbors,2)
            currNeighbor = neighbors(i,j);
            % local evidence
            msg = squeeze(M(i,5,:,:));
            
            % if the neighbor lies within the image mask
            if currNeighbor ~= 0
                % iterate through the other neighbors
                for k = 1:size(neighbors,2)
                    otherNeighbor = neighbors(i,k);
                    % if the other neighbor also lies within the image mask
                    if k ~= j && otherNeighbor ~= 0 && ...
                    ~isempty(find(neighbors(otherNeighbor,:) == i, 1))
                        % update the message of the current pixel to currNeighbor by
                        % adding in messages of all other neighbors sent to the current pixel
                        idx = find(neighbors(otherNeighbor,:) == i, 1);
                        msg = msg + squeeze(M(otherNeighbor, idx,:,:));
                    end;
                end;
                % Compute the weight assigned to the message
                w = ComputeMsgWeight(allNormals, i, j);

                % Normalize the message tensor
                M(i,j,:,:) = w * bsxfun(@times, msg, 1./sum(msg, 1));
            end;
        end;
    end;
end