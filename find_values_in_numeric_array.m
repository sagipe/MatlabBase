function vals_lidxs = find_values_in_numeric_array(array, values_array)
% function vals_lidxs = find_values_in_numeric_array(array, values_array)
%
% Finds all occurances of the elements in values_array in array
%
% INPUTS:
% array: [array] of numeric values to look in. Values can repeat themselves.
% values_array: [array] of numeric values to look for
%
% OUTPUTS:
% vals_idxs: [array] of LOGICAL indices in array of all occurances of the values in values_array
%
% For example:
% array = [1 2 2 3 2 5 6 7];
% values_array = [2 7];
% vals_idxs = find_values_in_numeric_array(array, values_array)
% 
% vals_idxs =
% 
%      0     1     1     0     1     0     0     1
%
% Sagi Perel, 06/2010

    if(nargin ~= 2)
        error('find_values_in_numeric_array: wrong number of input arguments provided');
    end
    if(~isvector(array) || ~isvector(values_array))
        error('find_values_in_numeric_array: input arguments must be vectors');
    end
    array = make_row_vector(array);
    values_array = make_column_vector(unique(values_array));
    
    num_elements_in_array = length(array);
    num_vals_to_find = length(values_array);
    
    rarray = repmat(array, [num_vals_to_find 1]);
    rvalues_array = repmat(values_array, [1 num_elements_in_array]);
    
    vals_lidxs = logical(sum(rarray == rvalues_array));

    % TBC: could be more efficient with something along the lines of:
%     fun_is_equal = @(x,y)(any(x==y));
%     arrayfun
