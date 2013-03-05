function legend_handle = sp_boxplot(data, xlabels, rotate_xlabels, plot_lines, font_size, text_above_box)
% function legend_handle = sp_boxplot(data, xlabels, rotate_xlabels, plot_lines, font_size, text_above_box)
%
% Plots a box plot: median, mean, 1st and 3rd quartiles (25th, 75th percentiles), and 5th 95th percentiles as the min and max
%
% INPUTS:
% data     : [matrix] with data in columns OR [cell] with a vector in every cell
% [xlabels]: [cell array] of string names for the x-axis
% [rotate_xlabels]: [bool] Default: false
% [plot_lines]    : [bool] Default: false. Plot lines connecting the means and medians
% [font_size]     : [int] Default: 12
% [text_above_box]: [cell array] of strings to print above each box
%
% OUTPUTS:
% legend_handle: [handle] to the legend
% 
% Sagi Perel, 03/2012

    if(nargin < 1 || nargin > 6)
        error('sp_boxplot: wrong number of input arguments provided');
    end
    if(iscell(data))
        if(~any(cellfun(@isvector, data)))
            error('sp_boxplot: when data is a cell array, every cell must contain only vectors');
        end
        num_variables = length(data);
        num_samples_per_variable = cellfun(@length, data);
        if(any(num_samples_per_variable<2))
            error('sp_boxplot: every variable should have more than 2 samples');
        end
    elseif(ismatrix(data))
        [num_samples num_variables] = size(data);
        if(num_samples < 2)
            error('sp_boxplot: data should have more than 2 samples');
        end
    else
        error('sp_boxplot: data should be a cell array or a matrix');
    end
    if(~exist('xlabels','var') || isempty(xlabels))
        xlabels = get_array_as_string_cell(1:num_variables);
    else
        if(length(xlabels) ~= num_variables)
            error('sp_boxplot: length(xlabels) ~= num_variables');
        end
    end
    if(~exist('rotate_xlabels','var') || isempty(rotate_xlabels))
        rotate_xlabels = false;
    end
    if(~exist('plot_lines','var') || isempty(plot_lines))
        plot_lines = false;
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
        error('sp_boxplot: text_above_box should be a cell array');
    elseif(length(text_above_box) ~= num_variables)
        error('sp_boxplot: length(text_above_box) ~= num_variables');
    elseif(~all(cellfun(@ischar, text_above_box)))
        error('sp_boxplot: text_above_box should be a cell array of strings');
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
    min_y = min(prctiles(1,:));
    max_y = min(prctiles(4,:));
    y_range = max_y - min_y;
    
    %figure;
    hold on;
    x_spacing = 3;
    x = 1 : x_spacing : x_spacing*num_variables;
    x_line_width = 1;
    line_width = 1;
    font_name = 'font_AvantGarde';

    for i=1:num_variables
        xpos = [x(i)-x_line_width x(i)+x_line_width];
        % plot a line for the mean
        line(xpos, [data_mean(i) data_mean(i)],'LineWidth',2,'Color','k');    
        % plot a line for the median
        line(xpos, [data_median(i) data_median(i)],'LineWidth',2,'Color','r');    

        % plot the 5th and 95th percentiles
        line(xpos, [prctiles(1,i) prctiles(1,i)],'LineWidth',line_width,'Color','k','LineStyle','-');
        line(xpos, [prctiles(4,i) prctiles(4,i)],'LineWidth',line_width,'Color','k','LineStyle','-');
        line([x(i) x(i)],[prctiles(1,i) prctiles(2,i)],'LineWidth',line_width,'Color','k','LineStyle','-');
        line([x(i) x(i)],[prctiles(3,i) prctiles(4,i)],'LineWidth',line_width,'Color','k','LineStyle','-');
        
        % display text (if any) above the 95th percentile line
        text(x(i), prctiles(4,i)+y_range*0.1, text_above_box{i}, 'FontSize',font_size,'FontName',font_name);
        
        % plot the 1st 3rd quartiles
        line(xpos, [prctiles(2,i) prctiles(2,i)],'LineWidth',line_width,'Color','k','LineStyle','-');
        line(xpos, [prctiles(3,i) prctiles(3,i)],'LineWidth',line_width,'Color','k','LineStyle','-');
        line([xpos(1) xpos(1)], [prctiles(2,i) prctiles(3,i)], 'LineWidth',line_width,'Color','k','LineStyle','-');
        line([xpos(2) xpos(2)], [prctiles(2,i) prctiles(3,i)], 'LineWidth',line_width,'Color','k','LineStyle','-');
    end
    if(plot_lines)
        plot(x, data_mean, 'k','LineWidth',2);
        plot(x, data_median, 'r','LineWidth',2);
    end
    hold off;
    
    if(~isempty(xlabels))
        set_axis_labels(gca, x, xlabels, 'x');
    end
    legend_handle = legend({'Mean','Median'},'Location','Best');

    if(rotate_xlabels)
        make_plot_nicer(0,0,font_size,font_name,'axis_x_rotate_label');
    else
        make_plot_nicer(0,0,font_size,font_name);
    end
    