function correlation_coeff = sp_xcorr2(template, time_series, normalize, num_samples_for_std)
% function correlation_coeff = sp_xcorr2(template, time_series, normalize, num_samples_for_std)
%
% * Computes normalized cross correlation using Matlab's conv (this is NOT Pearson's r)
%   between the given template and the time series.
% * Makes sure that: length(template) <= length(time series)
% * Every coefficient of the resulting xcorr is computed using:
%   r(d) = sum( (x[i] - mx)*(y[i-d] - my) ) ./ ( (M-1) * sqrt( (1/M)*(sum(x(i) - mx))^2) * sqrt( (1/M)*(sum(y(i) - my))^2) )
%   Where r(0) is the correlation at lag zero - meaning both the template and the time series start at 1
%   The last N-1 coefficients are ones where the template is partially past the time series, and it's assumed the time series is zeros there
%
% INPUTS:
% template   : [double array][length N]
% time_series: [double array][length M]
% [normalize]: [bool] Default: 1. Should the correlation coefficients be normalized by the auto correlation
% [num_samples_for_std]: [double] how many samples should be used to calculate the local std for the time series and the template.
%                        For the template, it will be padded with zeroes to that length. For the time series, it will be computed from the sample
%                        where the template starts onwards.
%                        Default: N*3
%
% OUTPUTS:
% correlation_coeff: [double array][length M][same orientation as template] with correlation coefficients
% 
% Sagi Perel, 04/2009

    %--- sanity check on inputs
    if(nargin < 2 || nargin > 4)
        error('sp_xcorr2: wrong number of input arguments supplied');
    end
    if(~isvector(template) || ~isvector(time_series))
        error('sp_xcorr2: inputs must be vectors');
    end
    if(isempty(template) || isempty(time_series))
        error('sp_xcorr2: inputs cannot be empty');
    end
    
    N = length(template);
    M = length(time_series);
    if(N > M)
        error('sp_xcorr2: length(template) > length(time_series)');
    end
    
    if(~exist('normalize','var'))
        normalize = 1;
    end
    if(~exist('num_samples_for_std','var'))
        num_samples_for_std = N*3;
    else
        if(isempty(num_samples_for_std))
            error('sp_xcorr2: num_samples_for_std cannot be empty');
        end
        if(num_samples_for_std < N)
            error('sp_xcorr2: num_samples_for_std must be at least length(template)');
        end
    end
    
    %--- center the signals
    template    = template - Cmean(make_column_vector(template));
    time_series = time_series - Cmean(make_column_vector(time_series));
    
    %--- compute the sum part of the correlation coefficients
    % correlation can be computed using conv if we reverse the 1st input
    % conv returns an output that has the same orientation as the second argument (row / column)
    correlation_coeff = conv(template(end:-1:1), time_series);
    % correlation_coeff has length of N+M-1 . Since we are interested in matches of the template within the time series- then drop the first N-1 elements which
    % correspond to the convolution values of the template & series where the template has negative lags
    % Leave the last N-1 elements (where the template is partially past the time series) to make the output has the same length as the time series
    correlation_coeff = correlation_coeff(N:end);
    if(normalize)
%           % OLD WAY
%         % compute the auto correlations so we can normalize c
%         padded_template = pad_signal(template, round((M-N)/2), 'zeros', 'both');
%         template_auto_c = sqrt((1/M) .* sum(padded_template.^2));
%         time_series_c   = sqrt((1/M) .* sum(time_series.^2));

        % NEW WAY
        % new way to compute the std: compute the zero padded snippet std, also compute the std of the time series for num_samples_for_std samples
        % compute the std for the padded template
        padded_template = pad_signal(template, round((N-num_samples_for_std)), 'zeros', 'end');
        template_auto_c = sqrt((1/length(padded_template)) .* sum(padded_template.^2));
        
        % compute the std for the time series, for indices where num_samples_for_std does not go beyond the last index
        time_series_c = zeros(size(time_series));
        for i=1:(M-num_samples_for_std+1)
           time_series_c(i) = std(time_series(i:i+num_samples_for_std-1));
        end
        % zero pad the time series for the last indices
        for i=(M-num_samples_for_std+2):M
            num_zero_pads = num_samples_for_std - (M - i + 1); % num_samples_for_std - (num samples within the time series)
            padded_time_series = pad_signal(time_series(i:end), num_zero_pads, 'zeros', 'end');
            time_series_c(i) = std(padded_time_series);
         end
        
        correlation_coeff = correlation_coeff ./ ((num_samples_for_std-1) * template_auto_c .* time_series_c);
    end
    