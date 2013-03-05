function TF = sp_iscellarray(data)
% function TF = sp_iscellarray(data)
%
% Returns TRUE only if data is a cell array with at least two elements
% Returns FALSE otherwise
% This behavior is different from Matlab's iscell()
%
% INPUTS:
% data: A Matlab data struct
%
% OUTPUTS:
% TF: [bool]
%
% Sagi Perel, 01/2013

    if(nargin ~= 1)
        error('sp_iscellarray: wrong number of input arguments provided');
    end
    TF = false;
    if(isa(data,'cell') && ~isempty(data))
        data_size = size(data);
        if(ndims(data) == 2 && (any(data_size == 1) && any(data_size > 1)))
            TF = true;
        end
    else
        TF = false;
    end