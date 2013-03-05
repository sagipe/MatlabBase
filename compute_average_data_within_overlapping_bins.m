function normalized_bin_averages = compute_average_data_within_overlapping_bins(time, data, bin_size, bin_start_times, normalizing_mean, normalizing_std)
% function normalized_bin_averages = compute_average_data_within_overlapping_bins(time, data, bin_size, bin_start_times, normalizing_mean, normalizing_std)
%
% Computes the average value of the data matrix in bins - specified by bin_start_times
% The value per bin will be: (bin_average - normalizing_mean) / normalizing_std
% This function assumes that the bin sizes are all the same and specified by bin_size_sec
%
% INPUTS:
% time: [array] with length N
% data: [matrix][N x P] N data samples for P variables
% bin_size          : [double] in the same time units as time, specifying the bin width
% bin_start_times   : [array] with length L (must be L>2 bins), in the same time units as time, specifying the beginning time of every bin
% [normalizing_mean]: [double] Default: 0. Mean to normalize the data by
% [normalizing_std] : [double] Default: 1. STD to normalize the data by
%
% OUTPUTS:
% normalized_bin_averages: [array] [L x P] with the normalized average data value in every bin. 
%                          NaN values are filled for bins with no data in them
%
% Sagi Perel, 10/2012

    if(nargin < 4 || nargin > 6)
        error('compute_average_data_within_overlapping_bins: wrong number of input arguments provided');
    end
    if(~isvector(time) || ~isvector(bin_start_times))
        error('compute_average_data_within_overlapping_bins: input arguments must be vectors');
    end
    [N, P] = size(data);
    if(length(time) ~= N)
        error('compute_average_data_within_overlapping_bins: time and data must have the number of samples');
    end
    if(isvector(data))
        data = make_column_vector(data);
    end
    if(~isscalar(bin_size))
        error('compute_average_data_within_overlapping_bins: bin_size must be a double');
    end
    
    num_bins = length(bin_start_times);
    if(num_bins < 2)
        error('compute_average_data_within_bins: bin_start_times must have at least 2 bins');
    end
    if(~exist('normalizing_mean','var'))
        normalizing_mean = 0;
    end
    if(~exist('normalizing_std','var'))
        normalizing_std = 1;
    end
    
    normalized_bin_averages = nan(num_bins,P);   
    for i=1:num_bins
        data_to_average = data( time > bin_start_times(i) & time <= (bin_start_times(i)+bin_size), :); % [M x P]
        if(~isempty(data_to_average))
            bin_average = nanmean(data_to_average);% [1 x P]
            normalized_bin_averages(i,:) = (bin_average - normalizing_mean) ./ normalizing_std;
        end
    end
    
    