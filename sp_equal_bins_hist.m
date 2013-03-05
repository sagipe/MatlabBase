function [edges n] = sp_equal_bins_hist(x, L)
% function [edges n] = sp_equal_bins_hist(x, L)
%
% Divides the values in vector x to L bins of equal size
%
% INPUTS:
% x: [array] of length N
% L: [int] number of bins, L <= N
%
% OUTPUT:
% edges: [array][1xL+1] with the edges of the bins
% n    : [array][1xL] with number of elements in every bin
%
% Sagi Perel, 10/2012

    if(nargin ~= 2)
        error('sp_uniform_hist: wrong number of input arguments provided');
    end
    if(~isvector(x))
        error('sp_uniform_hist: x must be a vector');
    end
    N = length(x);
    if(~isscalar(L))
        error('sp_uniform_hist: L must be a scalar');
    elseif(L>N)
        error('sp_uniform_hist: L > N');
    end
    
    % get the edges:
    min_x = min(x);
    max_x = max(x);
    edges = min_x : (max_x - min_x)/L : max_x; % length == L+1, min/max in the edges
    % histc works by:
    % n(k) counts the value x(i) if edges(k) <= x(i) < edges(k+1)
    n = histc(x, edges); % length L+1
    % The last bin in n counts any values of x that match edges(end), so add it to the bin before it
    n(end-1) = n(end-1) + n(end); 
    n(end) = []; % length L+1 => length L
    