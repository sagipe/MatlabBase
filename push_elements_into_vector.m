function new_vec = push_elements_into_vector(vec, indices, new_values, adjust_indices)
% function new_vec = push_elements_into_vector(vec, indices, new_values, adjust_indices)
%
% Pushes the given elements into vec, without replacing any existing data
%
% For example:
% push_elements_into_vector([1 2 3], [2 3], [1.5 2.5]) 
% ans = 
%             1 1.5 2 2.5 3
%
% push_elements_into_vector([1 2 3], [2 4], [1.5 2.5], 0) 
% ans = 
%             1 1.5 2 2.5 3
%
% push_elements_into_vector([1 2 3; 4 5 6], [2 3], [2.5; 3.5])
% ans =
%             1          2.5            2          2.5            3
%             4          3.5            5          3.5            6
% 
% push_elements_into_vector([1 2 3; 4 5 6], [2 3], [1.5 2.5; 4.5 5.5])
% ans =
%             1          1.5            2          2.5            3
%             4          4.5            5          5.5            6
%
% INPUTS:
% vec       : [double 2D matrix] with length N, and other dimension K, where N>K (K may be 1)
% indices   : [double 1D array ] with length M, where M<=N
% new_values: [double 2D matrix] with length M or 1 (so the same value will be used)
% [adjust_indices]: [bool] default: 1.  Should the indices be adjusted before the elements are inserted (see example above)
%
% OUTPUTS:
% new_vec : [double 2D matrix] with length N+M
%
% Sagi Perel, 05/2009

    %--- sanity check on inputs
    if(nargin < 3 || nargin > 4)
        error('push_elements_into_vector: wrong number of input arguments given');
    end
    if(ndims(vec) > 2)
        error('push_elements_into_vector: vec must be a 2D matrix at most');
    end
    if(~isvector(indices))
        error('push_elements_into_vector: indices must be a vector');
    end
    if(~exist('adjust_indices','var'))
        adjust_indices = 1;
    end
    
    % return empty if vec is empty
    if(isempty(vec))
        new_vec = [];
        return;
    end
    
    % find the longer dimension for vec (call it N)
    N = length(vec);
    [nrows ncols] = size(vec);
    % figure out the other dimension for vec (call it K):
    if(nrows==N)
        % the long dimension of vec is the rows
        K = ncols;
    else
        % the long dimension of vec is the cols
        K = nrows;
    end
    
    % find the number of indices to replace (indices along the dimension with length N)
    M = length(indices);
    if(M > N)
        error(['push_elements_into_vector: indices has too many indices (' num2str(M) ') while vec has (' num2str(N) ') elements in the long dimension']);
    end
    
    % figure out the size of the vector with the values to replace:
    % new_values should be [K x nM] or [nM x K] , where nM could be 1. 
    % If that is the case, then we need to repmat nM to be M
    new_values_size = size(new_values);
    % test to see if new_vec has a valid size, also give new_vec the right size and same orientation as vec:
    if(nrows == N)
        % vec is [N x K] so new_vec has to be [1 x K] or [M x K]
        if(~all(new_values_size == [1 K]) && ~all(new_values_size == [M K]))
            error(['push_elements_into_vector: new_values_size should be either [1 ' num2str(K) '] or [' num2str(M) ' ' num2str(K) '] but it is [' num2str(new_values_size) ']']);
        end
        if(new_values_size(1) == 1)
            new_values = repmat(new_values, [M 1]);
        end
        new_vec = zeros(N+M, K);
    else
        % vec is [K x N] so new_vec has to be [K x 1] or [K x M]
        if(~all(new_values_size == [K 1]) && ~all(new_values_size == [K M]))
            error(['push_elements_into_vector: new_values_size should be either [' num2str(K) ' 1] or [' num2str(K) ' ' num2str(M) '] but it is [' num2str(new_values_size) ']']);
        end
        if(new_values_size(2) == 1)
            new_values = repmat(new_values, [1 M]);
        end
        new_vec = zeros(K, N+M);
    end    
    
    %--- insert the values
    % create logical markers where the new values will be inserted along the dimension with length N:
    % since we preallocate new_vec, the values in 'indices' have to be shifted by the number of elements already inserted starting from the second value    
    if(adjust_indices)
        indices_shifts = 0:length(indices)-1;
        true_indices = indices + indices_shifts; % corrected indices to insert at new_vec
    else
        true_indices = indices;
    end
    
    insertion_markers = false(N+M,1); % preallocate the logical insertion points with false
    insertion_markers(true_indices) = true; % make the insertion points where we actually have to insert something be true
    
    if(nrows == N)
        % vec is [N x K]
        new_vec(insertion_markers,:)  = new_values;
        new_vec(~insertion_markers,:) = vec;
    else
        % vec is [K x N]
        new_vec(:,insertion_markers)  = new_values;
        new_vec(:,~insertion_markers) = vec;
    end
    