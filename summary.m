function summary(data, condense_output)
% function summary(data, condense_output)
% 
% Prints out the Min, Max, Mean and Median values of a vector, of columns of a matrix
% Also notifies if any NaN values exist
%
% INPUTS:
% data: [matrix] of data values
% [condense_output]: [bool] Default: false. Print rounded values up to two digits to the right of the decimal point.
%
% Sagi Perel, 01/2011

    if(nargin < 1 || nargin > 2)
        error('summary: wrong number of input arguments provided');
    end
    if(isempty(data))
        error('summary: data is empty');
    end
    if(~exist('condense_output','var'))
        condense_output = false;
    end
    
    if(isvector(data))
        print_stats(data, false, condense_output);
    else
        num_cols = size(data, 2);
        stats_cell = cell(9,num_cols);
        for c=1:num_cols
            stats_cell{1,c} = ['Col ' num2str(c)];
            stats = print_stats(data(:,c), true, condense_output);
            for i=1:length(stats)
                stats_cell{i+1,c} = stats{i};
            end
        end
        disp(stats_cell);
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stats_str = print_stats(data, supress_output, condense_output)
    data_min = nanmin(data);
    data_max = nanmax(data);
    data_median = nanmedian(data);
    data_mean = nanmean(data);
    num_nan = sum(isnan(data));
    data_len = length(data);
    data_var = nanvar(data);
    data_std = nanstd(data);
    data_prctiles = prctile(data, [5 25 75 95]);
    
    stats_str = {};
    
    stats_str{end+1} = ['Size: [' num2str(size(data)) ']'];
    if(num_nan >0)
        stats_str{end} = [stats_str{end} ' | #NaN: ' num2str(num_nan) ' out of ' num2str(data_len)];
    end
    if(condense_output)
        stats_str{end+1}=['Min: ' sp_sprintf(data_min)];
        stats_str{end+1}=['Median: ' sp_sprintf(data_median)];
        stats_str{end+1}=['Mean: ' sp_sprintf(data_mean)];
        stats_str{end+1}=['Max: ' sp_sprintf(data_max)];
        stats_str{end+1}=['Var: ' sp_sprintf(data_var)];
        stats_str{end+1}=['SD: ' sp_sprintf(data_std)];
        stats_str{end+1}=['Range: ' sp_sprintf(data_max-data_min)];
        stats_str{end+1}=['5th prc: ' sp_sprintf(data_prctiles(1))];
        stats_str{end+1}=['25th prc: ' sp_sprintf(data_prctiles(2))];
        stats_str{end+1}=['75th prc: ' sp_sprintf(data_prctiles(3))];
        stats_str{end+1}=['95th prc: ' sp_sprintf(data_prctiles(4))];
    else
        stats_str{end+1}=['Min: ' num2str(data_min)];
        stats_str{end+1}=['Median: ' num2str(data_median)];
        stats_str{end+1}=['Mean: ' num2str(data_mean)];
        stats_str{end+1}=['Max: ' num2str(data_max)];
        stats_str{end+1}=['Var: ' num2str(data_var)];
        stats_str{end+1}=['SD: ' num2str(data_std)];
        stats_str{end+1}=['Range: ' num2str(data_max-data_min)];
        stats_str{end+1}=['5th prc: ' num2str(data_prctiles(1))];
        stats_str{end+1}=['25th prc: ' num2str(data_prctiles(2))];
        stats_str{end+1}=['75th prc: ' num2str(data_prctiles(3))];
        stats_str{end+1}=['95th prc: ' num2str(data_prctiles(4))];
    end
    
    if(~supress_output)
        for i=1:length(stats_str)
            disp(stats_str{i});
        end
    end

