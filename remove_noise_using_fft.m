function [clean_sig is_sig_noisy] = remove_noise_using_fft(sig, sig_sampling_freq, noise_center_freq, noise_bandwidth_around_center, SNR)
% This function removes only sinusodial noise at a specific frequency.
% It assumes a continuom in the FFT and interpolates a value for the removed frequency.
% 
% INPUTS:
% sig: [double array OR matrix with signals in columns] the signal to clean the noise from
% sig_sampling_freq: [double] the signal's sampling frequency in Hz
% noise_center_freq: [double] frequency of the noise to remove in Hz
% [noise_bandwidth_around_center]: [double] A side window size where the noise will be removed in near adjunct frequencies.
%                                  Specified in Hz. Default: 1Hz.
% [SNR]: [double] Signal Amplitude/Noise Amplitude- What should the SNR between the average of the signal and the noise be 
%        so that the noise will be removed. Default: 0.5 (noise is at least twice as much as the signal)
%
% OUTPUTS:
% clean_sig   : the signal after the noise has been removed (if the signal was indeed noisy)
% is_sig_noisy: was the signal noisy according to the given SNR. If the signal was NOT noisy- then clean_sig is exactly sig.
%
% For example, remove_noise_using_fft(sig, 60, 1, 0.5) :
% would remove noise at the range (60+-1) 59-61Hz  from the signal, if the noise amplitude at those frequencies (when looking
% at the signal's FFT magnitude) will be (1/0.5) twice as much as the AVERAGE signal magnitude
%
% Sagi Perel, 05/2008, Updated 05/2012

    if(~exist('noise_bandwidth_around_center','var'))
        noise_bandwidth_around_center = 1;
    end
    if(~exist('SNR','var'))
        SNR = 0.5;
    end
    
    sig_class = class(sig);
    if(~strcmp(sig_class, 'double') && ~strcmp(sig_class, 'single'))
        error(['remove_noise_using_fft: supports only arrays of type ''double'' or ''single'', your signal is of type ' sig_class]);
    end
    
    [num_samples num_sig] = size(sig);
    clean_sig = nan(num_samples, num_sig);

    for s=1:num_sig
        % compute the signal's magnitude and phase
        X = fft(sig(:,s), num_samples);
        Xmag   = abs(X);
        Xphase = angle(X);

        % make a frequency vector for the signal's FFT
        f = (0:length(Xmag)-1).*(floor(sig_sampling_freq)./length(Xmag));

        % Create a copy of the signal's magnitude to modify:
        % we keep the phase the same but the magnitude will be changed at the desired frequencies
        Ymag = Xmag;

        % find the average signal magnitude between 0-1000Hz- this is where most of the power is
        average_mag = Cmean(Xmag(f>0 & f<1000));

        % handle all given noise frequencies
        for idx=1:length(noise_center_freq)
            this_noise_center_freq = noise_center_freq(idx);
            % we need to find if the signal is noisy or not
            lowest_noise_freq  = this_noise_center_freq - noise_bandwidth_around_center;
            highest_noise_freq = this_noise_center_freq + noise_bandwidth_around_center;
            [is_sig_noisy frequencies_idx average_mag] = is_the_signal_noisy(Ymag, f, average_mag, lowest_noise_freq, highest_noise_freq, SNR);

            % clean the signal by interpolating the values at the given frequencies    
            % since the 60Hz noise seems to spread anywhere from 2-5Hz around 60Hz, then interpolate based on the values present
            % at twice noise_bandwidth_around_center around this_noise_center_freq 
            before_lowest_freq_to_interpolate = this_noise_center_freq - 2*noise_bandwidth_around_center;
            before_idx_to_interpolate = find((f >= before_lowest_freq_to_interpolate) & (f < f(frequencies_idx(1)) ));
            after_highest_freq_to_interpolate = this_noise_center_freq + 2*noise_bandwidth_around_center;
            after_idx_to_interpolate  = find((f > f(frequencies_idx(end)) ) & (f <= after_highest_freq_to_interpolate));
            % for short signals- the f vector might contain too big jumps in frequency- so one of the idx vectors might be empty
            if(isempty(before_idx_to_interpolate) || isempty(after_idx_to_interpolate))
                % clean the signal by setting the value equal to the average magnitude
                interpolated_value = average_mag;
            else
                % clean the signal by interpolating the magnitude
                interpolated_value = mean(Ymag([before_idx_to_interpolate after_idx_to_interpolate]));
            end        

            % first deal with the first half of the magnitude

            %values = repmat(interpolated_value, [1 length(frequencies_idx)]);        
            %values_to_fill = Ymag(frequencies_idx)' .* ~is_sig_noisy + values .* is_sig_noisy;
            %->the next line does exactly the same and is more efficient
            values_to_fill = Ymag(frequencies_idx)' .* ~is_sig_noisy + is_sig_noisy .* interpolated_value;    
            Ymag(frequencies_idx) = values_to_fill;    
            % then deal with the second half of the magnitude (the reflection)
            num_total_freq_idx = length(Ymag);
            reflected_frequencies_idx = num_total_freq_idx - frequencies_idx + 1;
            is_sig_noisy   = flipud(is_sig_noisy);
            %values_to_fill = Ymag(reflected_frequencies_idx)' .* ~is_sig_noisy + values .* is_sig_noisy;   
            %->the next line does exactly the same and is more efficient
            values_to_fill = Ymag(reflected_frequencies_idx)' .* ~is_sig_noisy + is_sig_noisy .* interpolated_value;   
            Ymag(reflected_frequencies_idx) = values_to_fill;
        end

        % convert the signal back to the time domain
        Y = Ymag .* exp(i.*Xphase);
        Yi = ifft(Y,length(sig));
        clean_sig(:,s) = real(Yi);
    end
    
    % convert to the right type if the user gave us a single array
    if(strcmp(sig_class, 'single'))
        clean_sig = single(clean_sig);
    end
    
%     % debug code
%     figure;
%     subplot(311)
%     plot(f,Xmag);
%     
%     subplot(312)
%     plot(f,Ymag);
%     
%     subplot(313)
%     X2    = fft(clean_sig, length(clean_sig));
%     Xmag2 = abs(X2);
%     plot(f,Xmag2);
%     
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [is_sig_noisy frequencies_idx average_mag] = is_the_signal_noisy(Xmag, f, average_mag, lowest_noise_freq, highest_noise_freq, SNR)
% Determines if the signal is noisy at the given frequencies according to the SNR
    
    % find all the matching frequencies
    frequencies_idx = find((f >= lowest_noise_freq) & (f <= highest_noise_freq));
    num_freq = length(frequencies_idx);
    
    % if at any of the matching frequencies - the noise is greater than the average magnitude by more than 1/SNR then this
    % signal is noisy
    is_sig_noisy = zeros(1,num_freq);
    for i=1:num_freq
        idx_in_Xmag = frequencies_idx(i);
        noise_mag = Xmag(idx_in_Xmag);
        
        if(noise_mag/average_mag >= 1/SNR)
            is_sig_noisy(i) = 1;
        end
    end
