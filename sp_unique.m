function [unique_vals unique_vals_counts unique_vals_idx] = sp_unique(vec)
% function [unique_vals unique_vals_counts unique_vals_idx] = sp_unique(vec)
%
% Returns the unique elements of vector A along with the indices matching every unique value
% Also ignores NaN values
%
% INPUTS:
% vec: [double array] OR [cell array of strings]
%
% OUTPUTS:
% unique_vals       : [double array] with the same orientation as vec
% unique_vals_counts: [double array] with the same orientation as vec, includes counts of how many elements are present for every unique value
% unique_vals_idx   : [cell array] with the indices
%
% Sagi Perel, 04/2009
% Updated 03/04/13 to include cell arrays of strings

    %--- sanity check on inputs
    if(~exist('vec','var'))
        error('sp_unique: missing input variable vec');
    end
    if(~isvector(vec))
        error('sp_unique: can only operate on vectors');
    end
    
    %--- get the unique values of vec
    if(iscell(vec))
        unique_vals = unique(vec); % will fail if vec is not a cell array of strings
        num_unique_vals = length(unique_vals);
        
        unique_vals_idx = cell(1,num_unique_vals);
        unique_vals_counts = zeros(size(unique_vals));

        for i=1:num_unique_vals
            unique_vals_idx{i} = find( cellfun(@(x)(strcmp(unique_vals{i},x)),vec) );
            unique_vals_counts(i) = length(unique_vals_idx{i});
        end
    else
        % double array: ignore NaN values
        unique_vals = unique(vec(~isnan(vec)));
        num_unique_vals = length(unique_vals);

        unique_vals_idx = cell(1,num_unique_vals);
        unique_vals_counts = zeros(size(unique_vals));

        for i=1:num_unique_vals
            unique_vals_idx{i} = find(vec == unique_vals(i));
            unique_vals_counts(i) = length(unique_vals_idx{i});
        end
    end
    