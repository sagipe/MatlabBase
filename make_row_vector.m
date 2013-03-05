function row_vec = make_row_vector(input_vector)
% function row_vec = make_row_vector(input_vector)
% 
% Outputs the input vector as a row vector
%
% INPUTS:
% input_vector  : [array] a vector
%
% OUTPUTS:
% row_vec: [column array]
%
% Sagi Perel, 12/2008

    if(nargin ~= 1)
        error('make_row_vector: wrong number of arguments provided');
    end
    if(isempty(input_vector))
        error('make_row_vector: input_vector is empty');
    end
    if(~isvector(input_vector))
        error('make_row_vector: input_vector must be a vector');
    end
    
    % if number of rows is different than 1, then it's a column vector
    if(size(input_vector,1) ~= 1)
        row_vec = input_vector';
    else
        row_vec = input_vector;
    end
    
    