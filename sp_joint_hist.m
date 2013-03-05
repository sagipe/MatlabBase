function [n edges_x edges_y] = sp_joint_hist(x, y, x_partition_type, Lx, y_partition_type, Ly)
% function [n edges_x edges_y] = sp_joint_hist(x, y, x_partition_type, Lx, y_partition_type, Ly)
%
% Divides the values in vectors x,y to Lx,Ly bins, where the number of elements
% in every bin depends on x/y_partition_type.
% Then computes the joint count matrix in the XY plane
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
% OUTPUT:
% n      : [matrix][Lx x Ly] with counts of joint occurances: x is rows, y in columns
% edges_x: [array][1xL+1] with the edges of the bins
% edges_y: [array][1xL+1] with the edges of the bins
%
% Sagi Perel, 09/2012, updated 10/2012

    if(nargin < 6 || nargin > 6)
        error('sp_joint_hist: wrong number of input arguments provided');
    end
    if(~isvector(x))
        error('sp_joint_hist: x must be a vector');
    end
    N = length(x);
    if(~isvector(y))
        error('sp_joint_hist: y must be a vector');
    elseif(length(y)~=N)
       error('sp_joint_hist: length(x)~=length(y)'); 
    end
    if(~exist('x_partition_type','var') || isempty(x_partition_type))
        x_partition_type = 'uniform';
    elseif(~ischar(x_partition_type))
        error('sp_joint_hist: x_partition_type must be a string');
    elseif(~any(strcmp(x_partition_type,{'uniform','equal_bins','unique'})))
        error('sp_joint_hist: unknown value for x_partition_type');
    end
    if(~strcmp(x_partition_type,'unique')) % x_partition_type,'unique' does not use Lx
        if(~isscalar(Lx))
            error('sp_joint_hist: Lx must be a scalar');
        elseif(Lx>N)
            error('sp_joint_hist: Lx > N');
        end
    end
    if(~exist('y_partition_type','var') || isempty(y_partition_type))
        y_partition_type = 'uniform';
    elseif(~ischar(y_partition_type))
        error('sp_joint_hist: y_partition_type must be a string');
    elseif(~any(strcmp(y_partition_type,{'uniform','equal_bins','unique'})))
        error('sp_joint_hist: unknown value for y_partition_type');
    end
    if(~strcmp(y_partition_type,'unique')) % y_partition_type,'unique' does not use Ly
        if(~isscalar(Ly))
            error('sp_joint_hist: Ly must be a scalar');
        elseif(Ly>N)
            error('sp_joint_hist: Ly > N');
        end
    end

    % partition sorted x into bins
    switch(x_partition_type)
        case 'uniform'
            edges_x = sp_uniform_hist(x, Lx);
        case 'equal_bins'
            edges_x = sp_equal_bins_hist(x, Lx);
        case 'unique'
            edges_x = sp_unique_hist(x);
            Lx = length(edges_x) - 1;
    end
    % partition sorted y into bins
    switch(y_partition_type)
        case 'uniform'
            edges_y = sp_uniform_hist(y, Ly);
        case 'equal_bins'
            edges_y = sp_equal_bins_hist(y, Ly);
        case 'unique'
            edges_y = sp_unique_hist(y);
            Ly = length(edges_y) - 1;
    end

    % sanity check
    if(length(edges_x) ~= Lx+1)
        error('sp_joint_hist: internal error: length(edges_x) ~= Lx+1');
    end
    if(length(edges_y) ~= Ly+1)
        error('sp_joint_hist: internal error: length(edges_y) ~= Ly+1');
    end
    
    % count occurences in joint bins and compute probabilities
    n=zeros(Lx, Ly);
    for i=1:Lx
        x_left_edge  = edges_x(i);
        x_right_edge = edges_x(i+1);
        % use [ ) notation for all bins, except for the last bin where [ ] is used
        if(i==Lx)
            lidx = (x >= x_left_edge & x <= x_right_edge);
        else
            lidx = (x >= x_left_edge & x < x_right_edge);
        end
        % count occurences in columns
        for j=1:Ly
            joint_counts = histc(y(lidx),edges_y);
            joint_counts(end-1) = joint_counts(end-1)+joint_counts(end);
            joint_counts(end)   = [];
            n(i,:) = joint_counts;
        end
    end
    
    % OLD CODE
%     switch(partition_type)
%         case 'uniform'
%             edges_x = sp_uniform_hist(x, Lx);
%             edges_y = sp_uniform_hist(y, Ly);
%             n=zeros(Lx, Ly);
%             for i=1:Lx
%                 x_left_edge  = edges_x(i);
%                 x_right_edge = edges_x(i+1);
%                 if(i==Lx)
%                     lidx = (x >= x_left_edge & x <= x_right_edge);
%                 else
%                     lidx = (x >= x_left_edge & x < x_right_edge);
%                 end                
%                 for j=1:Ly
%                     joint_counts = histc(y(lidx),edges_y);
%                     joint_counts(end-1) = joint_counts(end-1)+joint_counts(end);
%                     joint_counts(end)=[];
%                     n(i,:) = joint_counts;
%                 end
%             end
%             
%         case 'equal_bins'
%             min_x = min(x);
%             max_x = max(x);
% 
%             min_y = min(y);
%             max_y = max(y);
%             if(Lx == Ly)
%                 X=round((x-min_x)*(Lx-1)/(max_x-min_x+eps)); 
%                 Y=round((y-min_y)*(Lx-1)/(max_y-min_y+eps)); 
%                 n=zeros(Lx); 
%                 edges=0:Lx-1;
%                 for i=0:Lx-1 
%                     n(i+1,:) = histc(Y(X==i),edges);
%                 end
%                 edges_x = round( min_x : (max_x-min_x)/Lx : max_x );
%                 edges_y = round( min_y : (max_y-min_y)/Lx : max_y );
%             else
%                 error('sp_joint_hist: not yet implemented'); 
%             end
%         
%         case 'unique'
%             
%             
%         otherwise
%            error('sp_joint_hist: unknown value for partition_type'); 
%     end
    