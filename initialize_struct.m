function empty_struct = initialize_struct(varargin)
% function empty_struct = initalize_struct(varargin)
%
% Initializes a struct with the given names
% All fields are initialized to {}, so an empty struct (0x0) is created.
% 
% INPUTS:
% varargin: [cell array] of strings, or strings
%
% OUTPUTS:
% empty_struct: [struct] with the given field names
%
% Sagi Perel, 05/2009

    if(nargin == 0)
        error('initialize_struct: at least one field name has to be provided');
    end
    if(nargin == 1 && iscell(varargin{1}))
        names = varargin{1};
    else
        names = varargin;
    end
    
    num_fields = length(names);
    command = ['struct( ''' names{1} ''',{}'];
    for i=2:num_fields
        command = [command ', ''' names{i} ''',{}'];
    end
    command = [command ')'];
    
    empty_struct = eval(command);