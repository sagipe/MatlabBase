function vec_elements = pick_random_elements(data_vector, num_elements)
% function vec_elements = pick_random_elements(data_vector, num_elements)
% 
% Picks num_elements elements randomly from data_vector
%
% INPUTS:
% data_vector : [array]
% num_elements: [double]
%
% OUTPUTS:
% vec_elements : [array]
%
% Sagi Perel, 04/2009

    if(nargin ~= 2)
        error('pick_random_elements: wrong number of input arguments supplied');
    end
    if(~isvector(data_vector))
        error('pick_random_elements: data_vector must be a vector');
    end
    if(~isscalar(num_elements))
        error('pick_random_elements: num_elements must be a scalar');
    end
    
    vec_len = length(data_vector);
    if(num_elements > vec_len)
        error('pick_random_elements: num_elements > length(data_vector)');
    end
    if(num_elements == vec_len)
        vec_elements = data_vector;
        return;
    end
    
    shuffled_vector = shuffle_vector(data_vector);
    vec_elements = shuffled_vector(1:num_elements);