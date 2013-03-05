function [font_name font_size line_width] = make_plot_nicer(eliminate_xticks, eliminate_yticks,font_size,varargin)
% [font_name font_size line_width] = make_plot_nicer(eliminate_xticks, eliminate_yticks,font_size,varargin)
%
% Should be called from every plotting function.
% Does the following things to make the Matlab plot look sane:
% 1) Sets tick marks direction to out
% 2) Sets a default font name to AvantGarde and font size to 12
% 3) Sets the default font and size for xlabel, ylabel, zlabel
% 4) Eliminates the box around the axis (box off)
% 5) Makes the axis square
% 6) Sets the lengend box to (legend boxoff)
%
% INPUTS:
% [eliminate_xticks] : [bool] should X axis tick marks be eliminated (default: 0)
% [eliminate_yticks] : [bool] should Y axis tick marks be eliminated (default: 0)
% [font_size]        : [double] (default: 12)
% [varargin]         : [string] other options: 
%                      'axis_OPTION' where OPTION can be:
%                                    'square' Make the axis square (Default)
%                                    'none'   Leave the axis as is
%                                    'keep'   If both X and Y tick marks are eliminated- leave the axis (Default is eliminate axis as well)
%                      'axis_x_reverse' Flips the x-axis direction to mirror the image
%                      'axis_y_reverse' Flips the y-axis direction 
%                      'axis_x_rotate_label' Rotates the labels by 90 deg. See xticklabel_rotate()
%                      'axis_x_top' Puts the x-axis on the top of the figure
%                      'axis_IJ'  Puts MATLAB into its "matrix" axes mode.  The coordinate system origin is at the upper left corner.  
%                                 The i axis is vertical and is numbered from top to bottom.  
%                                 The j axis is horizontal and is numbered from left to right.
%                      '
%                      'axislinewidth_NUM' where NUM is a number for the axis line width (Default: 1 point (1/72 inch), the Matlab default is 0.5 point)
%                      'font_FONTNAME' Sets the font to the given one. AvantGarde is nice for publications.
%                                    'font_none' Uses Arial (Default).
%                      'xlabelfontsize_NUM' Set a specific font size for the x-axis LABELS (NOT tick labels)
%                      'ylabelfontsize_NUM' Set a specific font size for the y-axis LABELS (NOT tick labels)
%                      'titlefontsize_NUM'  Set a specific font size for the title
%                      'legendfontsize_NUM'  Set a specific font size for the legend
%                      'ycolor_STR' Sets the y axis color
%                      'xcolor_STR' Sets the x axis color
%                                      
%
% OUTPUTS:
% font_name  : [string] the font name set for the figure. This could be used for xlabel, colorbar etc for which you have to set
% the font maunally
% font_size  : [double] the font size set for the figure
% line_width : [double] a line width size that looks nice (1.5)
%
% Sagi Perel, 09/2008

    if(~exist('eliminate_xticks','var'))
        eliminate_xticks = 0;
    end
    if(~exist('eliminate_yticks','var'))
        eliminate_yticks = 0;
    end
    if(~exist('font_size','var'))
        font_size = 12;
    end
    noptargin = size(varargin,2);
    
    axis_line_width = 1.5;
    do_keep_axis      = false;
    do_x_rotate_label = false;
    
    xaxis_font_size = font_size;
    yaxis_font_size = font_size;
    title_font_size = font_size;
    legend_font_size = font_size;

    % parse the optional varargin
    for i=1:noptargin
        [prefix remain]= strtok(varargin{i}, '_');
        if(~isempty(remain))
            value = remain(2:end);
        end
        switch(prefix)
            case 'axis'
                switch(value)
                    case 'square'
                        do_square_axis = true;
                    case 'none'
                        do_square_axis = false;
                    case 'keep'
                        do_keep_axis = true;
                    case 'x_reverse'
                        set(gca,'XDir','reverse');
                    case 'y_reverse'
                        set(gca,'YDir','reverse');
                    case 'IJ'
                        axis IJ;
                    case 'x_rotate_label'
                        do_x_rotate_label = true;
                        % can't do this code here since it messes up xlabel and ylabel:
%                         % must perform this here so that xticklabel_rotate get the correct font_size
%                         set(gca,'FontSize', font_size);
%                         xticklabel_rotate;
                    case 'x_top'
                        set(gca,'XAxisLocation','top');
                end
            case 'axislinewidth'
                axis_line_width = str2num(value);
            case 'font'
                if(~isempty(value))
                    if(sp_strmatch(value,'none'))
                        font_name = 'Arial';
                    else
                        font_name = value;
                    end
                end
            case 'xlabelfontsize'
                xaxis_font_size = str2num(value);
            case 'ylabelfontsize'
                yaxis_font_size = str2num(value);
            case 'titlefontsize'
                title_font_size = str2num(value);
            case 'legendfontsize'
                legend_font_size = str2num(value);
            case 'ycolor'
                set(gca, 'ycolor',value);
            case 'xcolor'
                set(gca, 'xcolor',value);
            otherwise
                error(['make_plot_nicer: Unknown option ' varargin{i}]);
        end
    end
    
    % choose a default font that postscript supoprts:
    % 'AvantGarde','Helvetica-Narrow','Times-Roman','Bookman','NewCenturySchlbk','ZapfChancery'
    % 'Courier','Palatino','ZapfDingbats','Helvetica','Symbol'
    if(~exist('font_name','var'))
        font_name  = 'Arial';
    end
    if(~exist('do_square_axis','var'))
        do_square_axis  = true;
    end
    
    line_width = 1.5;

    set(gca,'TickDir','out', 'FontName',font_name, 'FontSize', font_size,'LineWidth',axis_line_width);
    
    % default Matlab tick marks are short: default values are: [0.0100    0.0250] [2D 3D]
    % make them x3 longer
    set(gca,'TickLength', [0.0300    0.0250]);
    box off;
    set(get(gca,'XLabel'),'FontName',font_name, 'FontSize', xaxis_font_size);
    set(get(gca,'YLabel'),'FontName',font_name, 'FontSize', yaxis_font_size);
    set(get(gca,'Title'),'FontName',font_name, 'FontSize', title_font_size);
    set(legend,'FontName',font_name, 'FontSize', legend_font_size);
    legend boxoff

    if(do_square_axis)
        axis square
    end
    if(do_x_rotate_label)
        xticklabel_rotate;
    end
    
    set(gcf,'Color','white');
    set(gca,'Color','white');
    
    
    if(eliminate_xticks)
        set(gca,'XTick',[]);
    end
    
    if(eliminate_yticks)
        set(gca,'YTick',[]);
    end
    
    if(eliminate_xticks && eliminate_yticks && ~do_keep_axis)
        axis off;
    end
    
%     if(eliminate_xticks && ~eliminate_yticks)
%         set(gca, 'xcolor',get(gcf,'color'));
%     end
%     if(~eliminate_xticks && eliminate_yticks)
%         set(gca, 'ycolor',get(gcf,'color'));
%     end
    