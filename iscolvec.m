function is_col_vec = iscolvec(vec)
% function is_col_vec = iscolvec(vec)
%
% Returns true if the given matrix is a column vector, false otherwise
%
% INPUTS:
% vec: [matrix]
% 
% OUTPUTS:
% is_col_vec: [bool] 0/1
% 
% Sagi Perel, 05/2009

    if(nargin ~= 1)
        error('iscolvec: wrong number of input arguments given');
    end

    is_col_vec = 0;
    
    if(isvector(vec))
        [M N] = size(vec);
        if(M >= 1 && N == 1)
            is_col_vec = 1;
        end
    end