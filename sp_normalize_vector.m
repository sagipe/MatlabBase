function norm_vector = sp_normalize_vector(vector, tolerance)
% function norm_vector = sp_normalize_vector(vector, tolerance)
%
% Normalizes the given vector(s) to unit vector(s).
% If tolerance is specified, a zero length vector will be zeroed.
%
% INPUT:
% vector: [NxD] vectors in rows
% [tolerance]: [double] samples in vector between [-tolerance,+tolerance] will be considered as zero
%              to prevent numerical instabilities, where for example a [Nx2] vector with entry [1e-21 1e-5] will end up
%              normalized as [1e-21 1] instead of [0 0].  
%              If not specified, then it will not be used.
%
% OUTPUT:
% norm_vector: [NxD] vectors in rows, with unit magnitude (except for the zero vector)
%
% Sagi Perel, 07/2012

    if(nargin < 1 || nargin > 2)
        error('sp_normalize_vector: wrong number of input arguments provided');
    end
    if(~ismatrix(vector))
        error('sp_normalize_vector: vector must be a matrix');
    end
    if(~exist('tolerance','var'))
        tolerance = [];
    else
        tolerance = abs(tolerance);
    end
    mag = 1./sqrt(sum(vector.^2,2));
%     mag( mag>(-1e-8) & mag<1e-8 ) = 1;                    
%     norm_vector = bsxfun(@rdivide, vector, mag );
    norm_vector = bsxfun(@times, vector, mag ); % faster to use 1/.. then @times than rdivide
    if(~isempty(tolerance))
        lidx_to_zero = all(vector>(-tolerance) & vector<tolerance,2);
        norm_vector(lidx_to_zero,:) = 0;
    end
    