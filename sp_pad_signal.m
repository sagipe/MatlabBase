function padded_sig = sp_pad_signal(sig, padding_length, padding_type)
% function padded_sig = sp_pad_signal(sig, padding_length, padding_type)
% 
% Pads the signal(s) with mirroed copies of itself, reflected both around the X and Y axis
%
% INPUTS:
% sig           : [array] vector of length N
% padding_length: [int][samples] the required length for padding- should be smaller then the signal length
% [padding_type]: [string] 'reflect' (default), 'zeros'
%
% OUTPUTS:
% padded_sig: [array] column vector with padded signal of length N+2*padding_length
%
% Sagi Perel, 06/2012
    
%     % find the trends (rising/falling) at the edges of the signal
%     num_samples_to_check_for_trend = 4;
%     front_trend = sign(mean(sig(1:num_samples_to_check_for_trend)));
%     if(front_trend == 0), front_trend = 1; end
%     
%     back_trend = sign(mean(sig(end-num_samples_to_check_for_trend:end)));
%     if(back_trend == 0), back_trend = 1; end

    if(nargin < 2 || nargin > 3)
        error('sp_pad_signal: wrong number of input arguments');
    end
    if(~isvector(sig))
        error('sp_pad_signal: sig must be a vector');
    else
        sig = make_column_vector(sig);
    end
    if(~exist('padding_type','var'))
        padding_type = 'reflect';
    else
        if(~any(strcmp(padding_type,{'reflect','zeros'})))
            error('sp_pad_signal: unknown value for padding_type');
        end
    end

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
