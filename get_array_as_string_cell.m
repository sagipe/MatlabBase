function array_as_cell = get_array_as_string_cell(double_array, suffix,prefix,fun_handle,skip_step)
% function array_as_cell = get_array_as_string_cell(double_array, suffix,prefix,fun_handle,skip_step)
%
% Returns a cell array with string values of the double array values
%
% INPUTS: 
% double_array: double array
% [suffix]: [string] Default: ''. A suffix to be added to each string
% [prefix]: [string] Default: ''. A prefix to be added to each string
% [fun_handle]: [function handle] Default: []. Function to apply to the value in the array, which should output a string
% [skip_step] : [int] Default: 1. The first value will be converted to a string, then every consecutive <skip_step> value
% 
% OUTPUTS:
% array_as_cell: cell
%
% Sagi Perel, 09/2008

    % sanity check on inputs
    if(~exist('double_array','var'))
        error('get_array_as_string_cell: missing input variable double_array');
    end
    if(~isvector(double_array))
        error('get_array_as_string_cell: double_array must be a vector!');
    end
    if(~exist('suffix','var'))
        suffix = '';
    end
    if(~exist('prefix','var'))
        prefix = '';
    end
    if(~exist('fun_handle','var'))
        fun_handle = [];
    end
    if(~exist('skip_step','var'))
        skip_step = 1;
    end
    
    len = length(double_array);
    array_as_cell = cell(1,len);
    
    for i=1:skip_step:len        
        if(isempty(fun_handle))
            array_as_cell{i} = [prefix num2str(double_array(i)) suffix];
        else
            str_value = feval(fun_handle, double_array(i));
            if(~ischar(str_value))
                error('get_array_as_string_cell: the function specified in fun_handle must output a string');
            end
            array_as_cell{i} = [prefix str_value suffix];
        end
    end
    
    % replace empty cells with an empty string
    array_as_cell = sp_cellfun(@(x) iff(isempty(x),'',x),array_as_cell);
    
