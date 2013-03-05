function [y_hat R P] = sp_linear_predict(Bs, X, y)
% function [y_hat R P] = sp_linear_predict(Bs, X, y)
% 
% Returns the prediction y_hat = X*Bs for the linear model specified in Bs.
% 
% INPUTS:
% Bs : [array][px1] with linear model coefficients (including intercept)
% X  : [matrix][Nxp-1] predictors
% [y]: [array][Nx1] response
%
% OUTPUTS:
% y_hat : [array][Nx1] linear prediction
% R     : [double] Correlation coefficient between y and y_hat
% P     : [double] P-value for correlation coefficient between y and y_hat
%
% Sagi Perel, 02/2012

    if(nargin < 2 || nargin > 3)
        error('sp_linear_predict: wrong number of input arguments provided');
    end
    if(nargout > 1 && nargin < 3)
        error('sp_linear_predict: you must provide y to compute R');
    end
    if(~isvector(Bs))
        error('sp_linear_predict: Bs must be a vector');
    else
        P = length(Bs)-1;
    end
    [N Px] = size(X);
    if(P ~= Px)
        error('sp_linear_predict: number of coefficients in Bs does not match the number of predictors in X');
    end
    if(exist('y','var'))
        if(~isvector(y))
            error('sp_linear_predict: y must be a vector');
        else
            if(length(y) ~= N)
                error('sp_linear_predict: the number of samples in y does not match the number of samples in X');
            end
        end
    end
    
    y_hat = [ones(N,1) X] * Bs;
    
    if(nargout > 1)
        [R P] = sp_corrcoef(y, y_hat);
    end
    