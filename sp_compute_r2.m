function r2 = sp_compute_r2(y, yhat)
% function r2 = sp_compute_r2(y, yhat)
% 
% Computes the r^2 for the given vectors used in a regression,
% ignoring NaN values
%
% INPUTS:
% y   : [vector] responses
% yhat: [vector] estimated responses
%
% OUTPUTS:
% r2 : [double]
%
% Sagi Perel, 02/2012

    if(nargin ~= 2)
        error('sp_compute_r2: wrong number of input arguments provided');
    end
    % eliminate NaNs
    nan_lidx = isnan(y) | isnan(yhat);
    if(all(nan_lidx))
        r2 = NaN;
        return;
    end
    
    y(nan_lidx)    = [];
    yhat(nan_lidx) = [];

    % Taken from regress.m:
    % There are several ways to compute R^2, all equivalent for a
    % linear model where X includes a constant term, but not equivalent
    % otherwise.  R^2 can be negative for models without an intercept.
    % This indicates that the model is inappropriate.
    r = y-yhat;                  % Residuals.
    normr = norm(r);             % sqrt(sum of squares (r) )
    SSE = normr.^2;              % Error sum of squares.
    TSS = norm(y-nanmean(y))^2;     % Total sum of squares.
    r2 = 1 - SSE./TSS;            % R-square statistic.
