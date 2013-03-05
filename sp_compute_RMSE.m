function RMSE = sp_compute_RMSE(y, yhat)
% function RMSE = sp_compute_RMSE(y, yhat)
% 
% Computes the RMSE for the given vectors, ignoring NaN values:
% RMSE(yhat) = sqrt( MSE(yhat) ) = sqrt( E[(yhat-y).^2] ) = sqrt( (1/n)*( sum( (yhat-y).^2 ) ))
% For an unbiased estimator, the RMSE is the square root of the variance, known as the standard error.
%
% If y,yhat are matrices, then:
% RMSE(yhat) = sqrt( (1/n)*( sum( (yhat(:,1)-y(:,1)).^2 + (yhat(:,2)-y(:,2)).^2 + ... )
%
% INPUTS:
% y   : [vector] responses OR [matrix][NxC] of multi-dimensional response in columns
% yhat: [vector] estimated responses OR [matrix][NxC] of estimated multi-dimensional response in columns
%
% OUTPUTS:
% RMSE : [double]
%
% Sagi Perel, 08/2012

    if(nargin ~= 2)
        error('sp_compute_RMSE: wrong number of input arguments provided');
    end
    if(~ismatrix(y)||~ismatrix(yhat))
        error('sp_compute_RMSE: y and yhat must be matrices');
    end
    if(~all(size(y)==size(yhat)))
        error('sp_compute_RMSE: y and yhat must have the same size');
    end    
    % eliminate NaNs
    nan_lidx = any(isnan(y),2) | any(isnan(yhat),2);
    if(all(nan_lidx))
        RMSE = NaN;
        return;
    end
    
    y(nan_lidx,:)    = [];
    yhat(nan_lidx,:) = [];

    r = y-yhat;                  % Residuals.
    if(isvector(r))
        RMSE = (1/sqrt(length(r))) .* norm(r); % norm is: sqrt(sum of squares (r) )  = sqrt( sum( r.^2 ))
    else
        % for matrices: we want to compute the sqrt( sum( sum ( squares of rows of r ) ) )
        % norm computes the matrix norm, which is something else.
        RMSE = (1/sqrt(size(r,1))) .* sqrt( sum( sum( r.^2, 2) ) );
    end
    