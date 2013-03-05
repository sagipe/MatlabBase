function s_struct = sp_strip_struct(o_struct, field_names, action_str)
% function s_struct = sp_strip_struct(o_struct, field_names, action_str)
%
% Strips the struct (or struct array) o_struct
% from the specified fields according to action_str
%
% INPUTS:
% o_struct    : [struct] OR [struct array]
% field_names : [cell array] of strings, with field names; or a string
% [action_str]: [string] 'keep' (Default): keep the specified field names
%                        'remove'        : remove the specified field names
% 
% OUTPUTS:
% s_struct: [struct] OR [struct array] only with fields specified in field_names_to_keep
%
% Sagi Perel, 02/2012

    if(nargin < 2 || nargin > 3)
        error('sp_strip_struct: wrong number of input arguments given');
    end
    if(~isstruct(o_struct))
        error('sp_strip_struct: input o_struct must be a struct');
    end
    if(~iscell(field_names))
        if(ischar(field_names))
            field_names = {field_names};
        else
            error('sp_strip_struct: input field_names must be a cell array or a string');
        end
    else
        if(~all(cellfun(@ischar,field_names)))
            error('sp_strip_struct: input field_names must be a cell array containing only strings');
        end
    end
    if(~exist('action_str','var'))
        action_str = 'keep';
    else
        if(~any(strcmp(action_str,{'keep','remove'})))
            error(['sp_strip_struct: unknown value for action_str=[' action_str ']']);
        end
    end
    
    
    
    switch(action_str)
        case 'keep'
            % field_names has the field names to keep
            all_fields = fieldnames(o_struct);
            field_names_to_remove = setdiff(all_fields, field_names);
        case 'remove'
            % field_names has the field names to remove
            field_names_to_remove = field_names;
    end
    
    s_struct = rmfield(o_struct, field_names_to_remove);
        
    