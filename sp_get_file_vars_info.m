function [var_names vars] = sp_get_file_vars_info(file_path)
% function [var_names vars] = sp_get_file_vars_info(file_path)
%
% Returns a cell array with all variables in the given file
%
% INPUTS:
% file_path: [string] a path of an existing .mat file
%
% OUTPUTS:
% var_names: [cell array] of string variable names
% vars     : [struct array] returned from using whos with fields:
%            'name','size','bytes','class','global','sparse','complex','nesting'
%          e.g.:
%                       name: 'Data'
%                       size: [1 59]
%                      bytes: 838427976
%                      class: 'struct'
%                     global: 0
%                     sparse: 0
%                    complex: 0
%                    nesting: [1x1 struct]
%                 persistent: 0
% 
% Sagi Perel, 09/2012

    if(nargin ~= 1)
        error('sp_get_file_vars_info: wrong number of input arguments provided');
    end
    if(~ischar(file_path))
        error('sp_get_file_vars_info: file_path must be a string');
    end
    if(~sp_exist(file_path,'file'))
        error('sp_get_file_vars_info: file_path must be the path to an existing file');
    end
    
    vars = whos('-file', file_path);
    var_names = {vars.name};