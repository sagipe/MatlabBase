function matcell = sp_mat2cell(mat, dim)
% function matcell = sp_mat2cell(mat, dim)
%
% A simplification of mat2cell, which converts [NxM] matrix mat into a cell array matcell.
% 
% If dim==1 / dim=='rows' then matcell is a [Nx1] cell array with M elements in every cell:
% so that every row becomes a cell
% 
% If dim==2 / dim=='cols' then matcell is a [1xM] cell array with N elements in every cell:
% so that every column becomes a cell
%
% INPUTS:
% mat : [matrix][NxM]
% dim : [int] 1,2 OR [string] 'rows','cols'
%
% OUTPUTS:
% matcell: [cell array]
%
% Sagi Perel, 03/2012

    if(nargin < 2 || nargin > 2)
       error('sp_mat2cell: wrong number of input arguments provided');
    end
    if(~ismatrix(mat))
        error('sp_mat2cell: mat must be a matrix');
    end
    [N M] = size(mat);
    switch(dim)
        case {1,'rows'}
            matcell = mat2cell(mat, ones(N,1), M);
        case {2,'cols'}
            matcell = mat2cell(mat, N, ones(M,1));
        otherwise
            error(['sp_mat2cell: unknown value for dim=[' dim ']']);
    end

    
    
    