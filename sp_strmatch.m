function match_found = sp_strmatch(varargin)
% function match_found = sp_strmatch(varargin)
% 
% A wrapper for strmatch, which always returns a boolean value
%
% x = strmatch(str, strarray)
% x = strmatch(str, strarray, 'exact')
% 
% Sagi Perel, 12/2010

    x = strmatch(varargin{:});
    if(isempty(x))
        match_found = false;
    else
        match_found = true;
    end