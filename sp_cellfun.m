function C = sp_cellfun(FUN, C)
% function C = sp_cellfun(FUN, C)
%
% A wrapper for cellfun(FUN,C) which calls:
% cellfun(FUN, C, 'UniformOutput',false) to make the output a cell array
%
% Sagi Perel, 04/11

    if(nargin ~= 2)
        error('sp_cellfun: usage: C = sp_cellfun(FUN, C)');
    end
    if(~isa(FUN,'function_handle'))
        error('sp_cellfun: FUN must be a function handle');
    end
    if(~iscell(C))
        error('sp_cellfun: C must be a cell array');
    end
    
    C = cellfun(FUN, C, 'UniformOutput',false);


