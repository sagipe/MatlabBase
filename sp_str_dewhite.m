function dwstr = sp_str_dewhite(str, sub_str)
% function dwstr = sp_str_dewhite(str, sub_str)
%
% Replaces all white spaces with underscores
% 
% INPUTS:
% str: [string]
% [sub_str]: [string] Default: '_'. White spaces are replaced by this string.
%
% OUTPUTS:
% dwstr: [string] with all white spaces replaced by sub_str
%
% Sagi Perel, 11/2012

    if(nargin < 1 || nargin > 2)
        error('sp_str_dewhite: wrong number of input arguments provided');
    end
    if(~ischar(str))
        error('sp_str_dewhite: str must be a string');
    end
    if(~exist('sub_str','var'))
        sub_str = '_';
    elseif(~isempty(sub_str) && ~ischar(sub_str))
        error('sp_str_dewhite: sub_str must be a string');
    end
    
    dwstr = strrep(str, ' ', sub_str);
    
