function h = sp_qqnorm(x)
% function h = sp_qqnorm(x)
%
% Makes an empirical QQ-plot of the quantiles of the data in
% the vector X versus the quantiles of a standard Normal distribution.
%
% Sagi Perel, 08/2010

    if(nargin ~= 1)
        error('sp_qqnorm: wrong number of input arguments provided');
    end
    if(~isvector(x))
        error('sp_qqnorm: x must be a vector');
    end
    
    if size(x,1)==1
        x = x';
    end
    
    mu = mean(x);
    sigma = std(x);
    
    [y,origindy]  =  sort(x);
    x = plotpos(y);

    x = norminv(x);
    xx = x;
    yy = y;
    xlab = 'Standard Normal Quantiles';
    ylab = 'Quantiles of Input Sample';
    tlab = 'QQ Plot of Sample Data versus Standard Normal';
    
    eq_line = mu + sigma .*xx;
    
    newplot();
    hdat = line(xx,yy,'LineStyle','none','Marker','+');
    set(hdat,'MarkerEdgeColor','b');
    
    heq = line(xx,eq_line,'Color','r');    
    if nargout>0
        h = [hdat;heq];
    end
    
    % Set custom data cursor on data
    hB = hggetbehavior(hdat(1),'datacursor');
    set(hB,'UpdateFcn',@qqplotDatatipCallback);
    if ~isempty(origindy)
        setappdata(hdat(1),'origindy',origindy(:,1));
    end

    xlabel(xlab);
    ylabel(ylab);
    title (tlab);
    
    make_plot_nicer();    
    
%===================== helper function ====================
function pp = plotpos(sx)
%PLOTPOS Compute plotting positions for a probability plot
%   PP = PLOTPOS(SX) compute the plotting positions for a probability
%   plot of the columns of SX (or for SX itself if it is a vector).
%   SX must be sorted before being passed into PLOTPOS.  The ith
%   value of SX has plotting position (i-0.5)/n, where n is
%   the number of rows of SX.  NaN values are removed before
%   computing the plotting positions.

[n, m] = size(sx);
if n == 1
   sx = sx';
   n = m;
   m = 1;
end

nvec = sum(~isnan(sx));
pp = repmat((1:n)', 1, m);
pp = (pp-.5) ./ repmat(nvec, n, 1);
pp(isnan(sx)) = NaN;