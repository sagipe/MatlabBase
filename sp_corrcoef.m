function [R P] = sp_corrcoef(varargin)
% function [R P] = sp_corrcoef(varargin)
%
% A wrapper to R = corrcoef(...) , which returns:
%
% sp_corrcoef(x)   : where x is a vector: returns auto-correlation
% sp_corrcoef(x)   : where x is a matrix: returns the full correlation matrix between all columns
% sp_corrcoef(x,y) : where x,y are two vectors: the correlation value between two vectors
% sp_corrcoef(x,y) : where one is a vector and one is a matrix: the correlation value between the vector and all columns of the matrix
%
% You can supply any string pair-value to this function you would do for corrcoef()
% Also ignores NaNs in the inputs.
%
% OUTPUTS:
% R : [double][number/array] Correlation value
% P : [double][number/array] Correlation p-value
%
% Sagi Perel, 02/2012

    switch(nargin)
        case 0
            % no inputs:
            error('sp_corrcoef: this function takes at least one input argument');
        case 1
            % one input: do the same as corrcoef
            [R P] = corrcoef(varargin{:},'rows','complete');
        case 2
            % two inputs:
            % check what combination of two inputs we have
            if(isvector(varargin{1}) && isvector(varargin{2}))
                [R P] = corrcoef(varargin{:},'rows','complete');
                R = R(1,2);
                P = P(1,2);
            elseif( isvector(varargin{1}) && ismatrix(varargin{2}) )
                [R P] = corrcoef([make_column_vector(varargin{1}) varargin{2}],'rows','complete');
                R = R(2:end,1);
                P = P(2:end,1);
            elseif( ismatrix(varargin{1}) && isvector(varargin{2}) )
                [R P] = corrcoef([make_column_vector(varargin{2}) varargin{1}],'rows','complete');
                R = R(2:end,1);
                P = P(2:end,1);
            else
                error('sp_corrcoef: unknown combination of input types');
            end
        otherwise
            % more than two inputs:
            % check if the second one is a part of a string pair-value
            if(ischar(varargin{2}))
                % there is one value input, since the second one is a string
                [R P] = corrcoef(varargin{:},'rows','complete');
            else
                % there are two value inputs, the rest are options
                % check what combination of two inputs we have
                if(isvector(varargin{1}) && isvector(varargin{2}))
                    [R P] = corrcoef(varargin{:},'rows','complete');
                    R = R(1,2);
                    P = P(1,2);
                elseif( isvector(varargin{1}) && ismatrix(varargin{2}) )
                    [R P] = corrcoef([make_column_vector(varargin{1}) varargin{2}],'rows','complete',varargin{3:end});
                    R = R(2:end,1);
                    P = P(2:end,1);
                elseif( ismatrix(varargin{1}) && isvector(varargin{2}) )
                    [R P] = corrcoef([make_column_vector(varargin{2}) varargin{1}],'rows','complete',varargin{3:end});
                    R = R(2:end,1);
                    P = P(2:end,1);
                else
                    error('sp_corrcoef: unknown combination of input types');
                end
            end
    end
    