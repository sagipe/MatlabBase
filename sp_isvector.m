function TF = sp_isvector(data)
% function TF = sp_isvector(data)
%
% Returns TRUE only if data is a double vector with at least two elements
% Returns FALSE otherwise (scalar, cell array)
% This behavior is different from Matlab's isvector()
%
% INPUTS:
% data: A Matlab data struct
%
% OUTPUTS:
% TF: [bool]
%
% Sagi Perel, 01/2013

    if(nargin ~= 1)
        error('sp_isvector: wrong number of input arguments provided');
    end
    TF = false;
    if(isa(data,'double') && ~isempty(data) && ~iscell(data) && ~isscalar(data))
        data_size = size(data);
        if(ndims(data) == 2 && (any(data_size == 1) && any(data_size > 1)))
            TF = true;
        end
    else
        TF = false;
    end