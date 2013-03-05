function [unique_rows unique_rows_lidx unique_rows_counts] = sp_unique_matrix(matrix)
% function [unique_rows unique_rows_lidx unique_rows_counts] = sp_unique_matrix(matrix)
%
% Returns the unique row vectors of matrix A, with the indices matching every unique row
% Also ignores NaN values.
%
% Example:
% [unique_rows unique_rows_lidx unique_rows_counts] = sp_unique_matrix([1 1; 2 2; 1 1; NaN NaN; 3 3])
% 
% unique_rows =
%      1     1
%      2     2
%      3     3
% 
% 
% unique_rows_lidx =
%      1     0     0
%      0     1     0
%      1     0     0
%      0     0     0
%      0     0     1
% 
% 
% unique_rows_counts =
%      2     1     1
% 
% INPUTS:
% matrix: [matrix][NxM] 2D numeric matrix
%
% OUTPUTS:
% unique_rows       : [matrix][UxM] with unique U values in rows
% unique_rows_lidx  : [matrix][NxU] with logical indices for U unique values in columns
% unique_rows_counts: [double array][1xU] with counts of how many elements are present for every unique value
%
%
% Sagi Perel, 09/2012

    %--- sanity check on inputs
    if(nargin ~= 1)
        error('sp_unique_matrix: wrong number of input arguments provided');
    end
    if(~ismatrix(matrix) || (ismatrix(matrix) && iscell(matrix)) || (ismatrix(matrix) && ndims(matrix)~=2))
        error('sp_unique_matrix: matrix must be a 2D numeric matrix');
    else
        [N M] = size(matrix);
    end
    
    %--- get the unique row vectors of matrix
    unique_rows = unique(matrix,'rows');
    % ignore NaNs
    unique_rows( all(isnan(unique_rows),2), :) = [];
    
    %--- get logical indices if required
    if(nargout > 1)
        num_unique_rows  = size(unique_rows,1);
        
        unique_rows_lidx = false(N,num_unique_rows);
        for i=1:num_unique_rows
            unique_rows_lidx(:,i) = all(bsxfun(@eq, unique_rows(i,:), matrix), 2);
        end
        
        if(nargout > 2)
            unique_rows_counts = sum(unique_rows_lidx);
        end
    end
    