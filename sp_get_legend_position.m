function [position legend_handle] = sp_get_legend_position(num_rows, num_cols, subplot_idx, axis_handle)
% function [position legend_handle] = sp_get_legend_position(num_rows, num_cols, subplot_idx, axis_handle)
%
% Returns a 4 elements vector of the legend position
% If the figure has subplots, use the input variables to indicate where the required legend is
%
% INPUTS:
% [num_rows]   : [int] number of rows in the subplot
% [num_cols]   : [int] number of columns in the subplot
% [subplot_idx]: [int] the required subplot index
% [axis_handle]: [handle] Default: gca
%
% OUTPUTS:
% position: [array][1x4] with legend [left,bottom,width,height]
% legend_handle: [handle] which can be used with sp_set_legend_position()
% 
% Sagi Perel, 03/2012

    if((nargin > 1 && nargin < 3) || nargin > 4)
        error('sp_get_legend_position: wrong number of input arguments provided');
    end
    if(exist('axis_handle','var'))
        axes(axis_handle);
    end
    
    if(nargin >=3)
        % subplot exists
        subplot(num_rows, num_cols, subplot_idx);
    end
    
    legend_handle = legend;
    position = get(legend_handle,'Position');