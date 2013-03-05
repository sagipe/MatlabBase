function [edges n] = sp_unique_hist(x)
% function [edges n] = sp_unique_hist(x)
%
% Divides the values in vector x to L+1 bins, where L is the number of unique elements in x.
% The last bin is artifically added to conform with sp_uniform_hist()
% This function ignores NaN values.
%
% INPUTS:
% x: [array] of length N
%
% OUTPUT:
% edges: [array][1xL+1] with the edges of the bins
% n    : [array][1xL] with number of elements in every bin
%
% Sagi Perel, 10/2012

    if(nargin ~= 1)
        error('sp_unique_hist: wrong number of input arguments provided');
    end
    if(~isvector(x))
        error('sp_unique_hist: x must be a vector');
    end
    [edges n] = sp_unique(x);
    % at an artificial last element to conform with sp_uniform_hist()
    edges(end+1) = edges(end)+eps;
    

    