function [I pxy px py edges_x edges_y nxy nx ny] = compute_mutual_information(x, y, x_partition_type, Lx, y_partition_type, Ly)
% function [I pxy px py edges_x edges_y nxy nx ny] = compute_mutual_information(x, y, x_partition_type, Lx, y_partition_type, Ly)
% 
% Computes the mutual information between time series x and time series y
% using a uniform partition of the x-y plane to Lx*Ly bins.
% The bins are of unequal sizes, so that the number of elements in every bin is roughly
% equal (equal entropy).
%
% INPUTS:
% x : [array] of length N
% y : [array] of length N
% x_partition_type: [string]   'uniform'    : uniform marginal distibutions by using varying bin widths
%                              'equal_bins' : divide x to Lx bins of equal widths
%                              'unique'     : count unique values (doesn't use Lx)
% Lx: [int] number of bins, Lx <= N
% y_partition_type: [string]   'uniform'    : uniform marginal distibutions by using varying bin widths
%                              'equal_bins' : divide y to Ly bins of equal widths
%                              'unique'     : count unique values (doesn't use Ly)
% Ly: [int] number of bins, Ly <= N
%
% OUTPUTS:
% I  : [double] mutual information: I(X,Y) = sum_over_x( sum_over_y ( p(x,y)* log2( p(x,y)/ (p(x)*p(y)) ) ) )
% pxy:  
% px :
% py :
% edges_x:
% edges_y:
% 
% Sagi Perel, 09/2012

    if(nargin < 6 || nargin > 6)
        error('compute_mutual_information: wrong number if input arguments provided');
    end
    if(~isvector(x))
        error('compute_mutual_information: x must be a vector');
    end
    N = length(x);
    if(~isvector(y))
        error('compute_mutual_information: y must be a vector');
    elseif(length(y)~=N)
       error('compute_mutual_information: length(x)~=length(y)'); 
    end
    if(~exist('x_partition_type','var') || isempty(x_partition_type))
        x_partition_type = 'uniform';
    elseif(~ischar(x_partition_type))
        error('compute_mutual_information: x_partition_type must be a string');
    elseif(~any(strcmp(x_partition_type,{'uniform','equal_bins','unique'})))
        error('compute_mutual_information: unknown value for x_partition_type');
    end
    if(~strcmp(x_partition_type,'unique')) % x_partition_type,'unique' does not use Lx
        if(~isscalar(Lx))
            error('compute_mutual_information: Lx must be a scalar');
        elseif(Lx>N)
            error('compute_mutual_information: Lx > N');
        end
    end
    if(~exist('y_partition_type','var') || isempty(y_partition_type))
        y_partition_type = 'uniform';
    elseif(~ischar(y_partition_type))
        error('compute_mutual_information: y_partition_type must be a string');
    elseif(~any(strcmp(y_partition_type,{'uniform','equal_bins','unique'})))
        error('compute_mutual_information: unknown value for y_partition_type');
    end
    if(~strcmp(y_partition_type,'unique')) % y_partition_type,'unique' does not use Ly
        if(~isscalar(Ly))
            error('compute_mutual_information: Ly must be a scalar');
        elseif(Ly>N)
            error('compute_mutual_information: Ly > N');
        end
    end
    
    if(all(isnan(x)) || all(isnan(y)))
        I = NaN;
        pxy = [];
        px  = [];
        py  = [];
        edges_x = [];
        edges_y = [];
        return;
    end
    
    % the marginal distributions p(x), p(y) are approximated by histograms
    % which divide [min(x) max(x)] and [min(y) max(y)] according to x/y_partition_type
    switch(x_partition_type)
        case 'uniform'
            [edges_x nx] = sp_uniform_hist(x, Lx);
        case 'equal_bins'
            [edges_x nx] = sp_equal_bins_hist(x, Lx);
        case 'unique'
            [edges_x nx] = sp_unique_hist(x);
        otherwise
            error('compute_mutual_information: unknown value for x_partition_type');
    end
    switch(y_partition_type)
        case 'uniform'
            [edges_y ny] = sp_uniform_hist(y, Ly);
        case 'equal_bins'
            [edges_y ny] = sp_equal_bins_hist(y, Ly);
        case 'unique'
            [edges_y ny] = sp_unique_hist(y);
        otherwise
            error('compute_mutual_information: unknown value for y_partition_type');
    end
    
    px = nx/sum(nx);
    py = ny/sum(ny);
    
    % estimate the joint probability p(x,y)
    [nxy edges_x edges_y] = sp_joint_hist(x, y, x_partition_type, Lx, y_partition_type, Ly);
    pxy = nxy./sum(nxy(:)); % [Lx x Ly]
    
    % compute the mutual information:
    % I(X,Y) = sum_over_x( sum_over_y ( p(x,y)* log2( p(x,y)/ (p(x)*p(y)) ) ) )
    px_py = make_column_vector(px)*make_row_vector(py); % [Lx x Ly]
    % don't include zero values
    lidx = px_py(:)>0 & pxy(:)>0; % logical vector with length [Lx * Ly]
    % compute the sum over all x
    I = sum( pxy(lidx) .* ( log2(pxy(lidx)) - log2(px_py(lidx)) ) );
    