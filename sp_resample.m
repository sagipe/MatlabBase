function varargout = sp_resample(sig, L, M, anti_aliasing_filter, polyphase_filters_length)
%
% Resamples the given signal by the ratio given by the interpolation factor L and decimation factor M- so that the sampling
% rate of the output would be: sig_sampling_rate * L / M .
%
% This function uses the mex function upfirdn( ), so it should be relatively fast.
%
% The input signal is upsampled, filtered using an optimal length muli-phasic anti aliasing filter and then downsampled.
% The anti aliasing filter has an optimal length and is designed using a Kaiser window. Since it's only used as a LPF- this
% window design should be OK- e.g. we don't really care about ripples since the attenuation is preety high (-80dB).
%
% This function also removes group delay, and mirrors the signal to minimize edge effects.
% 
% One word of caution- this function will not work well for short signals (less than 1000-2000 samples) because of the filter
% design. This can be modified if needed.
%
% INPUTS:
% [sig]: [array] signal to resample. If sig is empty and L,M are specified- then the anti aliasing filter is returned
% L    : [integer value] interpolation factor
% M    : [integer value] decimation factor
% [anti_aliasing_filter]: fir filter to use for anti aliasing. If none is specified (default) then this function computes a
%                         polyphasic filter to use
% [polyphase_filters_length]: polyphasic filter length for the given fir filter (if polyphasic, else do not specify anything)
%
% OUTPUTS:
% the resampled signal, or the anti-aliasing filter
%
% Sagi Perel, April 2008

    % sanity check on inputs    
    if(~exist('anti_aliasing_filter','var'))
        attenuation_dB = 80;
        [anti_aliasing_filter polyphase_filters_length]= create_anti_alising_filter(L, M, attenuation_dB);
    end
    if(isempty(sig))
        varargout{1} = anti_aliasing_filter;
        varargout{2} = polyphase_filters_length;
        return;
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
    if(exist('polyphase_filters_length','var'))
        % use the polyphase filter length
        filter_half_length = floor(polyphase_filters_length / 2);
    else
        % If the user specified a filter- use its length
        filter_half_length = floor(length(anti_aliasing_filter)/2);
    end
    padding_length = filter_half_length;
    sig = pad_signal(sig,padding_length);
    % resample the signal
    resampled_sig = upfirdn(sig,anti_aliasing_filter,L,M);
    % get rid of the padding & group delay (filter_half_length samples at the beginning & end)
    current_padding_length = ceil(padding_length * L / M);
    current_group_delay    = round(filter_half_length * L / M);
    num_samples_to_remove_from_edge = current_padding_length + current_group_delay;
    varargout{1} = resampled_sig(num_samples_to_remove_from_edge+1 : end-num_samples_to_remove_from_edge);
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [filt polyphase_filters_length]= create_anti_alising_filter(L, M, attenuation_dB)
%
% Computes an fir anti aliasing filter
%
% INPUTS: 
% L: interpolation factor
% M: decimation factor
% attenuation_dB: required attenuation in dB for 
%
% OUTPUTS:
% filt: the anti aliasing filter

    TW  = 1/(2*max(L,M));  % Transition Width
    Ast = attenuation_dB;  % Stopband Attenuation
    d   = fdesign.rsrc(L,M,'Nyquist',M,TW,Ast);
    H   = design(d,'kaiserwin');
    p   = polyphase(H);
    N   = (size(p,2))*(L-1);
    
    polyphase_filters_length = size(p,2);
    
    filter_attenuation = 80; % [dB] required sidelobe attenutaion of the filter
    kaiser_beta        = 0.1102*(filter_attenuation - 8.7); % sidelobe attenuation of the kaiser window    
    filt   = fir1(N,1/M,kaiser(N+1,kaiser_beta));
    filt   = L*filt; % Passband gain = L

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function padded_sig = pad_signal(sig, padding_length)
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
    front_pad = sig(padding_length+1:-1:2) - repmat(sig(1),[padding_length 1]);
    front_pad = repmat(sig(1),[padding_length 1]) - front_pad;  
    
    back_pad  = sig(end-1:-1:end-padding_length) - repmat(sig(end),[padding_length 1]);
    back_pad  = repmat(sig(end),[padding_length 1]) - back_pad;

    padded_sig = [front_pad; sig; back_pad];

