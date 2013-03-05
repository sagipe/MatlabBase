function [tokens num_tokens] = sp_strtok(text, delimiter)
% function [tokens num_tokens] = sp_strtok(text, delimiter)
%
% Splits text to tokens seperated by the given delimiter.
% It uses an internal modified version of strtok, which does not skip leading/trailing delimieters
% 
% INPUTS:
% text     : [string] string to seperate by the given delimiter
% [delimiter]: [string] or [array] Default: [9:13 32]; % White space characters
%            Char to seperate by ( If the delimiter input specifies more than one character, this function treats each
%            character as a separate delimiter; it does not treat the multiple characters as a delimiting string. 
%            The number and order of characters in the delimiter argument is unimportant.
%
% OUTPUTS:
% tokens: [cell] array with the tokens
% num_tokens: [double] the number of tokens found
% 
% Sagi Perel, 12/2009

    if(nargin < 1 || nargin > 2)
        error('sp_strtok: wrong number of input arguments provided');
    end
    if(isempty(text))
        tokens = {};
        num_tokens = 0;
        return;
    end
    if(~exist('delimiter','var') || isempty(delimiter))
        delimiter = [9:13 32]; % White space characters
    elseif(~ischar(delimiter) && ~isvector(delimiter))
        error('sp_strtok: delimiter must be a string or a vector of byte values');
    end
    
    tokens = {};
    str    = text;
    
    keep_going = 1;
    while(keep_going)
        if(isempty(str))
            keep_going = 0;
        else
            [segment_begin_str segment_end_str] = strtok(str, delimiter);
            tokens{end+1} = segment_begin_str;
            str = segment_end_str;
        end
    end
    
    num_tokens = length(tokens);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function [token, remainder] = strtok(string, delimiters)
%STRTOK Find token in string.
%   STRTOK(S) returns the first token in the string S delimited by "white
%   space". Any leading white space characters are ignored. If S is a
%   cell array of strings then the output is a cell array of tokens.
%
%   STRTOK(S,D) returns the first token delimited by one of the characters
%   in D. Any leading delimiter characters are ignored.
%
%   [T,R] = STRTOK(...) also returns the remainder of the original string. 
%
%   If no delimiters are found in the body of the input string, then the
%   entire string (excluding any leading delimiting characters) is returned
%   in T and R is an empty string.
%
%   See also ISSPACE, STRREAD.

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 2010-06-09 14:14:16 $

if nargin<1 
   error('MATLAB:strtok:NrInputArguments','Not enough input arguments.');
end

token = ''; remainder = '';

len = length(string);
if len == 0
    return
end

if (nargin == 1)
    delimiters = [9:13 32]; % White space characters
end

% don't skip leading delimiters
i = 1;
if(any(string(i) == delimiters))
    token = '';
    if (nargout > 1)
        remainder = string(2:length(string));
    end
    return;
end

% regular case
start = 1;
i = start;
while (~any(string(i) == delimiters))
    i = i + 1;
    if (i > len), 
       break, 
    end
end
finish = i - 1;

% don't skip trailing delimiters
if(finish+1 == length(string))
    token = string(start:finish);
    remainder = ',';
    return;
end

% regular case
token = string(start:finish);
if (nargout > 1)
    % check if we have only trailing delimiters, and then don't skip the last ','
    if(all(string(finish+1:end) == delimiters))
        remainder = string(finish + 1:length(string));
    else
        remainder = string(finish + 2:length(string));
    end    
end
