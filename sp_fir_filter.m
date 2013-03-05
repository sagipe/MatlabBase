function filtered_sig = sp_fir_filter(sig,fir_filter, padding_type)
%
% Filters the given signal using the given fir filter
% This function also removes group delay, and mirrors the signal to minimize edge effects.
%
% INPUTS:
% sig        : [array] signal to filter
% fir_filter : [array] fir filter to use 
% [padding_type]: [string] the padding type to use {'zeros', 'reflect' (default)}
%
% OUTPUTS:
% the filtered signal
%
% Sagi Perel, April 2008

    % sanity check on inputs    
    if(nargin > 3 || nargin < 2)
        error('sp_fir_filter: missing/ too many arguments supplied');
    end
    if(~exist('padding_type','var'))
        padding_type = 'reflect';
    end
    
    
    [nrows ncols] = size(sig);
    if(nrows > 1 && ncols >1)
        error('sp_resample: this function only supports 1D vectors');
    else
        % convert the signal to a column vector
        if(nrows == 1 && ncols > 1)
            sig = sig';
        end           
    end
    
    % pad the signal with a mirrored copy to eliminate as much of the edge effects as possible.
    % I assume that the padding length will not exceed the signal length (meaning the signal is longer then the filter)
    filter_length  = length(fir_filter);
    filter_delay   = floor((filter_length-1)/2);
    padding_length = floor(filter_length/2);
    padded_sig = pad_signal(sig,padding_length, padding_type);
    % now pad the signal to eliminate delay
    delay_padding = zeros(filter_length-1,1);
    padded_sig = [padded_sig; delay_padding];
    
    % filter the signal
    filtered_sig = filter( fir_filter, 1, padded_sig);

    % get rid of the padding & group delay (filter_half_length samples at the beginning & end)
    num_samples_to_remove_from_left_edge  = filter_delay;
    num_samples_to_remove_from_right_edge = filter_length - 1 - num_samples_to_remove_from_left_edge;
    filtered_sig = filtered_sig(num_samples_to_remove_from_left_edge+1 : end-num_samples_to_remove_from_right_edge);
    filtered_sig = filtered_sig(padding_length+1: end-padding_length,:);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function padded_sig = pad_signal(sig, padding_length, padding_type)
% Pads the signal with mirroed copies of itself, reflected both around the X and Y axis
%
% INPUTS:
% sig: column vector
% padding_length: the required length for padding- should be smaller then the signal length
    
    % find the trends (rising/falling) at the edges of the signal
    num_samples_to_check_for_trend = 4;
    front_trend = sign(mean(sig(1:num_samples_to_check_for_trend)));
    if(front_trend == 0), front_trend = 1; end
    
    back_trend = sign(mean(sig(end-num_samples_to_check_for_trend:end)));
    if(back_trend == 0), back_trend = 1; end

    % make the paddings
    switch(padding_type)
        case 'reflect'
            front_pad = sig(padding_length+1:-1:2) - repmat(sig(1),[padding_length 1]);
            front_pad = repmat(sig(1),[padding_length 1]) - front_pad;  

            back_pad  = sig(end-1:-1:end-padding_length) - repmat(sig(end),[padding_length 1]);
            back_pad  = repmat(sig(end),[padding_length 1]) - back_pad;
        case 'zeros'
            front_pad = zeros(padding_length,1);
            back_pad  = front_pad;
    end
            
    padded_sig = [front_pad; sig; back_pad];

