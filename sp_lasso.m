function [coefficient_estimates stats] = sp_lasso(responses, predictors, type, varargin)
% function [coefficient_estimates stats] = sp_lasso(responses, predictors, type, varargin)
%
% Implements lasso (Regularized least-squares regression) using either Matlab's lasso (added in R2011b), or cvglmnet.
% 
% cvglmnet:
% (1) Coefficients returned are for the largest lambda which has a smaller mse than the stderr of lambda_min,
%     which is the largest lambda of the smallest cvm.
%
% INPUTS:
% responses  : [y] [n x 1] vector of observed responses
% predictors : [X] [n x p] matrix of p predictors at each of n observations
% [type]     : [string] {'lasso' (Default), 'cvglmnet'}. If the function 'lasso' does not exist, defaults to 'cvglmnet'
%
% OUTPUTS:
% coefficient_estimates: [array]
% stats: 
% 
% Sagi Perel, 01/2012

    if(~isvector(responses))
        error('sp_lasso: responses must be a vector');
    else
        responses = make_column_vector(responses);
    end
    n1 = length(responses);
    n2 = size(predictors,1);
    if(n1 ~= n2)
        error('sp_lasso: number of rows in responses must match the number of rows in predictors');
    end
    
    if(~exist('type','var'))
        type = 'lasso';
    else
        switch(type)
            case {'lasso','cvglmnet'}
            otherwise
                error(['sp_lasso: Unknown type [' type ']']);
        end
    end
    
    if(strcmp(type,'lasso'))
        if(exist('lasso','file')==0)
            % lasso does not exist, default to cvglmnet
            type = 'cvglmnet';
        end
    end
    if(strcmp(type,'cvglmnet'))
        if(exist('cvglmnet','file')==0)
            % cvglmnet does not exist
            error('sp_lasso: cvglmnet is not in the Matlab path');
        end
    end
    
    nan_lidx = any(isnan(responses),2) | isnan(predictors);
    
    switch(type)
        case 'lasso'
            [B, stats] = lasso(double(predictors(~nan_lidx,:)), double(responses(~nan_lidx)), 'CV', 100);
            lam = fitinfo.Index1SE; % find index of suggested (lse) lambda 
            coefficient_estimates = B(:,lam);
            
        case 'cvglmnet'
            % lasso library settings
            nfolds  = 100; % How many folds to evaluate
            verbous = false;
            
            % compute the lasso cross validation
            stats = cvglmnet(double(predictors(~nan_lidx,:)), make_column_vector(double(responses(~nan_lidx))),nfolds,[],'response','gaussian',glmnetSet,verbous);
            
            % Important fields in the stats struct:
            % stats.lambda_min: if there are several minima, choose largest lambda of the smallest cvm
            % stats.lambda_min=max(options.lambda(stats.cvm<=min(stats.cvm)));
            %
            % stats.lambda_1se:
            % The largest lambda which has a smaller mse than the stderr of lambda_min.
            % In other words, this defines the uncertainty of the min-cv, and the min
            % cv-err could in essence be any model in this interval.
            % 
            % Find stderr for lambda(min(sterr))
            % semin=stats.cvup(options.lambda==stats.lambda_min);
            % stats.lambda_1se=max(options.lambda(CVerr.cvm<semin));
            
            % find the coefficients:
            lcv_beta_lse = glmnetCoef( stats.glmnet_object, stats.lambda_1se );
            lcv_beta_min = glmnetCoef( stats.glmnet_object, stats.lambda_min );
            
            coefficient_estimates = lcv_beta_lse;
            stats.lcv_beta_lse = lcv_beta_lse;
            stats.lcv_beta_min = lcv_beta_min;
            
            stats.y_hat = glmnetPredict(stats.glmnet_object, 'link', predictors, stats.lambda_min);
    end
    
    