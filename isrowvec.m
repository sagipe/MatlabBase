function is_row_vec = isrowvec(vec)
% function is_row_vec = isrowvec(vec)
%
% Returns true if the given matrix is a row vector, false otherwise
%
% INPUTS:
% vec: [matrix]
% 
% OUTPUTS:
% is_row_vec: [bool] 0/1
% 
% Sagi Perel, 05/2009

    if(nargin ~= 1)
        error('isrowvec: wrong number of input arguments given');
    end

    is_row_vec = 0;
    
    if(isvector(vec))
        [M N] = size(vec);
        if( M == 1 && N >=1)
            is_row_vec = 1;
        end
    end