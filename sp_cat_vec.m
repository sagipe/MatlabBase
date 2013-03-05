function cat_vector = sp_cat_vec(varargin)
% function cat_vector = sp_cat_vec(varargin)
%
% Performs vertcat / horzcat for all given vectors and returns a column vector
%
% INPUTS:
% varargin: [cell array] of vectors in any orientation
%
% OUTPUTS:
% cat_vector: [array]
%
% Sagi Perel, 02/2013

    if(nargin == 0)
        cat_vector = [];
        return;
    end
    cat_vector_cell = sp_cellfun(@make_column_vector, varargin);
    cat_vector = vertcat( cat_vector_cell{:} );
    