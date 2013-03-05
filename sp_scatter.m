function sp_scatter(X,Y, color)
% function sp_scatter(X,Y, color)
% 
% Plots a scatter of X vs Y with lines separating the quadrants
%
% INPUTS:
% X : [array]
% Y : [array]
% [color]: [string] color for the points. Default: 'b'
%
% Sagi Perel, 04/2011

    if(nargin < 2 || nargin > 3)
        error('sp_scatter: wrong number of input arguments provided');
    end
    if(~isvector(X))
        error('sp_scatter: X must be a non-empty vector');
    end
    if(~isvector(Y))
        error('sp_scatter: Y must be a non-empty vector');
    end
    if(~exist('color','var'))
        color = 'b';
    end
    
    X = make_column_vector(X);
    Y = make_column_vector(Y);
    
    min_X = nanmin(X);
    max_X = nanmax(X);
    
    min_Y = nanmin(Y);
    max_Y = nanmax(Y);
    
    plot(X,Y,[color '.']);
    hold on;
    line([0 0],[min_Y max_Y],'Color','k');
    line([min_X max_X],[0 0],'Color','k');
    hold off;
    
    make_plot_nicer();
    
    % count how many points we have in every quadrant
    quadrant_sizes = nan(1,4);
    quadrant_sizes(1) = sum(X<0 & Y>0);
    quadrant_sizes(2) = sum(X>0 & Y>0);
    quadrant_sizes(3) = sum(X<0 & Y<0);
    quadrant_sizes(4) = sum(X>0 & Y<0);
    title(['Quadrants #samples=[' num2str(quadrant_sizes) ']']);