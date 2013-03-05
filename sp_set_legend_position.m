function sp_set_legend_position(handle, x_pos, y_pos, width, height)
% function sp_set_legend_position(handle, x_pos, y_pos, width, height)
% 
% Sets the legend position to the required position in the figure.
% 
% INPUTS:
% handle: [handle] to the legend
% x_pos : [string] controlling the horizontal (left-right) placement in the figure:
%                  'Left','Center','Right'
%         OR [double] where a value is specified:
%            0 Left | 0.5 Center | 0.9 Right
% y_pos : [string] controlling the vertical (bottom-top) placement in the figure:
%                  'Bottom','Center','Top'
%         OR [double] where a value is specified:
%            0 Bottom | 0.5 Center | 0.9 Top
% [width] : [double]
% [height]: [double]
%
% Sagi Perel, 03/2012

    if(nargin < 3 || nargin > 5)
        error('sp_set_legend_position: wrong number of input arguments provided');
    end
    if(~ishandle(handle))
        error('sp_set_legend_position: handle is not a valid graphics handle');
    end
    if(xor(ischar(x_pos),ischar(y_pos)))
        error('sp_set_legend_position: both x_pos and y_pos must be of the same type');
    end
    if(~exist('width','var'))
        width = [];
    end
    if(~exist('height','var'))
        height = [];
    end    
    
    switch(x_pos)
        case 'Left'
            numeric_x_pos = 0;
        case 'Center'
            numeric_x_pos = 0.5;
        case 'Right'
            numeric_x_pos = 0.9;
        otherwise
            if(isscalar(x_pos))
                numeric_x_pos = x_pos;
            else
                error('sp_set_legend_position: unknown value for x_pos');
            end
    end
    
    switch(y_pos)
        case 'Bottom'
            numeric_y_pos = 0;
        case 'Center'
            numeric_y_pos = 0.5;
        case 'Top'
            numeric_y_pos = 0.9;
        otherwise
            if(isscalar(y_pos))
                numeric_y_pos = y_pos;
            else
                error('sp_set_legend_position: unknown value for y_pos');
            end
    end
    p = get(handle, 'Position'); % [left,bottom,width,height]
    p(1) = numeric_x_pos;
    p(2) = numeric_y_pos;
    if(~isempty(width))
        p(3) = width;
    end
    if(~isempty(height))
        p(4) = height;
    end
    set(handle,'Position',p);
    