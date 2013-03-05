function [sIDX num_observations_per_cluster classes] = sp_reorder_by_idx(IDX)
% function [sIDX num_observations_per_cluster classes] = sp_reorder_by_idx(IDX)
%
% For example:
% [sIDX num_observations_per_cluster] = sp_reorder_by_idx([1 1 3 4 2 4 5])
% sIDX =
%      1     2     5     3     4     6     7
% num_observations_per_cluster =
%      2     1     1     2     1
% 
% INPUT:
% IDX: [Nx1] array of integer values representing a class label for N observations
% 
% OUTPUT:
% sIDX: [Nx1] array of indices for the N obervations, so they are clustered by classes
% num_observations_per_cluster: [num_clusters x 1] with the number of observations per cluster
% classes : [num_classes x 1]
%
% Sagi Perel, 10/2011

    if(nargin ~= 1)
        error('sp_reorder_by_idx: wrong number of input arguments provided');
    end
    if(~isvector(IDX))
        error('sp_reorder_by_idx: IDX must be a vector');
    else
        IDX = make_column_vector(IDX);
    end
    
    classes = unique(IDX);
    num_classes = length(classes);
    
    sIDX = nan(size(IDX));
    num_observations_per_cluster = zeros(num_classes,1);
    
    i = 1;
    for c=1:num_classes
        this_class_idxs = find( IDX == classes(c));
        
        num_observations_per_cluster(c) = length(this_class_idxs);
        
        if(~isempty(this_class_idxs))
            sIDX(i : i + length(this_class_idxs) - 1) = this_class_idxs;
            i = i + length(this_class_idxs);
        end
    end