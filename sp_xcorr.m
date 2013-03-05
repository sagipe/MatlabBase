function [correlation_coeff lags x y] = sp_xcorr( x, y, x_time, y_time, normalization_method)
%
% Computes cross correlation using Matlab's xcorr (this is NOT Pearson's r)
% If the two input signals are not the same length, Matlab xcorr will pad the shorter signal with zeros to the longer signal's
% length.
% Instead, this function will interploate the shorter signal to the longer signal length.
% If x_time,y_time are specified- the short signal's interpolated values will be at the same times specified in y_time
% 
% MAKE SURE THIS IS THE INTENDED BEHAVIOUR YOU WANT. Else check sp_xcorr2()
%
% INPUTS:
% x                     : [double array] the first signal  with length N
% y                     : [double array] the second signal with length M
% [x_time]              : [double array] times of the samples in x
% [y_time]              : [double array] times of the samples in y
% [normalization_method]: [string] normalization method for xcorr. Default: 'coeff'
%
% OUTPUTS:
% correlation_coeff: [double array] sized 2*(max(N,M))-1 with correlation coefficients
% lags             : lags for the given coefficients
% x                : x signal used for xcorr
% y                : y signal used for xcorr
%
% 
% Sagi Perel, 08/2008

    %--- sanity check on inputs
    if(nargin < 2 || nargin == 3)
        error('sp_xcorr: missing required input arguments');
    end
    if(nargin > 5)
        error('sp_xcorr: too many input arguments');
    end
    if(~isvector(x) || ~isvector(y))
        error('sp_xcorr: only supports vector signals');
    end
    
    N = length(x);
    M = length(y);
    
    if(nargin == 2)
        x_time = [];
        y_time = [];
    end
    if(nargin == 4)
        if(~isvector(x_time) || ~isvector(y_time))
            error('sp_xcorr: x_time and y_time should be non empty vectors');
        end
        if(length(x_time) ~= N || length(y_time) ~= M)
            error('sp_xcorr: x_time and y_time should have the same length as x and y');
        end
    end
    if(~exist('normalization_method','var'))
        normalization_method = 'coeff';
    end
    
    
    %--- resample signals if they are not the same legnth
    %-- if the user did not specify times- both signals should be at the same sampling rate
    if(isempty(x_time)) % trust the user to provide the right indices for the two signals
        % resampling to the shorter length- takes too much time to compute the filter
        % so this will stay commented for now
        %     if(N > M)
        %         x = sp_resample(x, M, N);
        %     end
        %     if(N < M)
        %         y = sp_resample(y, N, M);
        %     end


        % interpolate the shorter signal (a faster way then resampling)
        if(N > M) % length(x) > length(y)
            idx         = 1:M;
            splined_idx = 1 : (M-1)/(N-1) : N;
            y = interp1(idx, y, splined_idx,'spline');
        end
        if(N < M) % length(x) < length(y)
            idx         = 1:N;
            splined_idx = 1 : (N-1)/(M-1) : N;
            x = interp1(idx, x, splined_idx,'spline');
        end
    else
        %-- if the user specified times- both signals may be at different sampling rates
        % interpolate using the given times: the shorter signal will be interpolated to the longer one's length
        if(N > M) % length(x) > length(y)
            y = interp1(y_time, y, x_time,'spline');
        end
        if(N < M) % length(x) < length(y)
            x = interp1(x_time, x, y_time,'spline');
        end
    end
    
    %--- compute cross correlation
    [correlation_coeff lags] = xcorr(x,y,normalization_method);
    