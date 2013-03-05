function [is_model2_better_than_1 F F_critical] = Compare_linear_models(model1_num_df, model2_num_df, model1_resid, model2_resid, alpha)
% function is_model2_better_than_1 = Compare_linear_models(model1_num_df, model2_num_df, model1_resid, model2_resid, alpha)
%
% Compares the two linear models, obtained by linear regression and returns a boolean specifying if model2 is better
% than model1, where model2_num_df > model1_num_df
%
% INPUTS:
% model1_num_df: [int] Number of DF in model1
% model2_num_df: [int] Number of DF in model2. model2_num_df > model1_num_df
% model1_resid : [array][Nx1] vector of residuals
% model2_resid : [array][Nx1] vector of residuals
% [alpha]      : Default: 0.05
%
% OUTPUTS:
% is_model2_better_than_1: [bool] 
% F         : [double] the calculated F statistic
% F_critical: [double] the calculated critical F value
%
% Sagi Perel, 06/2010

    %--- sanity check on inputs
    if(nargin < 4 || nargin > 5)
        error('Compare_linear_models: wrong number of input arguments provided');
    end
    if(model1_num_df >= model2_num_df)
        error('Compare_linear_models: model2_num_df must be greater than model1_num_df');
    end
    if(~isvector(model1_resid) || ~isvector(model2_resid))
        error('Compare_linear_models: residuals must be non empty vectors');
    end
    if(length(model1_resid) ~= length(model2_resid))
        error('Compare_linear_models: model1_resid, model2_resid must have the same number of residual values');
    end
    if(~exist('alpha','var'))
        alpha = 0.05;
    end
    
    %--- compare the models
    N = length(model1_resid);
    RSS1 = nansum(model1_resid .^ 2);
    RSS2 = nansum(model2_resid .^ 2);
    
    F = ( (RSS1-RSS2)/(model2_num_df-model1_num_df) ) / ( (RSS2/(N-model2_num_df) ) );
    
    F_critical = finv(alpha, model1_num_df, model2_num_df);
    
    if(F > F_critical)
        is_model2_better_than_1 = true;
    else
        is_model2_better_than_1 = false;
    end
    