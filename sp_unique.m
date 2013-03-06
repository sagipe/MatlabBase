function [unique_vals unique_vals_counts unique_vals_idx] = sp_unique(data)
% function [unique_vals unique_vals_counts unique_vals_idx] = sp_unique(data)
%
% A wrapper to unique, which returns more useful information:
%
% If data is a vector: unique_vals has the unique elements of the vector, while ignoring NaN values
% If data is a matrix: unique_vals has the unique rows of the matrix, similar to unique(data,'rows'); treating NaNs as unique values
% If data is a cell array of strings: unique_vals has the unique strings in the cell array
%
% unique_vals_counts includes counts of how many elements are present for every unique value
% unique_vals_idx includes indices of elements belonging to every unique value
%
% INPUTS:
% data: [double array] OR [matrix] OR [cell array of strings]
%
% OUTPUTS:
% unique_vals       : [double array] with the same orientation as vec
% unique_vals_counts: [double array] with the same orientation as vec, includes counts of how many elements are present for every unique value
% unique_vals_idx   : [cell array] with the indices
%
% Sagi Perel, 04/2009
% Updated 03/04/13 to handle cell arrays of strings
% Updated 03/06/13 to handle matrices

    %--- sanity check on inputs
    if(~exist('data','var'))
        error('sp_unique: missing input variable data');
    end
    if(~isvector(data) && ~iscell(data) && ~sp_ismatrix(data))
        error('sp_unique: data must be a vector, matrix or cell array of strings');
    end
    
    %--- get the unique values of vec based on the type
    if(iscell(data))
        % cell array of strings
        if(~all(cellfun(@ischar,data)))
            error('sp_unique: cell array data must contain only strings');
        end
        unique_vals = unique(data); % will fail if vec is not a cell array of strings
        num_unique_vals = length(unique_vals);
        
        unique_vals_idx = cell(1,num_unique_vals);
        unique_vals_counts = zeros(1,num_unique_vals);

        for i=1:num_unique_vals
            unique_vals_idx{i} = find( cellfun(@(x)(strcmp(unique_vals{i},x)),data) );
            unique_vals_counts(i) = length(unique_vals_idx{i});
        end
    elseif(sp_ismatrix(data))
        % double matrix: [NxM]
        % don't ignore rows with NaN values: treat NaN as a unique value
        % nan_rows_lidx = any(isnan(data),2);
        % [unique_vals, ~, unique_row_number] = unique(data(~nan_rows_lidx,:),'rows'); % unique_vals is [num_unique_rows x M]
        
        [unique_vals, ~, unique_row_number] = unique(data,'rows'); % unique_vals is [num_unique_rows x M]
        % unique_row_number indicates for every row in data
        num_unique_vals = size(unique_vals,1);
        
        unique_vals_idx = cell(1,num_unique_vals);
        unique_vals_counts = zeros(1,num_unique_vals);
        
        for i=1:num_unique_vals
            unique_vals_idx{i}    = find( unique_row_number == i );
            unique_vals_counts(i) = length(unique_vals_idx{i});
        end
    else
        % double array: ignore NaN values
        unique_vals = unique(data(~isnan(data)));
        num_unique_vals = length(unique_vals);

        unique_vals_idx = cell(1,num_unique_vals);
        unique_vals_counts = zeros(1,num_unique_vals);

        for i=1:num_unique_vals
            unique_vals_idx{i} = find(data == unique_vals(i));
            unique_vals_counts(i) = length(unique_vals_idx{i});
        end
    end
    