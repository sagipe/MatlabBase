function padded_sig = pad_signal(sig, padding_length, padding_type, end_to_pad)
% function padded_sig = pad_signal(sig, padding_length, end_to_pad)
% 
% Pads the signal with the following options:
% (1) You can specify which ends to pad 
% (2) You can specify the type of padding: zeros; mean value around the edge; mirroed copies of itself, reflected both around the X and Y axis
%
% INPUTS:
% sig           : [double] column vector
% padding_length: [double] the required length for padding- should be smaller then the signal length
% [padding_type]: [string] what type of padding to apply.  Options are: 'zeros', 'mean', 'mirror' (default)
% [end_to_pad]  : [string] which end of the signal to pad. Options are: 'both' (default), 'front', 'end'
%
% OUTPUTS:
% padded_sig: [double] the padded signal
%
% Sagi Perel, 11/2008

    %--- process input variables
    if(~exist('padding_type','var'))
        padding_type = 'mirror';
    end
    if(~exist('end_to_pad','var'))
        end_to_pad = 'both';
    end
    
    %--- make sure the signal is a column vector
    [nrows ncols] = size(sig);
    if(nrows > 1 && ncols >1)
        error('pad_signal: this function only supports 1D vectors');
    else
        % convert the signal to a column vector
        if(nrows == 1 && ncols > 1)
            sig = sig';
        end           
    end
    
    if(padding_length == 0)
        padded_sig = sig;
        return;
    end

    %--- create the pads
    switch(padding_type)
        case 'zeros'
            front_pad = zeros([padding_length 1]);
            back_pad  = zeros([padding_length 1]);
            
        case 'mean'
            num_samples_to_check_for_mean = min(length(sig),4); % arbitrary- this really depends on fs for this signal
            front_pad = repmat(mean(sig(1:num_samples_to_check_for_mean)),   [padding_length 1]);
            back_pad  = repmat(mean(sig(end:-1:end-num_samples_to_check_for_mean+1)), [padding_length 1]);
            
        case 'mirror'
            % find the trends (rising/falling) at the edges of the signal
            num_samples_to_check_for_trend = min(length(sig),4); % arbitrary- this really depends on fs for this signal
            front_trend = sign(mean(sig(1:num_samples_to_check_for_trend)));
            if(front_trend == 0), front_trend = 1; end

            back_trend = sign(mean(sig(end-num_samples_to_check_for_trend:end)));
            if(back_trend == 0), back_trend = 1; end

            % make the paddings
            front_pad = sig(padding_length+1:-1:2) - repmat(sig(1),[padding_length 1]);
            front_pad = repmat(sig(1),[padding_length 1]) - front_pad;  

            back_pad  = sig(end-1:-1:end-padding_length) - repmat(sig(end),[padding_length 1]);
            back_pad  = repmat(sig(end),[padding_length 1]) - back_pad;
            
        otherwise
            error(['pad_signal: unkown padding_type=[' padding_type ']']);
    end
    

    %--- pad the signal
    switch(end_to_pad)
        case 'both'
            padded_sig = [front_pad; sig; back_pad];
        case 'front'
            padded_sig = [front_pad; sig];
        case 'end'
            padded_sig = [sig; back_pad];
        otherwise
            error(['pad_signal: unkown end_to_pad=[' end_to_pad ']']);
    end
    