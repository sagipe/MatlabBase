function [min_y max_y patch_handles] = sp_boxplot_slim(data, xlabels, rotate_xlabels, font_size, text_above_box, text_above_box_font_size, marker_type, ignore_potential_outliers)
% function [min_y max_y patch_handles] = sp_boxplot_slim(data, xlabels, rotate_xlabels, plot_lines, font_size, text_above_box, text_above_box_font_size, marker_type, ignore_potential_outliers)
%
% Plots a box plot with thin bars- works well when data contains a lot of columns
% Plots median, mean, 1st and 3rd quartiles (25th, 75th percentiles), and 5th 95th percentiles as the min and max
%
% INPUTS:
% data     : [matrix] with data in columns OR [cell] with a vector in every cell
% [xlabels]: [cell array] of string names for the x-axis
% [rotate_xlabels]: [bool] Default: false
% [font_size]     : [int] Default: 12
% [text_above_box]: [cell array] of strings to print above each box
% [text_above_box_font_size] : [int] Default: 10
% [marker_type]   : [string] Type of marker for the whiskers: 'line' (Default), 'arrow'
% [ignore_potential_outliers]: [bool] Default: false. Rescales y-axis to ignore potential outliers
%
% OUTPUTS:
% min_y : [int] Minimal Y value across all bars
% max_y : [int] Maximal Y value across all bars
% patch_handles: [handles] to the bar patches
% 
% Sagi Perel, 03/2012

    if(nargin < 1 || nargin > 8)
        error('sp_boxplot_slim: wrong number of input arguments provided');
    end
    if(iscell(data))
        if(~any(cellfun(@isvector, data)))
            error('sp_boxplot_slim: when data is a cell array, every cell must contain only vectors');
        end
        num_variables = length(data);
        num_samples_per_variable = cellfun(@length, data);
        if(any(num_samples_per_variable<2))
            error('sp_boxplot_slim: every variable should have more than 2 samples');
        end
    elseif(ismatrix(data))
        [num_samples num_variables] = size(data);
        if(num_samples < 2)
            error('sp_boxplot_slim: data should have more than 2 samples');
        end
    else
        error('sp_boxplot_slim: data should be a cell array or a matrix');
    end
    if(~exist('xlabels','var') || isempty(xlabels))
        xlabels = get_array_as_string_cell(1:num_variables);
    else
        if(length(xlabels) ~= num_variables)
            error('sp_boxplot_slim: length(xlabels) ~= num_variables');
        end
    end
    if(~exist('rotate_xlabels','var') || isempty(rotate_xlabels))
        rotate_xlabels = false;
    end
    if(~exist('font_size','var') || isempty(font_size))
        font_size = 12;
    end
    if(~exist('text_above_box','var') || isempty(text_above_box))
        text_above_box = cell(1, num_variables);
        for i=1:num_variables
            text_above_box{i} = '';
        end
    elseif(~iscell(text_above_box))
        error('sp_boxplot_slim: text_above_box should be a cell array');
    elseif(length(text_above_box) ~= num_variables)
        error('sp_boxplot_slim: length(text_above_box) ~= num_variables');
    elseif(~all(cellfun(@ischar, text_above_box)))
        error('sp_boxplot_slim: text_above_box should be a cell array of strings');
    end
    if(~exist('text_above_box_font_size','var') || isempty(text_above_box_font_size))
        text_above_box_font_size = 12;
    end
    if(~exist('marker_type','var') || isempty(marker_type))
        marker_type = 'line';
    elseif(~ischar(marker_type))
        error('sp_boxplot_slim: marker_type should be a string');
    elseif(~any(strcmp(marker_type,{'line','arrow'})))
        error(['sp_boxplot_slim: unknown value [' marker_type '] for marker_type']);
    end
    if(~exist('ignore_potential_outliers','var') || isempty(ignore_potential_outliers))
        ignore_potential_outliers = false;
    end    
    
    if(iscell(data))
        data_mean = cellfun(@nanmean, data);
        data_median = cellfun(@nanmedian, data);
    else
        data_mean = nanmean(data);
        data_median = nanmedian(data);
    end

    prctiles = nan(4,num_variables);
    for i=1:num_variables
        if(iscell(data))
            Y = prctile(data{i},[5 25 75 95]);
        else
            Y = prctile(data(:,i),[5 25 75 95]);
        end
        prctiles(:,i) = Y;
    end

    % estimate min & max Y values and Y range for this plot
    if(ignore_potential_outliers)
        min_y = prctile(prctiles(1,:),5);
        max_y = prctile(prctiles(4,:),95);
        y_range = max_y - min_y;
    else
        min_y = min(prctiles(1,:));
        max_y = max(prctiles(4,:));
        y_range = max_y - min_y;
    end
    
    %figure;
    hold on;
    x_spacing = 1;
    x = 1 : x_spacing : x_spacing*num_variables;    
    
    patch_color = [.8 .8 .8];
    font_name = 'AvantGarde';
    
    bar_half_width = 0.4; % bar width leave 10% spacing on every side of the bar
    
    mean_line_width   = 2;
    mean_line_color   = 'k';
    mean_line_style   = '-';
    
    median_line_width = 3;
    median_line_color = 'r';
    median_line_style   = ':';
        
    patch_handles = nan(1,num_variables);
    for i=1:num_variables
        min_x = x(i)-bar_half_width;
        max_x = x(i)+bar_half_width;
        xpos = [min_x max_x];
        
        % plot a patch for the 1st and 3rd quartiles
        this_min_y = prctiles(2,i);
        this_max_y = prctiles(3,i);        
        X = [min_x; min_x; max_x; max_x];
        Y = [this_min_y; this_max_y; this_max_y; this_min_y];
        tcolor(1,1,1:3) = patch_color;
        % X and Y are m-by-n matrices, MATLAB draws n polygons with m vertices.
        h(i) = patch(X,Y,tcolor);
        
        % plot a line for the mean
        line(xpos, [data_mean(i) data_mean(i)],'LineWidth',mean_line_width,'Color',mean_line_color,'LineStyle',mean_line_style);    
        % plot a line for the median
        line(xpos, [data_median(i) data_median(i)],'LineWidth',median_line_width,'Color',median_line_color,'LineStyle',median_line_style);    

        % plot the 5th and 95th percentiles
        switch(marker_type)
            case 'line'
                line(xpos, [prctiles(1,i) prctiles(1,i)],'LineWidth',1,'Color','k','LineStyle','-');
                line(xpos, [prctiles(4,i) prctiles(4,i)],'LineWidth',1,'Color','k','LineStyle','-');
            case 'arrow'
                plot(x(i), prctiles(1,i), 'Marker', 'v', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
                plot(x(i), prctiles(4,i), 'Marker', '^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
        end        
        
        % plot lines from 1st and 3rd quartiles to the 5th and 95th percentiles
        line([x(i) x(i)], [prctiles(1,i) prctiles(2,i)],'LineWidth',1,'Color','k','LineStyle','-');
        line([x(i) x(i)], [prctiles(3,i) prctiles(4,i)],'LineWidth',1,'Color','k','LineStyle','-');
        
        % display text (if any) above the 95th percentile line
        text(min_x, prctiles(4,i)+y_range*0.05, text_above_box{i}, 'FontSize',text_above_box_font_size,'FontName',font_name);
    end
    hold off;
    if(ignore_potential_outliers)
        ylim([min_y max_y]);
    end
    
    if(~isempty(xlabels))
        set_axis_labels(gca, x, xlabels, 'x');
    end

    if(rotate_xlabels)
        make_plot_nicer(0,0,font_size,['font_' font_name],'axis_x_rotate_label','axis_none');
    else
        make_plot_nicer(0,0,font_size,['font_' font_name],'axis_none');
    end
    