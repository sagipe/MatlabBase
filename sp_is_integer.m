function TF = sp_is_integer(value)
% function TF = sp_is_integer(value)
%
% Checks if the given number has in integer value (not class!)
%
% INPUTS:
% value: [double]
%
% OUTPUTS:
% TF: [bool] if the number is an integer
%
% Sagi Perel, 01/2012

    if(nargin ~= 1)
        error('sp_is_integer: wrong number of input arguments given');
    end
    if(isempty(value))
        TF = false;
    else
        TF = (rem(value,1) == 0);
    end