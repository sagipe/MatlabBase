function TF = sp_ismatrix(data, num_dims)
% function TF = sp_ismatrix(data, num_dims)
%
% Returns TRUE only if data is a double matrix (at least 2x2)
% Returns FALSE otherwise (scalar, cell array)
% This behavior is different from Matlab's ismatrix()
%
% INPUTS:
% data      : A Matlab data struct
% [num_dims]: [int] Default: 2. Number of dimensions in the matrix.
%
% OUTPUTS:
% TF: [bool]
%
% Sagi Perel, 01/2013

    if(nargin < 1 || nargin > 2)
        error('sp_ismatrix: wrong number of input arguments provided');
    end
    if(~exist('num_dims','var') || isempty(num_dims))
        num_dims = 2;
    end
    
    TF = false;
    if(isa(data,'double') && ~isempty(data) && ~iscell(data) && ~isscalar(data))
        data_size = size(data);
        if(ndims(data) == num_dims && all(data_size > 1) )
            TF = true;
        end
    else
        TF = false;
    end