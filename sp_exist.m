function A = sp_exist(name, kind)
% function A = sp_exist(name, kind)
%
% A wrapper for exist, which behaves differently for:
% kind=='file' || kind=='dir' -> returns a boolean
% but behaves the same as exist for all other values of kind
%
% INPUTS:
% name: [string]
% kind: [string]
%
% OUTPUTS:
% A: [bool] for kind=='file' || kind=='dir', OR the return value from exist
%
% Sagi Perel, 09/2012

    if(nargin ~= 2)
        error('sp_exist: wrong number of input arguments provided');
    end
    if(~ischar(name))
        error('sp_exist: name must be a string');
    end
    if(~ischar(kind))
        error('sp_exist: kind must be a string');
    end
    
    A = exist(name, kind);
    
    switch(kind)
        case 'file'
            if(A==2)
                A = true;
            else
                A = false;
            end
        case 'dir'
            if(A==7)
                A = true;
            else
                A = false;
            end
    end
    
    