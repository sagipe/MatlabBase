function C = sp_cov(x, perc_nan_to_ignore)
% function C = sp_cov(x, perc_nan_to_ignore)
%
% A wrapper to cov which removes NaN rows from the input before computing the covariance.
% This function just handles the simple case where x is either a vector or a matrix.
% This is useful for large matrices with some NaN rows.
% If some columns have a large number of NaNs, adjust perc_nan_to_ignore
% accordingly
%
% INPUTS:
% x : [vector] or [matrix]
% [perc_nan_to_ignore]: [double][0-1] if the percentage of NaN values
%                       is higher than this value, those columns will be
%                       ignored. Default: 1 (do not ignore any columns)
%
% Sagi Perel, 05/2011

    if(nargin < 1 || nargin > 2)
        error('sp_cov: wrong number of input arguments provided');
    end
    if(isempty(x))
        error('sp_cov: x cannot be empty');
    elseif(sp_isvector(x))
        x = make_column_vector(x);
    end
    if(~exist('perc_nan_to_ignore','var') || isempty(perc_nan_to_ignore))
        perc_nan_to_ignore = 1;
    end
    
    cols_perc_nan = sum(isnan(x))./size(x,1);
    cols_to_ignore_lidx = (cols_perc_nan > perc_nan_to_ignore);
    
    nan_rows_lidx = sum(isnan(x(:,~cols_to_ignore_lidx)),2);
    if(any(cols_to_ignore_lidx))
        C = nan(length(cols_to_ignore_lidx), length(cols_to_ignore_lidx));
        C(~cols_to_ignore_lidx, ~cols_to_ignore_lidx) = cov(x(~nan_rows_lidx, ~cols_to_ignore_lidx));
    else
        C = cov(x(~nan_rows_lidx,:));
    end
    
