function str = sp_sprintf(double_value, num_digits_right_of_decimal_point)
% function str = sp_sprintf(double_value, num_digits_right_of_decimal_point)
%
% Returns a string representing the given double value as a string
% Uses exactly num_digits_right_of_decimal_point to the right of the decimal point
%
% INPUTS:
% double_value: [double] scalar OR [vector] of scalars
% [num_digits_right_of_decimal_point]: [int] Default: 2
%
% OUTPUTS:
% str: [string] OR [cell array] of strings
%
% Sagi Perel, 02/2012
    
    if(nargin < 1 || nargin > 2)
        error('sp_sprintf: wrong number of input arguments provided');
    end
    if(~isscalar(double_value) && ~isvector(double_value))
        error('sp_sprintf: double_value must be a scalar or a vector');
    end
    if(~exist('num_digits_right_of_decimal_point','var'))
        num_digits_right_of_decimal_point = 2;
    else
        if(~sp_is_integer(num_digits_right_of_decimal_point))
            error('sp_sprintf: num_digits_right_of_decimal_point must be an integer');
        end
    end
    
    if(isscalar(double_value))
        str = sprintf(['%.' num2str(num_digits_right_of_decimal_point) 'f'], double_value);
    else
        str = cell(1,length(double_value));
        for i=1:length(double_value)
            str{i} = sprintf(['%.' num2str(num_digits_right_of_decimal_point) 'f'], double_value(i));
        end
    end
    