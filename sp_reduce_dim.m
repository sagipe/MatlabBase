function [basis projected_data stats nan_lidx] = sp_reduce_dim(data, method, resize_output)
% function [basis projected_data stats nan_lidx] = sp_reduce_dim(data, method, resize_output)
%
% Performs dimensionality reduction using the given method on the given data
%
% INPUTS:
% data  : [matrix][NxP] with observations in rows, variables in columns OR
%         [cell] with i matrices, each sized [NixP] with the above format
% [method]: [string] 'PCA' (Default) (centers data before performing PCA), 'ICA', 'FA'
% [resize_output]: [bool] Default: false. Should projected_data have the same number of samples as the input. 
%                  If true and data includes NaN values, then projected_data will have NaN values for the same samples
%
% OUTPUTS:
% basis         : [matrix][PxP] with basis vectors in columns
% projected_data: [matrix][NxP] with the data projected to the computed basis
% stats         : [struct] with additional information per method:
%                 'PCA': latent  (a vector containing the eigenvalues of the covariance matrix of data)
%                        tsquare (Hotelling's T2 statistic for each data point)
% nan_lidx      : [bool][Nx1] with true for rows that have been removed because they contain NaN values
%
% Sagi Perel, 05/2011

    if(nargin < 1 || nargin > 3)
        error('sp_reduce_dim: wrong number of input arguments provided');
    end
    if(isa(data,'cell'))
        data_was_cell = true;
        % make sure the same number of variables exists in every cell
        all_sizes = sp_cellfun(@size, data);
        all_sizes = vertcat(all_sizes{:}); % [i x 2] matrix with size per cell
        % ignore empty cells, make sure all others have the same number of columns
        Ps = unique(all_sizes(:,2));
        Ps(Ps == 0) = [];
        if(isempty(Ps))
            error('sp_reduce_dim: data is a cell array with empty cells');
        end
        if(length(Ps)>1)
            error(['sp_reduce_dim: not all cells in data have the same number of variables: [' num2str(Ps) ']']);
        end
        % keep a record of which rows were nan in every cell
        isnanrow_fun = @(x) any(isnan(x),2);
        is_nan_row_in_cell = sp_cellfun(isnanrow_fun, data);
        % keep a record of how many rows have nans in every cell
        num_nan_rows_in_cell = make_column_vector(cellfun(@sum, is_nan_row_in_cell));
        % transform the data into a matrix
        data = vertcat(data{:});
        % get the nan row indices for the matrix
        nan_lidx = vertcat(is_nan_row_in_cell{:});
    else
        data_was_cell = false;
        if(isempty(data))
            error('sp_reduce_dim: data is an empty matrix');
        end
        if(size(data,2)==1)
            error('sp_reduce_dim: data has a single column')
        end
        nan_lidx = any(isnan(data),2);
    end
    if(~exist('method','var'))
        method = 'PCA';
    end
    if(~exist('resize_output','var'))
        resize_output = false;
    end
    
    [N P] = size(data);
    % get rid of rows with NaN rows
    data(nan_lidx,:) = [];
    if(isempty(data))
        error('sp_reduce_dim: all rows in data contain NaN values');
    end
    
    switch(method)
        case 'PCA'
            [basis, scores, latent, tsquare] = princomp(data);
            stats.latent  = latent;
            stats.tsquare = tsquare;
            stats.variance_explained = 100*cumsum(latent)./sum(latent);
            if(resize_output)
                projected_data = nan(N,P);
                projected_data(~nan_lidx,:) = scores;
            else
                projected_data = scores;
            end
            
        case {'ICA','FA'}
            error('sp_reduce_dim: not yet implemented');            
        otherwise
            error(['sp_reduce_dim: unknown method ' method]);
    end

    if(data_was_cell)
        if(resize_output)
            % repartition the data
            projected_data = mat2cell(projected_data, all_sizes(:,1), Ps);
            % return the nan_lidx for the cell array
            nan_lidx = is_nan_row_in_cell;
        else
            % make sure to repartition the data considering the NaN rows that were removed
            all_sizes(:,1) = all_sizes(:,1) - num_nan_rows_in_cell; % reduce the number of samples per cell by the number of NaN values we had in every cell
            projected_data = mat2cell(projected_data, all_sizes(:,1), Ps);
            % return the nan_lidx for the cell array
            nan_lidx = is_nan_row_in_cell;
        end
    end