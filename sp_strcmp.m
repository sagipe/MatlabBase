function [TF lidx] = sp_strcmp(arg1, arg2)
% function [TF lidx] = sp_strcmp(arg1, arg2)
% 
% A wrapper to strcmp, which compares:
% (1) two strings for equality
% (2) a string (arg1) with each element of a cell array of strings (arg2) and returns TRUE if any match is found
% (3) each element of one cell array of strings with the same element of the other and returns TRUE if ANY match is found
% (4) [*] a string (arg1) with each row of a char array (arg2) and returns TRUE if any match is found
%
% INPUTS:
% arg1: [string] OR [string]                OR [cell array of strings] OR [string]
% arg2: [string[ OR [cell array of strings] OR [cell array of strings] OR [char array]
%
% OUTPUTS:
% TF  : [bool]
% lidx: [array of logical indices]
%
% Sagi Perel, 03/2012
    
    if(nargin~=2)
        error('sp_strcmp: wrong number of input arguments provided');
    end
    class1 = class(arg1);
    class2 = class(arg2);
    
    % check if we need to handle case 4, otherwise use strcmp
    if(all(strcmp({class1,class2},{'char','char'})) && size(arg2,1) > 1)
        % convert arg2 to cell array of strings
        arg2 = cellstr(arg2);
    end
    lidx = strcmp(arg1, arg2);
    TF = any(lidx);