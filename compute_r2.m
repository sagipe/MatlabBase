function [r2 SSE] = compute_r2(y, yhat)
% 
% Computes the r^2 for the given vectors used in a regression
%
% INPUTS:
% y   : [vector] responses
% yhat: [vector] predicted responses
%
% OUTPUTS:
% r2 : [double]
% SSE: [double] Error sum of squares
%
% Sagi Perel, 09/2010

    % Taken from regress.m:
    % There are several ways to compute R^2, all equivalent for a
    % linear model where X includes a constant term, but not equivalent
    % otherwise.  R^2 can be negative for models without an intercept.
    % This indicates that the model is inappropriate.
    r = y-yhat;                  % Residuals.
    normr = norm(r);             % sqrt(sum of squares (r) )
    SSE = normr.^2;              % Error sum of squares.
    TSS = norm(y-mean(y))^2;     % Total sum of squares.
    r2 = 1 - SSE/TSS;            % R-square statistic.

    if(r2<0)
        warning('compute_r2: r^2 is negative, did you invert y, yhat as inputs?');
    end