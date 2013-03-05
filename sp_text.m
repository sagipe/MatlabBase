function sp_text(x_perc, y_perc, string, varargin)
% function sp_text(x_perc, y_perc, string)
%
% A wrapper to text, which positions the text at x_perc,y_perc from the top-left corner
% of the axis so that: 
% x = xlims(1) + (xlims(2) - xlims(1)) * (x_perc))
% y = ylims(2) - (ylims(2) - ylims(1)) * (y_perc))
%
% Make sure to call this function AFTER the final xlim, ylim have been set
%
% Possible varargin could be:
% 'FontName','AvantGarde','FontSize',font_size
%
% Sagi Perel, 10/2011

    if(nargin < 3)
        error('sp_text: missing input arguments');
    end
    if(isempty(x_perc) || isempty(y_perc))
        error('sp_text: x_perc, y_perc cannot be empty');
    end
    if( (x_perc<0)||(x_perc>1) )
        error('sp_text: x_perc must be in the range [0 1]');
    end
    if( (y_perc<0)||(y_perc>1) )
        error('sp_text: y_perc must be in the range [0 1]');
    end

    xlims = xlim();
    ylims = ylim();
    x = xlims(1) + ( (xlims(2) - xlims(1)) * (x_perc) );
    y = ylims(2) - ( (ylims(2) - ylims(1)) * (y_perc) );
    text(x,y,string,varargin{:});
