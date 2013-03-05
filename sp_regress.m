function [coefficient_estimates stats response_hat] = sp_regress(response, predictors, type, glmtype)
% function [coefficient_estimates stats response_hat] = sp_regress(responses, predictors, type, glmtype)
% Implements multiple linear regression using Matlab regress:
% It checks the input arguments for consistency and takes care of adding a column of ones to the predicators
% Also packs the output statistics in a more convenient way
%
% Also implements Generalized Linear Regression using glmfit
% 
% INPUTS: (regression model y=b*X)
% response  : [y] [n x 1] vector of observed responses
% predictors : [X] [n x p] matrix of p predictors at each of n observations
% [type]     : [string] {'linear' (Default), 'glm','spline'}
%                       'spline' uses the ARES package
% [glmtype]  : [string] 'poisson'
%
% OUTPUTS:
% coefficient_estimates: [array]
% stats: modified output from regress/ glmfit
% response_hat: the estimated response
% 
% Sagi Perel, 02/2009

    if(~isvector(response))
        error('sp_regress: responses must be a vector');
    else
        response = make_column_vector(response);
    end
    n1 = length(response);
    n2 = size(predictors,1);
    if(n1 ~= n2)
        error(['sp_regress: number of rows in response (' num2str(n1) ') must match the number of rows in predictors (' num2str(n2) ')']);
    end
    
    if(~exist('type','var'))
        type = 'linear';
    end
    if(~exist('glmtype','var'))
        glmtype = 'poisson';
    end
    
    switch(type)
        case 'linear'
%             predicators = [ones(size(predictors,1),1) predictors];
%             % [b,bint,r,rint,stats] = regress(y,X) % X- [n x p] predictors, y- [n x 1] responses
%             % X is an n-by-p matrix of p predictors at each of n observations. y is an n-by-1 vector of observed responses
%             [coefficient_estimates, bint , r, rint, r_stats] = regress(responses, predictors);
%             % output from regress:
%             % bint : p-by-2 matrix bint of 95% confidence intervals for the coefficient estimates
%             % r    : n-by-1 vector r of residuals
%             % rint : n-by-2 matrix rint of intervals that can be used to diagnose outliers. If the interval rint(i,:) for
%             %        observation i does not contain zero, the corresponding residual is larger than expected in 95% of new observations, suggesting an outlier
%             % stats: 1-by-4 vector : [R2 statistic, the F statistic, its p-value, estimate of the error variance]
%             stats.bint = bint;
%             stats.r    = r;
%             stats.rint = rint;
%             stats.r2   = r_stats(1);
%             stats.f    = r_stats(2);
%             stats.p    = r_stats(3);
%             stats.error_variance = r_stats(4);

            whichstats = {'beta','r','rsquare','fstat','tstat'};
            % By default, regstats adds a first column of 1s to X
            stats = regstats(response, predictors,'linear',whichstats);
            coefficient_estimates = stats.beta;
            if(nargout > 2)
                response_hat = [ones( size(predictors,1), 1) predictors] * coefficient_estimates;
            end
            
        case 'glm'
            % By default, glmfit adds a first column of 1s to X
            % [b,dev,stats] = glmfit(X,y,distr); % X- [n x p] predictors, y- [n x 1] responses
            [coefficient_estimates, deviance, stats] = glmfit(predictors, response, glmtype);
            % output from glmfit:
            % deviance: the deviance of the fit at the solution vector. The deviance is a generalization of the residual sum of
            %           squares. It is possible to perform an analysis of deviance to compare several models, each a subset of the
            %           other, and to test whether the model with more terms is significantly better than the model with fewer terms.
            % stats   : a structure with the following fields:
            %           beta — Coefficient estimates b        | dfe — Degrees of freedom for error     | s — Theoretical or estimated dispersion parameter
            %           sfit — Estimated dispersion parameter | se — Vector of standard errors of the coefficient estimates b | coeffcorr — Correlation matrix for b
            %         covb — Estimated covariance matrix for B| t — t statistics for b                 | p — p-values for b
            %           resid — Vector of residuals           | residp — Vector of Pearson residuals   | residd — Vector of deviance residuals
            %           resida — Vector of Anscombe residuals
            %
            % An example for relative sizes of fields:
            %              beta: [385x1 double]
            %           dfe: 373481
            %          sfit: 0.9859
            %             s: 1
            %       estdisp: 0
            %          covb: [385x385 double]
            %            se: [385x1 double]
            %     coeffcorr: [385x385 double]
            %             t: [385x1 double]
            %             p: [385x1 double]
            %         resid: [373866x1 double]
            %        residp: [373866x1 double]
            %        residd: [373866x1 double]
            %        resida: [373866x1 double]
            %      deviance: 7.3563e+04
            stats.deviance = deviance;
            if(nargout > 2)
                error('TBC');
            end
            
        case 'spline'
            % remove NaN values
            nan_responses_lidx  = isnan(response);
            nan_predictors_lidx = sum(isnan(predictors),2);
            nan_lidx = nan_responses_lidx | nan_predictors_lidx;
            if(any(nan_lidx))
                log_disp(['sp_regress: eliminated ' num2str(sum(nan_lidx)) '/' num2str(length(response)) ' NaN values']);
            end
            
            predictors = sp_zscore(predictors(~nan_lidx,:));
            response   = sp_zscore(response(~nan_lidx));
            
            stats = aresbuild(predictors, response);
            coefficient_estimates = stats.coefs; 

%             model         : The built ARES model a structure with the following elements:
%               coefs       : Coefficient vector of the regression model (for the intercept term and each basis function).
%               knotdims   : Cell array of indexes of used input variables for each knot in each basis function.
%               knotsites   : Cell array of knot sites for each knot and used input variable in each basis function.
%               knotdirs   : Cell array of directions (-1 or 1) of the hinge functions for each used input variable in each basis function.
%               parents     : Vector of indexes of direct parents for each basis function (0 if there is no direct parent or it is the intercept term).
%               trainParams : A structure of training parameters for the algorithm (the same as in the function input).
%               MSE         : Mean Squared Error of the model in the training data.
%               GCV         : Generalized Cross-Validation (GCV) of the model in the taining data set. The value may also be Inf if model's
%                             effective number of parameters is larger than or equal to n.
%               t1          : For piecewise-cubic models only. Matrix of knot sites for the additional knots on the left of the central knot.
%               t2          : For piecewise-cubic models only. Matrix of knot sites for the additional knots on the right of the central knot.
%               minX        : Vector of minimums for input variables (used for t1 and t2 placements as well as for model plotting).
%               maxX        : Vector of maximums for input variables (used for t1 and t2 placements as well as for model plotting).
%               endSpan     : The used value of endSpan.
            if(nargout > 2)
                response_hat  = sp_spline_predict(stats, predictors);
                stats.rsquare = sp_compute_r2(response, response_hat);
                stats.rmse    = sp_compute_RMSE(response, response_hat);
            end
            
        otherwise
            error('sp_regress: unknown regression type');
            
    end
    
    