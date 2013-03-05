function Z = sp_zscore_matrix3(X)
% function Z = sp_zscore_matrix3(X)
%
% Z-scores matrix X in the 3rd dimension, ignoring NaN values.
% It computes the mean and SD from all elements in every matrix in the 3rd dimensions, and z-scores the matrix by them.
%
% INPUT:
% X: [m x n x p]
% 
% OUTPUT:
% Z: [m x n x p]
%
% Sagi Perel, 03/2012

    if(nargin~=1)
        error('sp_zscore_matrix3: wrong number of input arguments provided');
    end
    if(~isa(X,'numeric'))
        error('sp_zscore_matrix3: X must be a matrix');
    end
    
    Z = X;
    
    for i=1:size(X,3)
        X0 = X(:,:,i);
        X0 = X0(:); % all elements as a single vector
        mu = nanmean(X0);
        sigma0 = nanstd(X0);
        if(sigma0==0)
            sigma0=1;
        end
        Z(:,:,i) = bsxfun(@minus,Z(:,:,i), mu);
        Z(:,:,i) = bsxfun(@rdivide, Z(:,:,i), sigma0);
    end