function [shuffled_vector shuffled_vector_indices] = shuffle_vector(data_vector)
% function [shuffled_vector shuffled_vector_indices] = shuffle_vector(data_vector)
% 
% Shuffles the entries in the given vector
%
% Sagi Perel, 03/2009

    %--- sanity check on input arguments
    if(nargin ~= 1)
        error('shuffle_vector: wrong number of input arguments supplied');
    end
    if(isempty(data_vector))
        error('shuffle_vector: data_vector should not be empty');
    end
    if(~isvector(data_vector))
        error('shuffle_vector: data_vector should be a vector');
    end

    % this is WAY faster...
    shuffled_vector_indices = randperm(length(data_vector));
    shuffled_vector = data_vector(shuffled_vector_indices);    
    
%     %--- create a shuffled list of indices
%     vec_len = length(data_vector);
%     indices = 1:vec_len;
%     
%     shuffled_vector_indices = zeros(vec_len,1);
%     
%     cur_vec_len = vec_len;
%     for i=1:vec_len
%         rand_int = randi(cur_vec_len);
%         shuffled_vector_indices(i) = indices(rand_int);
%         indices(rand_int) = [];
%         cur_vec_len = length(indices);
%     end
%     
%     shuffled_vector = data_vector(shuffled_vector_indices);
%     
