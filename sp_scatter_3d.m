function XY = sp_scatter_3d(X, Y, num_X_bins, num_Y_bins)
% function XY = sp_scatter_3d(X, Y, num_X_bins, num_Y_bins)
%
% Bins the data in X,Y to create a 2D matrix with the number of occurrences of every combination
% of data values.
% 
% Sagi Perel, 04/2011

    if(nargin < 2 || nargin > 4)
        error('sp_scatter_3d: wrong number of input arguments provided');
    end    
    if(~isvector(X))
        error('sp_scatter_3d: X should be a vector');
    end
    if(~isvector(Y))
        error('sp_scatter_3d: Y should be a vector');
    end
    if(length(X) ~= length(Y))
        error('sp_scatter_3d: X and Y should have the same number of elements');
    end
    if(~exist('num_X_bins','var'))
        num_X_bins = [];
    end
    if(~exist('num_Y_bins','var'))
        num_Y_bins = [];
    end

    [binned_Y, ~, X_bin_start_values] = bin_by_factor(Y,X,num_X_bins);
    num_X_bins = length(binned_Y);
    
    sorted_Y = sort(Y);
    if(isempty(num_Y_bins))
        num_Y_bins = round(sqrt(sorted_Y(end) - sorted_Y(1)));
    end
    Y_bin_start_values = sorted_Y(1) : (sorted_Y(end)-sorted_Y(1))/num_Y_bins : sorted_Y(end);
    Y_bin_start_values(end) = [];
    
    XY = zeros(num_Y_bins, num_X_bins);
    for i=1:num_X_bins
        if(~isempty(binned_Y{i}))
            XY(:,i) = histc(binned_Y{i}, Y_bin_start_values);
        end
    end
    
    bar3(XY);
    set_axis_labels(gca, 1:num_X_bins, get_array_as_string_cell(X_bin_start_values(1:end-1)), 'x');
    set_axis_labels(gca, 1:num_Y_bins, get_array_as_string_cell(Y_bin_start_values(1:end  )), 'y');
    xlabel('X');
    ylabel('Y');