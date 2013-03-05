function column_vec = make_column_vector(input_vector)
% function column_vec = make_column_vector(input_vector)
% 
% Outputs the input vector as a column vector
%
% INPUTS:
% input_vector  : [array] a vector
%
% OUTPUTS:
% column_vec: [column array]
%
% Sagi Perel, 12/2008

    if(nargin ~= 1)
        error('make_column_vector: wrong number of arguments provided');
    end
    if(isempty(input_vector))
%         error('make_column_vector: input_vector is empty');
        column_vec = [];
        return;
    end
    if(~isvector(input_vector))
        error('make_column_vector: input_vector must be a vector');
    end
    
    % if number of columns is different than 1, then it's a row vector
    if(size(input_vector,2) ~= 1)
        column_vec = input_vector';
    else
        column_vec = input_vector;
    end
    
    