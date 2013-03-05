function C = sp_cov(x)
% function C = sp_cov(x)
%
% A wrapper to cov which removes NaN rows from the input before computing the covariance.
% This function just handles the simple case where x is either a vector or a matrix.
% This is useful for large matrices with some NaN rows
%
% Sagi Perel, 05/2011

    if(nargin ~= 1)
        error('sp_cov: wrong number of input arguments provided');
    end
    if(isempty(x))
        error('sp_cov: x cannot be empty');
    end
    
    nan_rows_lidx = sum(isnan(x),2);
    C = cov(x(~nan_rows_lidx,:));

