function [y_hat R P] = sp_spline_predict(model, X, y)
% function [y_hat R P] = sp_spline_predict(model, X, y)
% 
% Returns the prediction y_hat for the spline regression model specified in model
% 
% INPUTS:
% model: [struct] output of aresbuild()
% X    : [matrix][Nxp] predictors
% [y]  : [array][Nx1] response
%
% OUTPUTS:
% y_hat : [array][Nx1] spline regression prediction
% R     : [double] Correlation coefficient between y and y_hat
% P     : [double] P-value for correlation coefficient between y and y_hat
%
% Sagi Perel, 02/2012

    if(nargin < 2 || nargin > 3)
        error('sp_spline_predict: wrong number of input arguments provided');
    end
    if(nargout > 1 && nargin < 3)
        error('sp_spline_predict: you must provide y to compute R');
    end
    if(~isstruct(model))
        error('sp_spline_predict: model must be a vector');
    end
    [N P] = size(X);
    if(exist('y','var'))
        if(~isvector(y))
            error('sp_spline_predict: y must be a vector');
        else
            if(length(y) ~= N)
                error('sp_spline_predict: the number of samples in y does not match the number of samples in X');
            end
        end
    end
    
    y_hat = arespredict(model, X);
    if(nargout > 1)
        [R P] = sp_corrcoef(y, y_hat);
    end
    