function matrix = sp_array_to_matrix(array, indices_matrix)
% function matrix = sp_array_to_matrix(array, indices_matrix)
%
% Maps values from array to a matrix, based on the provided indices
% 
% INPUTS:
% array         : [array] with data values
% indices_matrix: [matrix] with indices of data in array. NaN entries stay NaN in the output matrix.
%
% OUTPUTS:
% matrix: [matrix] same size as indices_matrix, with data from array mapped to the right places
%
% EXAMPLES:
% sp_array_to_matrix(1:9, [1 2 NaN 3 4; 6 7 8 9 5])
% ans =
%      1     2   NaN     3     4
%      6     7     8     9     5
%      
% sp_array_to_matrix(1:9, [1 1 NaN 1 1; 6 7 8 9 5])
% ans =
%      1     1   NaN     1     1
%      6     7     8     9     5
% Sagi Perel, 12/2012

    if(nargin ~= 2)
        error('sp_array_to_matrix: wrong number of input arguments provided');
    end
    if(~isvector(array))
        error('sp_array_to_matrix: array should be a vector');
    else
        num_values = length(array);
    end
    if(~ismatrix(indices_matrix))
        error('sp_array_to_matrix: indices_matrix should be a matrix');
    else
        linearized_indices = indices_matrix(:);
        if(nanmin(linearized_indices)<1)
            error('sp_array_to_matrix: indices_matrix should contain positive integers');
        elseif(nanmax(linearized_indices)>num_values)
            error('sp_array_to_matrix: indices_matrix contains an index too large for array');
        elseif(sum(~isnan(linearized_indices)) ~= num_values)
            warning('sp_array_to_matrix: some values in array are not used');
        end
    end
    % linearized_indices has some size, with possible NaN values
    % so find indices of elements in linearized_indices which are not NaN
    not_NaN_lidxs = ~isnan(linearized_indices);
    array_mapped_to_linearized_indices = nan(size(linearized_indices));
    array_mapped_to_linearized_indices(not_NaN_lidxs) = array(linearized_indices(not_NaN_lidxs));
    matrix = reshape(array_mapped_to_linearized_indices, size(indices_matrix));
    