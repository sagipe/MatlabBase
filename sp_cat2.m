function M = sp_cat2(Matrix)
% function M = sp_cat2(Matrix)
%
% Concatenates the matrices at the 2nd dimension of Matrix in the first dimension
% This is done column-wise.
% so that if size(Matrix)==[4 3] then size(sp_cat2(Matrix))==[12 1]
%
% INPUTS:
% Matrix: [matrix] 2D matrix sized [N x M]
%
% OUTPUT:
% M : [matrix] 2D matrix sized [N*M 1]
%
% Sagi Perel, 09/2011

    if(nargin ~= 1)
        error('sp_cat2: wrong number of input arguments provided');
    end
    if(isempty(Matrix) || size(Matrix,2)==1)
        M = Matrix;
        return;
    end
    
    M = Matrix(:);