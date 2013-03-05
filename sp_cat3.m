function M = sp_cat3(Matrix,dim)
% function M = sp_cat3(Matrix,dim)
%
% Concatenates the matrices at the 3rd dimension of Matrix in the first (Default) or second dimension
% so that if size(Matrix)==[4 3 2] then:
% size(sp_cat3(Matrix))==[8 3]
% size(sp_cat3(Matrix,2))==[4 6]
%                                          
%
% INPUTS:
% Matrix: [matrix] 3D matrix sized [N x M x K]
% [dim] : [int] 1 (Default) or 2
%
% OUTPUT:
% M : [matrix] 2D matrix sized [N*K x M]
%
% For example:
% x(:,:,1) = [1 2 3 4; 5 6 7 8];
% x(:,:,2) = [9 10 11 12; 13 14 15 16];
% >>x
% x(:,:,1) =
%      1     2     3     4
%      5     6     7     8
% x(:,:,2) =
%      9    10    11    12
%     13    14    15    16
% >>sp_cat3(x)
% ans =
%      1     2     3     4
%      5     6     7     8
%      9    10    11    12
%     13    14    15    16
%
% sp_cat3(x,2)
% ans =
%      1     2     3     4     9    10    11    12
%      5     6     7     8    13    14    15    16
%
% Sagi Perel, 08/2011

    if(nargin < 1 || nargin > 2)
        error('sp_cat3: wrong number of input arguments provided');
    end
    if(isempty(Matrix) || size(Matrix,3)==1)
        M = Matrix;
        return;
    end
    if(~exist('dim','var'))
        dim = 1;
    else
        if(~any(dim == [1 2]))
            error('sp_cat3: dim must be 1 or 2');
        end
    end
    
    switch(dim)
        case 1
            M = reshape( permute(Matrix, [1 3 2]), [size(Matrix,1)*size(Matrix,3) size(Matrix,2)]);
        case 2
            M = reshape(Matrix, [size(Matrix,1) size(Matrix,2)*size(Matrix,3)]);
    end