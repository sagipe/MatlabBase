function sp_plot_line_with_confidence_bands(data, CB, patch_color, varargin)
% function sp_plot_line_with_confidence_bands(data, CB, color, varargin)
% 
% Draws a line with confidence bands around it (using a patch)
%
% INPUTS:
% data: [Nx1] with Y-data or [Nx2] with [X-data Y-data]
% CB  : [Nx1] for equal confidence bands around the line
%       [Nx2] with [upper lower] confidence bands around the line
% [patch_color]: [array][1x3] Default: [.8 .8 .8]
% [varargin]: [strings] to be passed to the plot() command
%
% Sagi Perel, 12/2012

    if(nargin < 2)
        error();
    end
    if(size(data,1) ~= size(CB,1))
        error('sp_plot_line_with_confidence_bands: size(data,1) ~= size(CB,1)');
    end
    if(~exist('patch_color','var') || isempty(patch_color))
        patch_color = [.8 .8 .8];
    elseif(~isvector(patch_color))
        error('sp_plot_line_with_confidence_bands: patch_color must be a vector');
    elseif(length(patch_color)~=3)
        error('sp_plot_line_with_confidence_bands: patch_color must be a vector with length 3');
    else
        patch_color = make_row_vector(patch_color);
    end
       
    switch(size(data,2))
        case 1
            xdata = make_column_vector(1:size(data,1));
            ydata = make_column_vector(data);
        case 2
            xdata = make_column_vector(data(:,1));
            ydata = make_column_vector(data(:,2));
        otherwise
            error();
    end
    switch(size(CB,2))
        case 1
            upper_CB = make_column_vector(CB);
            lower_CB = make_column_vector(CB);
        case 2
            upper_CB = CB(:,1);
            lower_CB = CB(:,2);
        otherwise
            error();
    end

    if(~ishold)
        cancel_hold = true;
        hold on;
    else
        cancel_hold = false;
    end
    
    plot(xdata,ydata,varargin{:});

    first_x = xdata(1);
    last_x  = xdata(end);
    first_upper_y = ydata(1) + upper_CB(1);
    first_lower_y = ydata(1) - lower_CB(1);
    last_upper_y  = ydata(end) + upper_CB(end);
    last_lower_y  = ydata(end) - lower_CB(end);

    X = [first_x;       first_x;       xdata;          last_x      ; last_x;       flipud(xdata)];
    Y = [first_lower_y; first_upper_y; ydata+upper_CB; last_upper_y; last_lower_y; flipud(ydata-lower_CB)];
    tcolor(1,1,1:3) = patch_color;
    % X and Y are m-by-n matrices, MATLAB draws n polygons with m vertices.
    h = patch(X,Y,tcolor);
    set(h,'EdgeColor','none');
    hAnnotation = get(h,'Annotation');
    hLegendEntry = get(hAnnotation','LegendInformation');
    set(hLegendEntry,'IconDisplayStyle','off');

    if(cancel_hold)
        hold off;
    end
    
    % put the patch in the back
    uistack(h,'bottom');