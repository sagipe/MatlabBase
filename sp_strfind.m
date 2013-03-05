function k = sp_strfind(arg1, arg2)
% function k = sp_strfind(str, pattern)
% function k = sp_strfind(cellstr, pattern)
% function k = sp_strfind(char array, pattern)
%
% A wrapper for strfind which supports an additional case where arg1 is a char array and arg2 is a string to match
% 
% INPUTS:
% arg1: [string] OR [cell array of strings] OR [char array]
% arg2: [string
%
% OUTPUTS:
% k: [array] of starting indices of arg2 in arg1 when both are strings
%    [cell array][num cells x 1] with starting indices for every input cell
%    [array] of starting indices of arg2 in arg2 when 
%
% Sagi Perel, 03/2012
    
    if(nargin~=2)
        error('sp_strfind: wrong number of input arguments provided');
    end
    class1 = class(arg1);
    class2 = class(arg2);
    
    % check if we need to handle case 3, otherwise use strfind
    if(all(strcmp({class1,class2},{'char','char'})) && size(arg1,1) > 1)
        convert_output = true;
        % convert arg1 to cell array of strings
        arg1 = cellstr(arg1);
    else
        convert_output = false;
    end
    
    k = strfind(arg1, arg2);
    if(convert_output)
        % k is a cell array of indices (doubles) with the same number of rows as arg1
        % so convert to indices
        tmp = cellfun(@isempty, k);
        k = find(~tmp);
    end