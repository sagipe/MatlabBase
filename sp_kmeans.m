function [IDX,C,sumd,D] = sp_kmeans(data_matrix,num_clusters,distance_type,missing_data_handling,arg5)
% function [IDX,C,sumd,D] = sp_kmeans(data_matrix,num_clusters,distance_type,missing_data_handling,arg5)
%
% Implements kmeans with an implementation to handle missing values.
% 
% IDX = sp_kmeans(X,k) partitions the points in the n-by-p data matrix X into k clusters. 
% This iterative partitioning minimizes the sum, over all clusters, of the within-cluster sums of point-to-cluster-centroid distances. 
% Rows of X correspond to points, columns correspond to variables. 
% sp_kmeans returns an n-by-1 vector IDX containing the cluster indices of each point. 
%
% INPUTS:
% data_matrix : [NxP] N observations, P variables
% num_clusters: [int]
% [distance_type]: [string] 'sqEuclidean' (default), 'cityblock', etc (see kmeans documentation)
% [missing_data_handling]: [string] 'ignore_rows_with_too_many_missing_values' (default, arg5 specifies how many missing rows), 
%                                   'treat_as_value' (assign the value given in arg5 to all missing data)
% [arg5]:
%   For 'ignore_rows_with_too_many_missing_values':
%   [num_min_missing_rows_to_ignore]: [int] how many missing rows should we ignore. Default: 100
%
%   For 'treat_as_value'
%   [missing_observations_value]: [double]
%
% OUTPUTS:
% IDX : [N x 1] cluster indices for every observation
% C   : [num_clusters x P] matrix of cluster centroid locations
% sumd: [1 x num_clusters] the within-cluster sums of point-to-centroid distances
% sumd: [N x num_clusters] distances from each point to every centroid
% 
% Sagi Perel, 09/2011

    if(nargin < 2 || nargin > 5)
        error('sp_kmeans: wrong number of input arguments provided');
    end
    if(~exist('distance_type','var'))
        distance_type = 'sqEuclidean'; % 'sqEuclidean' 'cityblock'
    end
    if(~exist('missing_data_handling','var'))
        missing_data_handling = 'ignore_rows_with_too_many_missing_values'; % 'treat_as_zero' 'ignore_rows_with_too_many_missing_values'
        num_min_missing_rows_to_ignore = 100;
    else
        switch(missing_data_handling)
            case 'ignore_rows_with_too_many_missing_values'
                if(~exist('num_min_missing_rows_to_ignore','var'))
                    error('sp_kmeans: when using ignore_rows_with_too_many_missing_values, have to specify num_min_missing_rows_to_ignore');
                else
                    num_min_missing_rows_to_ignore = arg5;
                end
            case 'treat_as_value'
                if(~exist('arg5','var'))
                    missing_observations_value = 0;
                else
                    missing_observations_value = arg5;
                end
                
            otherwise
                error(['sp_kmeans: unknown value for missing_data_handling: [' missing_data_handling ']']);
        end
    end

    % determine how to deal with columns with missing rows
    switch(missing_data_handling)
        case 'treat_as_value'
            % (1) put a value of zero in every missing row
            data_matrix (isnan(data_matrix)) = missing_observations_value;
            [IDX,C,sumd,D] = kmeans(data_matrix,num_clusters,'distance',distance_type);

        case 'ignore_rows_with_too_many_missing_values'
            % (2) ignore all rows above a certain number of missing values
            num_nan_per_row = sum(isnan(data_matrix),1);
            rows_lidx_with_enough_values = ~(num_nan_per_row > num_min_missing_rows_to_ignore);
            data_matrix (isnan(data_matrix)) = 0;
            [IDX,C,sumd,D] = kmeans(data_matrix(:, rows_lidx_with_enough_values), num_clusters,'distance',distance_type);
    end
